# Retrig M4L Device – Requirements

As of 2026-11-09. Source of truth while building; update it when decisions change.

## Overview and placement

The Retrig device is a Max for Live MIDI effect that adds Elektron-style retrigs to a single Drum Rack pad.

- It sits inside a pad's chain, before the instrument (Simpler, Drum Sampler, etc.).
- One instance per pad, so every pad has its own independent retrig settings.
- It retriggers whatever note reaches it (the chain's play note); no note filtering is needed.
- Choke groups keep working: retrigs on a pad choke other pads in the same group, as on hardware.
- Rollout at first: drop it into each chain and save the Drum Rack as a preset. Later, the separate Kit device can insert it automatically.

## Parameters

Five parameters, all on a single Push bank of 8.

| Name | Range | What it does |
| --- | --- | --- |
| RTRG | Off / On | Turns retrigs on for incoming notes. |
| RATE | 1/1 to 1/80, straight, triplet and odd divisions (e.g. 1/3, 1/5, 1/6, 1/12, 1/20, 1/24) | How fast repeats fire, synced to Live's transport. |
| LEN | 0.125 steps to INF (1 step = 1/16) | How long the burst lasts; also the window the velocity fade spans. |
| VFAD | Negative to positive (fade out to fade in) | Velocity fade across the burst. Negative fades out, positive fades in. |
| CRV | 0% to 100% | Shape of the fade: 0% linear, 100% exponential, blended in between. |

The exact RATE value list and the VFAD range should be matched against the Elektron manual before building.

## Retrig behaviour

- Each incoming note starts a burst of repeats at RATE, lasting LEN.
- A new note on the pad cuts off any burst still running.
- Repeats are locked to Live's transport so they stay in time with the clip.
- Each repeat is a full note retrigger, so the instrument's envelopes restart on every hit.
- No limit on MIDI retrigs (unlike MIDI tracks on the original Digitakt).

## Velocity fade and curve

VFAD sets where the fade ends; CRV sets its shape, morphing continuously from linear to exponential.

- **Linear (CRV 0%):** velocity changes by the same amount each repeat, e.g. 100, 80, 60, 40.
- **Exponential (CRV 100%):** velocity changes by the same ratio each repeat, e.g. 100, 70, 49, 34. Fade-outs drop fast then tail off; fade-ins creep up then surge.
- **In between:** each repeat's velocity is a blend of the two curves, weighted by CRV.
- The fade spans the burst length set by LEN.
- Velocity never goes below 1, since velocity 0 counts as a note-off.

For repeat i, with c = CRV / 100:

```
v_i = (1 - c) * v_lin_i + c * v_exp_i
```

## P-locks and automation

Every parameter must be p-lockable per step, Elektron-style.

- All five controls are automatable `live.*` parameters.
- On Push, holding a step and turning an encoder writes step automation, which works as a p-lock.
- In Live, the same locks appear as clip envelopes.
- Because the device lives in each pad's chain, a lock affects only that pad. Selecting a pad on Push shows its chain's devices, so locks land on the right pad.

## Push 3 compatibility

The device must work on Push 3 in Standalone Mode and in Control Mode.

- Push is the UI: all controls are `live.*` parameters, registered in pages of 8 with `live.banks`. Without `live.banks`, Push shows an error instead of the device.
- Native Max objects only; no third-party externals.
- No `node.script`.
- Keep CPU low: 16+ instances per kit, and Push standalone has limited CPU. No heavy UI.

Sources: [Ableton – Push (standalone) Max for Live compatibility](https://help.ableton.com/hc/articles/8506527153308), [CDM – Making Max for Live devices work on Push](https://cdm.link/making-max-for-live-devices-work-on-push-and-push-3-standalone/)

## Implementation constraints

- Retrig timing is built from native, transport-synced Max objects, not JavaScript. JS runs on Max's low-priority thread by default, which makes timing jittery.
- Keeping timing out of JS also avoids depending on `v8` running on Push standalone.
- Workflow: Claude writes the patcher; `scripts/build_amxd.py` wraps it into `build/Retrig.amxd`; the user tests in Live and pastes any Max console output back.

## Decisions and defaults (v1)

Agreed 2026-11-09. Items marked ⚑ are provisional defaults until checked against the Elektron manual or tested.

**Build order.** v1 has RTRG, RATE and LEN only, so timing can be tested first. VFAD and CRV follow in v2.

**Timing**

- One `metro`, started on note-on, fires every hit. Its first bang (immediate) is hit 0, which replaces the incoming note.
- Intervals are in ticks (480 per quarter note): a 1/N rate is 1920/N ticks, so the metro follows Live's tempo.
- ⚑ When Live's transport is stopped, tick-based timing may not run, so the interval is converted to ms at the current tempo (`translate ticks ms`). Retrigs then still work when playing pads with the transport stopped.
- A burst is a hit count, not a timer: `N = ceil(LEN_ticks / RATE_ticks)`. Hits fire at 0, r, 2r … (N−1)r, all inside LEN. This avoids timer races at the boundary, and VFAD needs N anyway.
- ⚑ RATE and LEN are read at note-on (latched). A p-lock applies to that step's whole burst; turning a knob mid-burst affects the next burst.

**Notes**

- Every hit sends a note-off for the previous hit, then a new note-on, so envelopes restart and choke groups behave normally.
- ⚑ Gate: each hit is held until the next one; the last hit's note-off comes one RATE interval after it.
- While RTRG is on, incoming note-offs are ignored; the device owns the note-offs, so nothing sticks.
- A new note cuts the running burst: stop metro, note-off for the sounding hit, then start the new burst, all in one scheduler event.
- A burst also stops (with note-off) on transport stop and when RTRG changes. Changing RTRG also sends a note-off for the last incoming pitch, so a note passed through with RTRG off can't hang.
- RTRG off: notes pass through unchanged.

**Value lists**

- ⚑ RATE (17): 1/1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/8, 1/10, 1/12, 1/16, 1/20, 1/24, 1/32, 1/40, 1/48, 1/64, 1/80. Default 1/16.
- LEN (128 values, in steps; checked on an Elektron box 2026-11-09): 0.125 to 2 in 1/16-step increments (0.125, 0.188, 1/64, 0.313 … 1.94, 1/8), then increments of 0.125 to 4, 0.25 to 8, 0.5 to 16, 1 to 32, 2 to 64, 4 to 128, then INF. Default 1/4 (4 steps).
  - Labels show 3 significant digits, rounded half up (0.313, 1.13), except whole note values, which show as notes: 1/64 = 0.25, 1/32 = 0.5, 1/16 = 1, 1/8 = 2, 1/4 = 4.
  - ⚑ The note labels 1/2 (8 steps) and 1/1 (16 steps) are assumed by extending that pattern. Values above 5.25 follow the stated increments but weren't read off the box one by one.
  - The 1/16-step values are 7.5 ticks, so LEN is stored in half-ticks (1 step = 240) and the hit count is `N = (len_half + 2·rate − 1) / (2·rate)` in integer maths, which equals `ceil(LEN / RATE)`.
- ⚑ INF runs until the next note, transport stop or RTRG change.

**Velocity fade (v2)**

- ⚑ VFAD is −100…+100 %, f = VFAD/100. Fade out (f < 0): v0 → v0·(1−|f|). Fade in (f > 0): v0·(1−f) → v0, so it rises *to* the played velocity, not to 127.
- For hit i of N, t = i/(N−1) (t = 0 when N = 1). `v_lin = vs + (ve−vs)·t`, `v_exp = vs·(ve/vs)^t` with both ends clamped to ≥ 1, then the CRV blend above, rounded and clamped to 1–127. One `expr` per hit.
- ⚑ With LEN = INF there is no fade; velocity stays constant.

**Parameters**

| Param | Object | Values | Default |
| --- | --- | --- | --- |
| RTRG | `live.toggle` | Off / On | On |
| RATE | `live.menu` | RATE list | 1/16 |
| LEN | `live.menu` | LEN list | 1/4 |
| VFAD | `live.dial` | −100…+100 % | 0 (v2) |
| CRV | `live.dial` | 0…100 % | 0 (v2) |

One bank, "Retrig": RTRG, RATE, LEN, VFAD, CRV, then three empty slots. Banks are saved at the device level (`parameterbanks`), which a copy-and-paste into the device editor would lose, so the device is built straight to `.amxd`.

## Later: after the core requirements

Not to be built until RTRG, RATE, LEN, VFAD and CRV work and are tested. Together with the core five these make exactly 8 parameters, which fills the single Push bank.

| Name | Range | What it does |
| --- | --- | --- |
| PROB | 0–100 % | The chance that each retrigger fires. |
| LOCK | Off / On | When on, PROB is ignored and every retrigger fires. |
| SFAD | Negative to positive (slows down to speeds up) | Speed fade: the repeat rate speeds up or slows down across the burst, like VFAD does for velocity. |

Open questions to settle before building:

- [ ] PROB: does hit 0 (the played note) always fire, with PROB applying only to the repeats? Proposed: yes.
- [ ] PROB: when a repeat is skipped, does the previous hit keep sounding or get a note-off on time? Proposed: note-off on time, so a skipped repeat is a gap.
- [ ] PROB: skipped repeats still advance the hit index, so the VFAD curve doesn't shift. Proposed: yes.
- [ ] SFAD range, its end rate (e.g. RATE × 2 at +100 %?) and whether it uses CRV or a curve of its own.
- [ ] SFAD with LEN = INF: no speed fade (same as VFAD)?

Design impact on the core build:

- SFAD means the interval changes on every hit, so the hit count N is no longer known at note-on. The timing core would move from a fixed `metro` plus hit count to a `delay` re-armed on every hit (still in ticks) that stops once the elapsed time reaches LEN.
- So VFAD should measure its position by time through LEN (t = elapsed / LEN), not by hit number. The time-based curve works with SFAD; the hit-number one doesn't. The catch: the last hit lands just before the end of LEN, so it stops slightly short of the end velocity. Decide this when building VFAD in v2, so that SFAD doesn't force a rewrite later.
- PROB uses a native `random` per repeat in the scheduler thread: no JS.

## Out of scope and open items

Rack-wide features (sample assignment, pad naming, auto-inserting this device into chains) belong to the separate Kit device, not this one.

- [ ] Confirm the exact RATE value list against the Elektron manual
- [x] Confirm the LEN value list against the Elektron box (labels for 8 and 16 steps still assumed, see defaults)
- [ ] Confirm the VFAD range and how it maps to the end velocity
- [x] Decide fade behaviour when LEN is INF (no fade, see defaults)
- [ ] Check whether tick-based `metro` runs with Live's transport stopped (the ms fallback is in place either way)
- [ ] Check that a p-lock on a step reaches the device before that step's note
- [ ] Test the device on Push 3 standalone early
