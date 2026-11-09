#!/usr/bin/env python3
"""Build probe devices to find which Max objects break loading on Push 3 standalone.

    python3 scripts/make_probes.py      # -> build/probes/*.amxd

Load each probe on a FRESH track on Push standalone (new track, then load) and
note which ones show "This device contains missing or incompatible Max
objects". On a second load onto the same track the error usually goes away, so
only the first load on a fresh track counts.

Every probe is Retrig's real parameters and Push bank (copied from
src/retrig.maxpat) plus MIDI passing straight through, with the object(s) under
test added unconnected. The parameters matter: `moses` loads fine next to a
single dummy parameter but breaks next to Retrig's (found 2026-11-09).

- "00 baseline" has nothing extra and must load cleanly.
- One probe per object class used in the device, generated automatically, so a
  new class gets a probe without editing this file.
- "98 all objects" has every object of the device, unconnected.
- "99 moses (known bad)" must FAIL; if it loads, the test isn't reproducing the
  problem (e.g. it wasn't a fresh track).
"""
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_amxd import ROOT, build  # noqa: E402

OUT = ROOT / "build" / "probes"
SRC = json.loads((ROOT / "src" / "retrig.maxpat").read_text(encoding="utf-8"))["patcher"]
BOXES = [b["box"] for b in SRC["boxes"]]

IS_PARAM = lambda b: b.get("parameter_enable") == 1 and "saved_attribute_attributes" in b  # noqa: E731
BASE_CLASSES = {"midiin", "midiout", "live.banks"}


def cls(b):
    return b["text"].split(" ")[0] if b["maxclass"] == "newobj" else b["maxclass"]


def device(extra, title):
    """Real parameters + real bank + midiin -> midiout, plus `extra` boxes (unconnected)."""
    boxes = [
        {"id": "p-in", "maxclass": "newobj", "text": "midiin", "numinlets": 1, "numoutlets": 1,
         "outlettype": ["int"], "patching_rect": [20.0, 20.0, 50.0, 20.0]},
        {"id": "p-out", "maxclass": "newobj", "text": "midiout", "numinlets": 1, "numoutlets": 0,
         "patching_rect": [20.0, 120.0, 50.0, 20.0]},
        {"id": "p-banks", "maxclass": "newobj", "text": "live.banks", "numinlets": 1, "numoutlets": 1,
         "outlettype": [""], "patching_rect": [120.0, 20.0, 64.0, 20.0]},
    ]
    params = {}
    for b in BOXES:
        if IS_PARAM(b):
            boxes.append(json.loads(json.dumps(b)))
            v = b["saved_attribute_attributes"]["valueof"]
            params[b["id"]] = [v["parameter_longname"], v["parameter_shortname"], 0]
    y = 200.0
    for b in extra:
        b = json.loads(json.dumps(b))
        b["patching_rect"] = [300.0, y, b["patching_rect"][2], b["patching_rect"][3]]
        b.pop("presentation", None)
        b.pop("presentation_rect", None)
        boxes.append(b)
        y += 30.0
    params["parameterbanks"] = SRC["parameters"]["parameterbanks"]
    params["inherited_shortname"] = 1
    p = {k: v for k, v in SRC.items() if k not in ("boxes", "lines", "parameters", "title", "description")}
    p.update(title=title, description="Push standalone probe", boxes=[{"box": b} for b in boxes],
             parameters=params, lines=[{"patchline": {"source": ["p-in", 0], "destination": ["p-out", 0]}}])
    return {"patcher": p}


def probes():
    others = [b for b in BOXES if not IS_PARAM(b) and cls(b) not in BASE_CLASSES]
    by_class = {}
    for b in others:
        by_class.setdefault(cls(b), []).append(b)  # every instance: arguments can matter
    jobs = {"00 baseline": []}
    for n, (c, bs) in enumerate(sorted(by_class.items()), start=1):
        jobs[f"{n:02d} {c}"] = bs
    jobs["98 all objects"] = others
    moses = {"id": "bad-moses", "maxclass": "newobj", "text": "moses 0", "numinlets": 2, "numoutlets": 2,
             "outlettype": ["", ""], "patching_rect": [0.0, 0.0, 50.0, 20.0]}
    jobs["99 moses (known bad)"] = [moses]
    return jobs


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for old in OUT.glob("*.amxd"):
        old.unlink()
    tmp = OUT / "_probe.maxpat"
    jobs = probes()
    for name, extra in jobs.items():
        tmp.write_text(json.dumps(device(extra, name), indent="\t") + "\n", encoding="utf-8")
        build(tmp, OUT / f"Probe {name}.amxd")
    tmp.unlink()
    print(f"{len(jobs)} probes in {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
