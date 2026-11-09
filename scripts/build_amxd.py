#!/usr/bin/env python3
"""Build a Max for Live MIDI effect (.amxd) from a .maxpat, or extract one back.

    python3 scripts/build_amxd.py                       # src/retrig.maxpat -> build/Retrig.amxd
    python3 scripts/build_amxd.py --extract build/Retrig.amxd   # -> src/retrig.maxpat

An unfrozen .amxd is the patcher JSON with a small binary header (matching the
devices that ship with Live 12):

    "ampf" <u32 4> "mmmm"            device type: mmmm = MIDI effect
    "meta" <u32 4> <u32 0>
    "ptch" <u32 len> <JSON + NUL>    len counts the trailing NUL

Building straight to .amxd keeps device-level settings (Push banks in
"parameterbanks", presentation mode, device width) that a copy and paste into
Live's device editor would drop.

Extract only works on unfrozen devices. Save from the device editor without
freezing before extracting.
"""
import argparse
import json
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_SRC = ROOT / "src" / "retrig.maxpat"
DEFAULT_OUT = ROOT / "build" / "Retrig.amxd"


def build(src: Path, out: Path) -> None:
    text = src.read_text(encoding="utf-8")
    json.loads(text)  # fail early on broken JSON
    payload = text.encode("utf-8") + b"\x00"
    header = (b"ampf" + struct.pack("<I", 4) + b"mmmm"
              + b"meta" + struct.pack("<I", 4) + struct.pack("<I", 0)
              + b"ptch" + struct.pack("<I", len(payload)))
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(header + payload)
    print(f"built {out.relative_to(ROOT) if out.is_relative_to(ROOT) else out} ({len(header) + len(payload)} bytes)")


def extract(amxd: Path, out: Path) -> None:
    data = amxd.read_bytes()
    if data[:4] != b"ampf":
        sys.exit(f"{amxd}: not an .amxd file")
    i = data.find(b"ptch")
    if i < 0:
        sys.exit(f"{amxd}: no ptch chunk")
    (n,) = struct.unpack("<I", data[i + 4:i + 8])
    body = data[i + 8:i + 8 + n]
    if not body.startswith(b"{"):
        sys.exit(f"{amxd}: device is frozen; save it unfrozen from the device editor first")
    text = body.rstrip(b"\x00").decode("utf-8")
    json.loads(text)
    out.write_text(text if text.endswith("\n") else text + "\n", encoding="utf-8")
    print(f"extracted {amxd} -> {out}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--extract", metavar="AMXD", type=Path, help="write the device's patcher back to src/")
    ap.add_argument("--src", type=Path, default=DEFAULT_SRC)
    ap.add_argument("--out", type=Path, default=DEFAULT_OUT)
    a = ap.parse_args()
    if a.extract:
        extract(a.extract, a.src)
    else:
        build(a.src, a.out)


if __name__ == "__main__":
    main()
