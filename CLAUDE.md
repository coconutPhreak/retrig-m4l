# Retrig – Max for Live device

Elektron-style per-pad retrig MIDI effect for Ableton Drum Racks, with Push 3 (standalone and Control Mode) support. Will be published on GitHub.

**Read `REQUIREMENTS.md` first.** It is the spec. If a decision changes, update it there.

## Hard constraints

- MIDI effect that sits inside a Drum Rack pad chain, before the instrument. One instance per pad.
- Parameters: RTRG, RATE, LEN, VFAD, CRV. All are automatable `live.*` parameters (p-locks come from Push step automation and clip envelopes).
- Register all parameters with `live.banks` (one bank of 8) or Push can't show the device.
- Native Max objects only: no third-party externals, no `node.script`. No `moses` (breaks loading on Push standalone, see REQUIREMENTS.md). New object classes must pass `scripts/make_probes.py` on fresh Push tracks before they go in.
- Retrig timing uses native transport-synced Max objects, not JS (JS runs on the low-priority thread).
- Keep CPU and UI light: expect 16+ instances per kit on Push 3 standalone.

## Workflow

- Claude can't run Max or Live. The user opens patches in Max, tests in Live (and on Push), and pastes Max console output back.
- Patcher source lives in `src/` as `.maxpat` (readable JSON, diffable). Prefer small, well-commented patchers.
- `python3 scripts/build_amxd.py` wraps `src/retrig.maxpat` into `build/Retrig.amxd` (unfrozen). Build straight to `.amxd`: Push banks (`parameters.parameterbanks`), presentation mode and device width live at patcher level and are lost by copying and pasting into the device editor. `--extract` brings device-editor edits back into `src/`.
- `.amxd` builds go in `build/` (git-ignored); release builds are attached to GitHub releases.
- `TESTING.md` lists the load and test steps the user runs in Live and on Push.
- Commit in small steps with clear messages.

## Repo layout

- `REQUIREMENTS.md` – spec
- `TESTING.md` – how to build, load and test
- `src/` – patcher source
- `scripts/` – build tooling (Python, not part of the device)
- `build/` – built devices (ignored)
- `README.md` – user-facing docs (keep the Controls table in step with the device)
- `LICENSE` – MIT, © coconutPhreak
