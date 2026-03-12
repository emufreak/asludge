#!/usr/bin/env python3
"""Retarget an indexed PNG so artwork uses palette indexes 17-32.

The script expects an indexed/palettized PNG as input. It builds a 32-color
palette where entries 1-16 are cyan (0x00ffff) and entries 17-32 are:
0000aa,000000,ffffff,aa0000,aa00aa,555555,aa5500,00aa00,
ff5555,00aaaa,aaaaaa,55ff55,55ffff,ffff55,5555ff,ff5500

Then it remaps the input image to that palette using ImageMagick.
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

CYAN = "#00ffff"
TARGET_17_TO_32 = [
    "#0000aa",
    "#000000",
    "#ffffff",
    "#aa0000",
    "#aa00aa",
    "#555555",
    "#aa5500",
    "#00aa00",
    "#ff5555",
    "#00aaaa",
    "#aaaaaa",
    "#55ff55",
    "#55ffff",
    "#ffff55",
    "#5555ff",
    "#ff5500",
]


def run(cmd: list[str]) -> str:
    completed = subprocess.run(cmd, check=True, text=True, capture_output=True)
    return completed.stdout.strip()


def ensure_palettized(magick: str, input_png: Path) -> None:
    img_type = run([magick, "identify", "-format", "%[type]", str(input_png)])
    if "Palette" not in img_type:
        raise ValueError(
            f"Input must be palettized PNG, but identify reported type '{img_type}'."
        )


def build_palette_image(magick: str, palette_path: Path) -> None:
    colors = [CYAN] * 16 + TARGET_17_TO_32

    cmd: list[str] = [magick]
    for color in colors:
        cmd.extend(["xc:" + color])
    cmd.extend(["+append", "-depth", "8", "PNG8:" + str(palette_path)])
    subprocess.run(cmd, check=True)


def remap_image(magick: str, input_png: Path, palette_png: Path, output_png: Path) -> None:
    cmd = [
        magick,
        str(input_png),
        "-dither",
        "None",
        "-remap",
        str(palette_png),
        "-define",
        "png:preserve-colormap=true",
        "-define",
        "png:color-type=3",
        "PNG8:" + str(output_png),
    ]
    subprocess.run(cmd, check=True)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Move indexed artwork to palette entries 17-32 using ImageMagick."
    )
    parser.add_argument("input_png", type=Path, help="Input palettized PNG")
    parser.add_argument("output_png", type=Path, help="Output PNG path")
    parser.add_argument(
        "--magick",
        default="magick",
        help="ImageMagick executable (default: magick)",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if shutil.which(args.magick) is None:
        print(f"Error: ImageMagick binary '{args.magick}' was not found in PATH.", file=sys.stderr)
        return 2

    if not args.input_png.exists():
        print(f"Error: input file not found: {args.input_png}", file=sys.stderr)
        return 2

    try:
        ensure_palettized(args.magick, args.input_png)
        args.output_png.parent.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory() as tmpdir:
            palette_path = Path(tmpdir) / "palette32.png"
            build_palette_image(args.magick, palette_path)
            remap_image(args.magick, args.input_png, palette_path, args.output_png)
    except subprocess.CalledProcessError as exc:
        print(exc.stderr or str(exc), file=sys.stderr)
        return exc.returncode or 1
    except ValueError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 2

    print(f"Wrote remapped image: {args.output_png}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
