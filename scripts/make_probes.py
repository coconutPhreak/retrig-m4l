#!/usr/bin/env python3
"""Build tiny probe devices to find which Max objects Push 3 standalone rejects.

    python3 scripts/make_probes.py      # -> build/probes/*.amxd

Every probe is a working MIDI effect (midiin -> midiout) with one live.toggle
registered in a live.banks bank, plus the object(s) under test. Load each one
on Push standalone: the probes that show "missing or incompatible Max objects"
name the culprit. "00 baseline" has nothing extra and must load cleanly.

The object list mirrors src/retrig.maxpat. Add a probe here before using a new
object class in the device.
"""
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_amxd import ROOT, build  # noqa: E402

OUT = ROOT / "build" / "probes"
SRC = json.loads((ROOT / "src" / "retrig.maxpat").read_text(encoding="utf-8"))["patcher"]
BY_ID = {b["box"]["id"]: b["box"] for b in SRC["boxes"]}

# probe name -> ids of boxes copied from the real device (same text, same saved attributes)
PROBES = {
    "01 translate": ["translate"],
    "02 coll (embedded data)": ["coll-rate"],
    "03 live api (thisdevice, path, observer)": ["thisdev", "lpath", "observer"],
    "04 live.menu": ["RATE"],
    "05 print": ["print"],
    "06 toggle (Max UI)": ["dbg-toggle"],
    "07 comment + live.comment": ["c-title", "lbl-rate"],
    "08 expr": ["expr-n", "expr-play"],
    "09 prepend": ["pre-note"],
    "10 stripnote": ["strip"],
    "11 midiparse + midiformat": ["parse", "format"],
    "12 metro": ["metro"],
    "13 basics (t i + gate moses pack unpack sel message)": [
        "t-note", "i-pitch", "plus-idx", "gate-int", "moses-sound", "pack-on", "unp-note", "sel-play", "m-stop"],
}


def device(extra_ids, title):
    boxes = [
        {"box": {"id": "p-in", "maxclass": "newobj", "text": "midiin", "numinlets": 1, "numoutlets": 1,
                 "outlettype": ["int"], "patching_rect": [20.0, 20.0, 50.0, 20.0]}},
        {"box": {"id": "p-out", "maxclass": "newobj", "text": "midiout", "numinlets": 1, "numoutlets": 0,
                 "patching_rect": [20.0, 120.0, 50.0, 20.0]}},
        {"box": {"id": "p-banks", "maxclass": "newobj", "text": "live.banks", "numinlets": 1, "numoutlets": 1,
                 "outlettype": [""], "patching_rect": [120.0, 20.0, 64.0, 20.0]}},
        {"box": {"id": "p-param", "maxclass": "live.toggle", "numinlets": 1, "numoutlets": 1, "outlettype": [""],
                 "parameter_enable": 1, "varname": "PROBE", "patching_rect": [120.0, 60.0, 15.0, 15.0],
                 "presentation": 1, "presentation_rect": [10.0, 10.0, 15.0, 15.0],
                 "saved_attribute_attributes": {"valueof": {
                     "parameter_longname": "PROBE", "parameter_shortname": "PROBE", "parameter_type": 2,
                     "parameter_mmax": 1.0, "parameter_enum": ["off", "on"]}}}},
    ]
    params = {"p-param": ["PROBE", "PROBE", 0]}
    y = 160.0
    for oid in extra_ids:
        b = json.loads(json.dumps(BY_ID[oid]))
        b["patching_rect"] = [20.0, y, b["patching_rect"][2], b["patching_rect"][3]]
        b.pop("presentation", None)
        b.pop("presentation_rect", None)
        if "saved_attribute_attributes" in b:  # live.* parameter copied from the device
            v = b["saved_attribute_attributes"]["valueof"]
            params[b["id"]] = [v["parameter_longname"], v["parameter_shortname"], 0]
        boxes.append({"box": b})
        y += 30.0
    params["parameterbanks"] = {"0": {"index": 0, "name": "Probe", "parameters": ["PROBE", "-", "-", "-", "-", "-", "-", "-"]}}
    params["inherited_shortname"] = 1
    p = {k: v for k, v in SRC.items() if k not in ("boxes", "lines", "parameters", "title", "description")}
    p.update(title=title, description="Push standalone probe", boxes=boxes, parameters=params,
             lines=[{"patchline": {"source": ["p-in", 0], "destination": ["p-out", 0]}}],
             devicewidth=60.0, openrect=[0.0, 0.0, 60.0, 169.0])
    return {"patcher": p}


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for old in OUT.glob("*.amxd"):
        old.unlink()
    tmp = OUT / "_probe.maxpat"
    jobs = {"00 baseline": []} | PROBES
    for name, ids in jobs.items():
        tmp.write_text(json.dumps(device(ids, name), indent="\t") + "\n", encoding="utf-8")
        build(tmp, OUT / f"Probe {name}.amxd")
    tmp.unlink()


if __name__ == "__main__":
    main()
