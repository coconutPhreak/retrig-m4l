# Retrig M4L Device – Requirements

As of 2026-11-09. Source of truth while building; update it when decisions change.

## Overview and placement

The Retrig device is a Max for Live MIDI effect that adds Elektron-style retrigs to a single Drum Rack pad.

Elektron hardware is the inspiration, not a spec to match exactly. Where the device goes beyond the hardware (e.g. speed fade), design for the device's own features first.

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
| VFAD | Negative to positive (fade out to fade in) | Velocity fade across the burst, starting from the played velocity. Negative fades down toward 1, positive fades up toward 127. |
| CRV | 0% to 100% | Shape of the fade: 0% linear, 100% exponential, blended in between. |

The RATE and LEN value lists have been checked against the Elektron box, and the VFAD range is decided (see Decisions).

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
- **No `moses`** (found 2026-11-09). A device with `moses` next to Retrig's parameters fails on its first load on a fresh Push standalone track with "This device contains missing or incompatible Max objects". The device still processes MIDI, but its parameters don't show (only LEN appeared). A second load onto the same track works. Use `sel` or `expr` instead.
- Native objects can still break standalone in combination with the device's parameters, which a probe with a dummy parameter misses. Before adding a new object class, run `scripts/make_probes.py` and test the probes on fresh tracks (see TESTING.md).
- The Live API at load (`live.thisdevice` → `live.path` → `live.observer`) loads fine on standalone. Editing banks with `live.banks` messages at load does not: it failed every time.
- A startup delay doesn't help with load errors: they happen while Push sets up the objects, before any device logic runs.
- Keep CPU low: 16+ instances per kit, and Push standalone has limited CPU. No heavy UI.

Sources: [Ableton – Push (standalone) Max for Live compatibility](https://help.ableton.com/hc/articles/8506527153308), [CDM – Making Max for Live devices work on Push](https://cdm.link/making-max-for-live-devices-work-on-push-and-push-3-standalone/)

## Implementation constraints

- Retrig timing is built from native, transport-synced Max objects, not JavaScript. JS runs on Max's low-priority thread by default, which makes timing jittery.
- Keeping timing out of JS also avoids depending on `v8` running on Push standalone.
- Workflow: Claude writes the patcher; `scripts/build_amxd.py` wraps it into `build/Retrig.amxd`; the user tests in Live and pastes any Max console output back.

## Decisions and defaults (v1)

Agreed 2026-11-09. Items marked ⚑ are provisional defaults until checked against the Elektron manual or tested.

**Build order.** v1 has RTRG, RATE and LEN only, so timing can be tested first. v2 (built 2026-11-09) adds VFAD and CRV, which completes the core five.

**Timing**

- Hit 0 fires immediately at note-on and replaces the incoming note. Each later hit is scheduled by a `delay` re-armed after every hit with that hit's interval (since v4; v1–v3 used a `metro`, which only applies a new interval one hit late, so it can't glide).
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

- RATE (17, checked on the Elektron box 2026-11-09): 1/1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/8, 1/10, 1/12, 1/16, 1/20, 1/24, 1/32, 1/40, 1/48, 1/64, 1/80. Default 1/16.
- LEN (128 values, in steps; checked on an Elektron box 2026-11-09): 0.125 to 2 in 1/16-step increments (0.125, 0.188, 1/64, 0.313 … 1.94, 1/8), then increments of 0.125 to 4, 0.25 to 8, 0.5 to 16, 1 to 32, 2 to 64, 4 to 128, then INF. Default 1/4 (4 steps).
  - Labels show 3 significant digits, rounded half up (0.313, 1.13), except whole note values, which show as notes: 1/64 = 0.25, 1/32 = 0.5, 1/16 = 1, 1/8 = 2, 1/4 = 4.
  - ⚑ The note labels 1/2 (8 steps) and 1/1 (16 steps) are assumed by extending that pattern. Values above 5.25 follow the stated increments but weren't read off the box one by one.
  - The 1/16-step values are 7.5 ticks, so LEN is stored in half-ticks (1 step = 240) and the hit count is `N = (len_half + 2·rate − 1) / (2·rate)` in integer maths, which equals `ceil(LEN / RATE)`.
- ⚑ INF runs until the next note, transport stop or RTRG change.

**Velocity fade (v2)**

- VFAD is −100…+100 %, f = VFAD/100. Every burst **starts at the played velocity v0**; VFAD sets where it ends (revised 2026-11-09, replacing "fade-in rises to the played velocity"):
  - f < 0 (fade out): ends at `v0 − |f|·(v0 − 1)`, so −100 % ends at velocity 1.
  - f > 0 (fade up): ends at `v0 + f·(127 − v0)`, so +100 % ends at 127.
  - One formula for both: `vs = v0`, `ve = v0 + max(f,0)·(127 − v0) + min(f,0)·(v0 − 1)`.
  - A note played at 127 can't fade up, and one played at 1 can't fade out.
  - Example, v0 = 100: VFAD −80 % ends at 20.8; +80 % ends at 121.6.
- Fade position is measured **to the last hit** (decided 2026-11-09 after comparing by ear): t = elapsed / (time of the last hit); with a constant rate t = i / (N − 1). The last hit lands exactly on the end velocity (4 hits at −100 %: 100, 67, 34, 1). One hit (N = 1) plays at v0. With a speed fade (TRATE) the last hit's time is worked out at note-on by running through the burst's schedule once (native objects, no JS); see v4.
- **Alternative considered and set aside: LEN mode**, time through LEN: t = elapsed / LEN; with a constant rate t = i·RATE / LEN. Simpler with SFAD (no hit count needed), but the last hit stops short of the end velocity: 4 hits at −100 % end at 26, not 1. Both modes were built side by side behind a FADE switch and compared in Live. They sounded nearly the same with many hits per burst, and LAST was better with few. To bring LEN back, see commit `d936dbd` ("Add FADE switch …"): it has both modes in `src/retrig.maxpat` (the `expr-t` formula and the FADE menu on a "Setup" bank).
- `v_lin = vs + (ve−vs)·t`, `v_exp = vs·(ve/vs)^t` (ve is always ≥ 1, so this stays finite), then the CRV blend above, rounded half up and clamped to 1–127. One `expr` per hit.
- VFAD and CRV are continuous `live.dial` parameters (not whole-number steps), so Push gives coarse turns normally and fine control with Shift held. The display shows whole percentages.
- ⚑ With LEN = INF there is no fade; velocity stays constant.

**Parameters**

| Param | Object | Values | Default |
| --- | --- | --- | --- |
| RTRG | `live.toggle` | Off / On | Off (changed from On 2026-11-09: a freshly loaded device passes notes through until you turn it on) |
| RATE | `live.menu` | RATE list | 1/16 |
| LEN | `live.menu` | LEN list | 1/4 |
| VFAD | `live.dial` (continuous) | −100…+100 % | 0 |
| CRV | `live.dial` (continuous) | 0…100 % | 0 |

VFAD and CRV are read at note-on, like RATE and LEN (decided 2026-11-09): turning them mid-burst changes the next burst.

LEN stays a list (`live.menu`), so it keeps its exact labels (1/64, 1/4, INF). Push moves a list one entry per encoder click, with no acceleration and no Shift fine-tuning, so reaching 128 takes a long turn. A continuous, exponentially scaled LEN dial was considered (2026-11-09) and set aside: it would lose the labels and INF.

Banks are grouped by what you reach for while playing (since v4):

| Bank | Encoders 1–8 |
| --- | --- |
| 1 Retrig | RTRG, RATE, LEN, VFAD, CRV, PROB, TRATE, GLIDE |
| 2 Chance | PROB, LOCK, PMODE, then five free (for RATE variation) |
| 3 Setup | VOICES (v5), then STRT if it's built |

PROB is on both bank 1 and bank 2. Banks are saved at the device level (`parameterbanks`), which a copy-and-paste into the device editor would lose, so the device is built straight to `.amxd`.

## Later: after the core requirements

Started once the core five were built and tested. Bank layout: see Parameters above.

### v3: PROB, LOCK, PMODE (built 2026-11-09)

| Name | Control | Range | Default | Bank |
| --- | --- | --- | --- | --- |
| PROB | `live.dial` (continuous) | 0–100 % | 100 % | Retrig, slot 6 |
| LOCK | `live.toggle` | Off / On | Off | Retrig, slot 7 |
| PMODE | `live.menu` | Repeats / Burst / Note | Repeats | Setup, slot 1 |

What PROB decides depends on PMODE:

| PMODE | One roll per… | If the roll fails |
| --- | --- | --- |
| Repeats | repeat | That repeat is skipped. The played note always sounds. |
| Burst | played note | The played note sounds, with no repeats. |
| Note | played note | Nothing sounds. The note is dropped before it reaches the engine, so it doesn't cut a burst that's still running. |

- LOCK on: PROB is ignored in every mode and everything fires.
- A skipped repeat is a gap: the previous hit has already had its note-off.
- Skipped repeats still count toward the fade, so the VFAD curve doesn't shift (decided 2026-11-09).
- PROB, LOCK and PMODE are read at note-on, like everything else. In Note mode the roll happens as the note arrives.
- PROB only applies while RTRG is on; with RTRG off, notes pass through untouched.
- Rolls use native `random` (0–9999 against PROB × 100), in the scheduler thread.
- Two pads with the same PROB skip independently, not in lockstep (checked 2026-11-09).
- v3 tested in Live and on Push standalone 2026-11-09 (TESTING.md R1–R10, P1, P1a): all pass.

### v4: speed fade as a target rate (built 2026-11-09)

Replaces the earlier ±% SFAD idea: the speed fade is set as a target rate plus a glide time, in musical units.

| Name | Control | Values | Default | Bank |
| --- | --- | --- | --- | --- |
| TRATE | `live.menu` | Off, then the 17 RATE values | Off | Retrig, slot 7 |
| GLIDE | `live.dial` (continuous, exponent 2, Shift fine-tunes) | 0–128 steps | 4 | Retrig, slot 8 |

- TRATE Off: no speed fade; the device behaves exactly as v3.
- The interval after a hit at elapsed time T is `RATE · (TRATE/RATE)^(T/GLIDE)` while gliding, then TRATE. The rate changes by equal ratios over equal time, so the glide sounds even. Once there, it holds TRATE until LEN ends.
- GLIDE 0 jumps straight to TRATE: the gap to the second hit is already TRATE.
- GLIDE longer than LEN: the burst ends partway through the glide.
- GLIDE is in steps, not % of LEN, so it works with LEN INF too: an INF burst glides to TRATE and stays there.
- The velocity fade still lands exactly on the last hit. With TRATE on and a finite LEN, the device runs through the burst's schedule once at note-on (`uzi`) to get the hit count and the last hit's time.
- **256-hit cap**, only when TRATE is on and LEN is finite, to bound that note-on calculation (16 pads on Push). With TRATE Off there's no cap (e.g. 1/80 over LEN 128 is 640 hits).
- TRATE and GLIDE are read at note-on, like everything else.
- PROB, LOCK and PMODE work unchanged with the glide.
- v4 tested in Live and on Push 2026-11-09 (TESTING.md S1–S11, timing tests 2, 3, 4, 5 and 8 with TRATE Off, P1, P1a, P1c): all pass. CPU with 16 pads retrigging at once: 9–12 % in Live (48 kHz, 256-sample buffer), no dropouts.

### v5: polyphony (planned, agreed 2026-11-09)

By default a new note cuts the running burst (mono). With more voices, each note starts its own burst and the earlier ones keep going, so bursts overlap. Each burst keeps the settings it latched at its own note-on (RATE, LEN, fades, glide, rolls), so p-locked steps can layer different rates on one pad.

| Name | Control | Values | Default | Bank |
| --- | --- | --- | --- | --- |
| VOICES | `live.menu` | Mono, 2, 3, 4, 5, 6, 7, 8 | Mono (as v4) | Setup, slot 1 |

A menu rather than a number box (decided 2026-11-09), so the first entry can read "Mono": it's the cut-each-burst behaviour, not just "one voice". It also matches RATE, LEN, TRATE and PMODE. Any later entries go at the end, so saved values and p-locks keep their meaning.

- VOICES Mono behaves exactly as v4.
- All voices busy: the new note **steals the oldest** burst (the stolen burst gets its note-off, then stops).
- LEN INF in poly mode: INF bursts keep running until stolen, or until the transport stops. No special case.
- VOICES is read at note-on and can be p-locked: a step locked to VOICES Mono cuts every running burst; a step with more voices leaves them running.
- PMODE Note: a note that fails its roll is still dropped before anything happens, so it neither cuts nor steals.
- Every burst on a pad plays the same pitch. In One-Shot mode that's fine. In Gate mode a note-off from one burst can cut a hit from another, so overlapping hits may sound short (nothing hangs). The instrument needs enough voices of its own (Simpler is fine; some instruments cut their own tails). Document this in the README.
- Implementation: N copies of the burst engine (note-on to hits) generated by the build tooling, plus a small oldest-voice allocator in front. No `poly~` (audio-only, needs an abstraction file) and no new object classes, but still load it on a fresh Push track to check.
- CPU: idle voices cost nothing; the cost grows with the number of overlapping bursts. Re-run the 16-pad CPU test with VOICES 8 and dense overlapping notes (worst case 16 × 8 = 128 bursts at once). Eight engine copies make the patch several times larger, so also check load time on Push standalone.
- Creates the Setup bank (bank 3).

### Later: RATE variation (idea, 2026-11-09)

A variation feature that picks a random RATE, with an option to pick only straight rates (1/1, 1/2, 1/4, 1/8, 1/16, 1/32, 1/64). Noted for later; not designed yet.

Questions to settle when it's picked up:

- [ ] When is the random rate picked: once per burst (at note-on) or per hit? Per hit would change the speed within a burst, which overlaps with the speed fade (TRATE/GLIDE).
- [ ] How far it can move: any value in the RATE list, or a range around the set RATE (e.g. "up to N steps faster or slower")? That would need an amount control.
- [ ] How often it varies: every note, or with a chance (like PROB)?
- [ ] The straight-only option: a switch on the Chance bank, next to the variation controls. It may replace STRT below, since both are about straight rates.
- [ ] How it combines with the speed fade (TRATE/GLIDE): randomise RATE, TRATE, or both? And with the fade to the last hit (the hit count changes with the rate).
- [ ] Bank 1 is full (since v4), so its controls go on the Chance bank (slots 4–8 are free).

### Stretch: straight-only switch (on hold, 2026-11-09)

An on/off switch that limits RATE to straight divisions (requested 2026-11-09, decided the same day). On hold: not sure it's wanted yet, and it may fold into the RATE variation feature above.

| Name | Range | What it does |
| --- | --- | --- |
| STRT | Off / On | When on, RATE uses straight divisions only: 1/1, 1/2, 1/4, 1/8, 1/16, 1/32, 1/64. Triplets (1/3, 1/6, 1/12, 1/24, 1/48) and the odd divisions (1/5, 1/10, 1/20, 1/40, 1/80) are skipped. |

- STRT is a `live.toggle` parameter like the others, so it can be p-locked. It would go on the third Push bank, "Setup", next to VOICES (bank 1 is full since v4, and bank 2 is for chance controls).
- RATE's value list never changes, so saved automation and p-locks keep pointing at the same rates.
- While STRT is on, a non-straight RATE snaps to the nearest straight one when a burst starts (e.g. 1/12 → 1/16). The snap is computed at note-on, alongside the existing RATE lookup.
- ⚑ "Nearest" is by ratio of interval lengths, which never ties for this list. Triplets snap one step faster, odd divisions one step slower:

  | RATE | 1/3 | 1/5 | 1/6 | 1/10 | 1/12 | 1/20 | 1/24 | 1/40 | 1/48 | 1/80 |
  | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
  | STRT on | 1/4 | 1/4 | 1/8 | 1/8 | 1/16 | 1/16 | 1/32 | 1/32 | 1/64 | 1/64 |

  1/80 is faster than every straight value, so it goes to the fastest, 1/64. Confirm the table when building.
- ⚑ RATE's display still shows the non-straight value while STRT snaps it, because the menu can't hide entries without changing its list. Check on Push whether that's confusing.

Implementation notes (as built):

- v4 moved the timing core from a fixed `metro` to a `delay` re-armed after every hit (ticks while playing, ms when stopped), because the speed fade changes the interval on every hit.
- With TRATE on and a finite LEN, an `uzi` loop at note-on runs through the schedule to get the hit count and the last hit's time for the fade (max 256 hits).
- PROB uses native `random` per roll, in the scheduler thread: no JS.

## Out of scope and open items

Rack-wide features (sample assignment, pad naming, auto-inserting this device into chains) belong to the separate Kit device, not this one.

- [x] Confirm the exact RATE value list against the Elektron box
- [x] Confirm the LEN value list against the Elektron box (labels for 8 and 16 steps still assumed, see defaults)
- [x] Confirm the VFAD range and how it maps to the end velocity (−100…+100 %; starts at the played velocity, −100 % ends at 1, +100 % ends at 127)
- [x] Decide fade behaviour when LEN is INF (no fade, see defaults)
- [ ] Check whether tick-based `metro` runs with Live's transport stopped (the ms fallback is in place either way)
- [x] Check that a p-lock on a step reaches the device before that step's note (Push test P2 passed 2026-11-09)
- [x] CPU with 16 instances on Push standalone (Push test P3 passed 2026-11-09)
- [x] Test the device on Push 3 standalone early (2026-11-09: after the `moses` fix, v1 loads cleanly on a fresh track, shows RTRG, RATE, LEN on encoders 1–3, and retrigs)
