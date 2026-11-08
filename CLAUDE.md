# Retrig – Max for Live device

Elektron-style per-pad retrig MIDI effect for Ableton Drum Racks, with Push 3 (standalone and Control Mode) support. Will be published on GitHub.

**Read `REQUIREMENTS.md` first.** It is the spec. If a decision changes, update it there.

## Hard constraints

- MIDI effect that sits inside a Drum Rack pad chain, before the instrument. One instance per pad.
- Parameters: RTRG, RATE, LEN, VFAD, CRV. All are automatable `live.*` parameters (p-locks come from Push step automation and clip envelopes).
- Register all parameters with `live.banks` (one bank of 8) or Push can't show the device.
- Native Max objects only: no third-party externals, no `node.script`.
- Retrig timing uses native transport-synced Max objects, not JS (JS runs on the low-priority thread).
- Keep CPU and UI light: expect 16+ instances per kit on Push 3 standalone.

## Workflow

- Claude can't run Max or Live. The user opens patches in Max, tests in Live (and on Push), and pastes Max console output back.
- Patcher source lives in `src/` as `.maxpat` (readable JSON, diffable). Prefer small, well-commented patchers.
- Frozen `.amxd` builds go in `build/` (git-ignored) and are attached to GitHub releases.
- Commit in small steps with clear messages.

## Repo layout

- `REQUIREMENTS.md` – spec
- `src/` – patcher source
- `build/` – frozen devices (ignored)
- `README.md` – user-facing docs
