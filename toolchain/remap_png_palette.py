#!/usr/bin/env python3
"""Remap palette indices in a palettized PNG to fixed Amiga color positions.

Colors are NOT changed — they are moved to new palette slots:
  Entries  0-15 (1-based  1-16): #00ffff  (placeholder / unused)
  Entries 16-31 (1-based 17-32): 16 Amiga ECS colors in order:
      #0000aa #000000 #ffffff #aa0000 #aa00aa #555555 #aa5500 #00aa00
      #ff5555 #00aaaa #aaaaaa #55ff55 #55ffff #ffff55 #5555ff #ff5500

All pixel index values in the image are remapped accordingly so that
the visual appearance is identical to the original.

Usage:
    python remap_png_palette.py input.png [output.png]
    Omitting output.png overwrites the input file in place.
"""

import struct
import sys
import zlib

# Target colors for palette entries 16-31 (0-based), i.e. 17-32 (1-based)
TARGET_COLORS = [
    (0x00, 0x00, 0xaa), (0x00, 0x00, 0x00), (0xff, 0xff, 0xff), (0xaa, 0x00, 0x00),
    (0xaa, 0x00, 0xaa), (0x55, 0x55, 0x55), (0xaa, 0x55, 0x00), (0x00, 0xaa, 0x00),
    (0xff, 0x55, 0x55), (0x00, 0xaa, 0xaa), (0xaa, 0xaa, 0xaa), (0x55, 0xff, 0x55),
    (0x55, 0xff, 0xff), (0xff, 0xff, 0x55), (0x55, 0x55, 0xff), (0xff, 0x55, 0x00),
]
PLACEHOLDER = (0x00, 0xff, 0xff)

PNG_SIG = b'\x89PNG\r\n\x1a\n'


# ---------------------------------------------------------------------------
# PNG chunk I/O
# ---------------------------------------------------------------------------

def read_chunks(data):
    assert data[:8] == PNG_SIG, "Not a PNG file"
    chunks, pos = [], 8
    while pos < len(data):
        n = struct.unpack('>I', data[pos:pos + 4])[0]
        t = data[pos + 4:pos + 8]
        d = data[pos + 8:pos + 8 + n]
        chunks.append((t, d))
        pos += 12 + n
    return chunks


def make_chunk(tag, data):
    crc = zlib.crc32(tag + data) & 0xffffffff
    return struct.pack('>I', len(data)) + tag + data + struct.pack('>I', crc)


# ---------------------------------------------------------------------------
# PNG filter reconstruction (needed to access raw pixel indices)
# ---------------------------------------------------------------------------

def paeth_predictor(a, b, c):
    p = a + b - c
    pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
    if pa <= pb and pa <= pc:
        return a
    if pb <= pc:
        return b
    return c


def unfilter_rows(raw, row_bytes):
    """Reconstruct pixel data from filtered PNG rows.
    raw: decompressed IDAT bytes (height * (1 + row_bytes))
    Returns list of bytearrays, one per row, without filter bytes.
    """
    height = len(raw) // (1 + row_bytes)
    rows = []
    prev = bytearray(row_bytes)
    bpp = 1  # bytes per pixel (always 1 for sub-8-bit depths; for 8-bit palette also 1)

    for r in range(height):
        base = r * (1 + row_bytes)
        ftype = raw[base]
        row = bytearray(raw[base + 1: base + 1 + row_bytes])

        if ftype == 1:    # Sub
            for i in range(bpp, row_bytes):
                row[i] = (row[i] + row[i - bpp]) & 0xff
        elif ftype == 2:  # Up
            for i in range(row_bytes):
                row[i] = (row[i] + prev[i]) & 0xff
        elif ftype == 3:  # Average
            for i in range(row_bytes):
                a = row[i - bpp] if i >= bpp else 0
                row[i] = (row[i] + (a + prev[i]) // 2) & 0xff
        elif ftype == 4:  # Paeth
            for i in range(row_bytes):
                a = row[i - bpp] if i >= bpp else 0
                b = prev[i]
                c = prev[i - bpp] if i >= bpp else 0
                row[i] = (row[i] + paeth_predictor(a, b, c)) & 0xff
        # ftype == 0: None — row is already correct

        rows.append(row)
        prev = bytearray(row)

    return rows


# ---------------------------------------------------------------------------
# Pixel index remapping per bit depth
# ---------------------------------------------------------------------------

def remap_rows_8bit(rows, index_map):
    return [bytearray(index_map[b] for b in row) for row in rows]


def remap_rows_4bit(rows, index_map):
    out = []
    for row in rows:
        new_row = bytearray(len(row))
        for i, byte in enumerate(row):
            hi = index_map[(byte >> 4) & 0xf]
            lo = index_map[byte & 0xf]
            new_row[i] = (hi << 4) | lo
        out.append(new_row)
    return out


def remap_rows_2bit(rows, index_map):
    out = []
    for row in rows:
        new_row = bytearray(len(row))
        for i, byte in enumerate(row):
            p = [index_map[(byte >> (6 - s * 2)) & 0x3] for s in range(4)]
            new_row[i] = (p[0] << 6) | (p[1] << 4) | (p[2] << 2) | p[3]
        out.append(new_row)
    return out


def remap_rows_1bit(rows, index_map):
    out = []
    for row in rows:
        new_row = bytearray(len(row))
        for i, byte in enumerate(row):
            b = 0
            for bit in range(8):
                idx = (byte >> (7 - bit)) & 1
                b |= (index_map[idx] & 1) << (7 - bit)
            new_row[i] = b
        out.append(new_row)
    return out


def pack_rows(rows, filter_type=0):
    """Pack rows back to raw IDAT bytes using a single filter type (default: None)."""
    out = bytearray()
    for row in rows:
        out.append(filter_type)
        out.extend(row)
    return bytes(out)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    input_path  = sys.argv[1]
    output_path = sys.argv[2]
    #input_path = "toolchain/work/say_1.png"
    #output_path = "toolchain/work/say_1_remapped.png"

    with open(input_path, 'rb') as f:
        data = f.read()

    chunks = read_chunks(data)

    # Parse IHDR
    ihdr = next(d for t, d in chunks if t == b'IHDR')
    width, height = struct.unpack('>II', ihdr[:8])
    bit_depth, color_type = ihdr[8], ihdr[9]

    if color_type != 3:
        sys.exit(f"Error: expected palettized PNG (color type 3), got {color_type}")

    # Parse PLTE
    plte = next(d for t, d in chunks if t == b'PLTE')
    n_entries = len(plte) // 3
    old_palette = [(plte[i * 3], plte[i * 3 + 1], plte[i * 3 + 2]) for i in range(n_entries)]

    print(f"Input: {width}x{height}, {bit_depth}-bit, {n_entries} palette entries")

    # Build target palette (same size as original)
    new_palette = [PLACEHOLDER] * 16 + list(TARGET_COLORS)
    # Pad or truncate to match original palette size
    while len(new_palette) < n_entries:
        new_palette.append(PLACEHOLDER)
    new_palette = new_palette[:n_entries]

    # Build index_map[old_index] = new_index
    # For each old color, find its slot in the new palette
    color_to_new = {}
    for i, c in enumerate(new_palette):
        if c not in color_to_new:
            color_to_new[c] = i

    index_map = list(range(256))
    unmapped = []
    for old_i, color in enumerate(old_palette):
        if color in color_to_new:
            index_map[old_i] = color_to_new[color]
        else:
            unmapped.append((old_i, color))

    if unmapped:
        for old_i, c in unmapped:
            print(f"  Warning: #{c[0]:02x}{c[1]:02x}{c[2]:02x} at index {old_i} "
                  f"has no slot in target palette — index unchanged")

    changed = [(i, index_map[i]) for i in range(n_entries) if index_map[i] != i]
    if not changed:
        print("  No remapping needed, palette already in target layout.")
    else:
        print("  Index remapping:")
        for old_i, new_i in changed:
            c = old_palette[old_i]
            print(f"    [{old_i:3d}] -> [{new_i:3d}]  #{c[0]:02x}{c[1]:02x}{c[2]:02x}")

    # Decode and remap pixel data
    if bit_depth == 8:
        row_bytes = width
    elif bit_depth == 4:
        row_bytes = (width + 1) // 2
    elif bit_depth == 2:
        row_bytes = (width + 3) // 4
    elif bit_depth == 1:
        row_bytes = (width + 7) // 8
    else:
        sys.exit(f"Unsupported bit depth: {bit_depth}")

    idat_raw = b''.join(d for t, d in chunks if t == b'IDAT')
    raw_pixels = zlib.decompress(idat_raw)

    rows = unfilter_rows(raw_pixels, row_bytes)

    if bit_depth == 8:
        new_rows = remap_rows_8bit(rows, index_map)
    elif bit_depth == 4:
        new_rows = remap_rows_4bit(rows, index_map)
    elif bit_depth == 2:
        new_rows = remap_rows_2bit(rows, index_map)
    elif bit_depth == 1:
        new_rows = remap_rows_1bit(rows, index_map)

    new_idat_raw = pack_rows(new_rows, filter_type=0)
    new_idat = zlib.compress(new_idat_raw, level=9)

    # Build new PLTE bytes
    new_plte = b''.join(bytes(c) for c in new_palette)

    # Remap tRNS chunk if present (palette transparency entries)
    trns_map = {}
    for t, d in chunks:
        if t == b'tRNS':
            for old_i, alpha in enumerate(d):
                new_i = index_map[old_i]
                trns_map[new_i] = alpha
            break

    if trns_map:
        max_trns = max(trns_map.keys()) + 1
        new_trns = bytearray(max_trns)
        for new_i, alpha in trns_map.items():
            new_trns[new_i] = alpha
    else:
        new_trns = None

    # Reconstruct PNG chunks
    out_chunks = []
    idat_written = False
    for tag, d in chunks:
        if tag == b'PLTE':
            out_chunks.append(make_chunk(b'PLTE', new_plte))
        elif tag == b'tRNS' and new_trns is not None:
            out_chunks.append(make_chunk(b'tRNS', bytes(new_trns)))
        elif tag == b'IDAT':
            if not idat_written:
                out_chunks.append(make_chunk(b'IDAT', new_idat))
                idat_written = True
            # drop additional IDAT chunks (data was merged above)
        else:
            out_chunks.append(make_chunk(tag, d))

    with open(output_path, 'wb') as f:
        f.write(PNG_SIG)
        for chunk in out_chunks:
            f.write(chunk)

    print(f"  Written: {output_path}")


if __name__ == '__main__':
    main()
