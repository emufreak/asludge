#!/usr/bin/env python3
"""Retarget an indexed PNG so artwork uses palette indexes 17-32.

The script expects an indexed/palettized PNG as input. It builds a 32-color
palette where entries 1-16 are cyan (0x00ffff) and entries 17-32 are:
0000aa,000000,ffffff,aa0000,aa00aa,555555,aa5500,00aa00,
ff5555,00aaaa,aaaaaa,55ff55,55ffff,ffff55,5555ff,ff5500

Then it remaps the input image to that palette using ImageMagick.
Compatible with ImageMagick v6.9 (identify/convert binaries) and v7 (magick).
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


class IMCommands:
    def __init__(self, identify: list[str], convert: list[str]) -> None:
        self.identify = identify
        self.convert = convert


def run(cmd: list[str]) -> str:
    completed = subprocess.run(cmd, check=True, text=True, capture_output=True)
    return completed.stdout.strip()


def resolve_commands(imagemagick: str | None) -> IMCommands:
    """Resolve ImageMagick command style.

    - v7: magick identify/convert
    - v6: identify/convert binaries
    """
    if imagemagick:
        if shutil.which(imagemagick) is None:
            raise ValueError(f"ImageMagick binary '{imagemagick}' was not found in PATH.")
        return IMCommands([imagemagick, "identify"], [imagemagick, "convert"])

    if shutil.which("magick"):
        return IMCommands(["magick", "identify"], ["magick", "convert"])

    if shutil.which("identify") and shutil.which("convert"):
        return IMCommands(["identify"], ["convert"])

    raise ValueError(
        "ImageMagick not found. Install v7 ('magick') or v6 tools ('identify' + 'convert')."
    )


def ensure_palettized(commands: IMCommands, input_png: Path) -> None:
    img_type = run(commands.identify + ["-format", "%[type]", str(input_png)])
    if "Palette" not in img_type:
        raise ValueError(
            f"Input must be palettized PNG, but identify reported type '{img_type}'."
        )


def build_palette_image(commands: IMCommands, palette_path: Path) -> None:
    colors = [CYAN] * 16 + TARGET_17_TO_32

    cmd = commands.convert.copy()
    for color in colors:
        cmd.append("xc:" + color)
    cmd.extend(["+append", "-depth", "8", "PNG8:" + str(palette_path)])
    subprocess.run(cmd, check=True)


def remap_image(commands: IMCommands, input_png: Path, palette_png: Path, output_png: Path) -> None:
    cmd = commands.convert + [
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
        "--imagemagick",
        default=None,
        help="ImageMagick launcher binary (typically 'magick'). If omitted, auto-detect v7 or v6 commands.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if not args.input_png.exists():
        print(f"Error: input file not found: {args.input_png}", file=sys.stderr)
        return 2

    try:
        commands = resolve_commands(args.imagemagick)
        ensure_palettized(commands, args.input_png)
        args.output_png.parent.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory() as tmpdir:
            palette_path = Path(tmpdir) / "palette32.png"
            build_palette_image(commands, palette_path)
            remap_image(commands, args.input_png, palette_path, args.output_png)
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
