# Testing Retrig

How to build the device, load it in Live, and what to check. v1 added RTRG, RATE and LEN (timing); v2 adds VFAD and CRV (velocity fade).

## Build and load

1. Build the device from the patcher source:

   ```bash
   python3 scripts/build_amxd.py
   ```

   This writes `build/Retrig.amxd`.
2. In Live, make a Drum Rack and load Simpler (or Drum Sampler) on one pad with a short click or rim sample.
3. Show the pad's chain and drag `build/Retrig.amxd` into it, *before* the instrument.
4. The device should show RTRG (**off**), RATE (1/16), LEN (1/4), VFAD and CRV (0 %), PROB (100 %), LOCK (off) and PMODE (Repeats). Turn RTRG on before testing retrigs.

After every rebuild, drag the new `Retrig.amxd` in again to replace the old one (or delete and re-add it).

### If you edit the patch in Live's device editor

Save from the device editor (unfrozen), then copy the changes back into the source so they end up in git:

```bash
python3 scripts/build_amxd.py --extract build/Retrig.amxd
```

### Console output for bug reports

In the device editor (patching view), turn on the **Debug** toggle (right side, next to `print retrig`). The Max console then shows:

- `retrig: burst_hits N`, the hit count for each new note (`0` means INF)
- `retrig: note P V` for each note-on, and `retrig: note P 0` for each note-off

Paste console output back, along with any red error lines that appear when the device loads.

## Load check (do this first)

- [ ] No red errors in the Max console when the device loads. Watch for `translate`, `live.observer`, `coll` or `live.banks`.
- [ ] RATE lists 1/1 … 1/80 (17 values); LEN lists 0.125, 0.188, 1/64 … 124, 128, INF (128 values), matching the Elektron box. Check that 8 and 16 steps show as 1/2 and 1/1 on your box too.
- [ ] In Live's device, check the controls are automatable: right-click RATE → "Show Automation".

## Timing tests (v1)

Use a clip with one note on beats 1 and 3, at 120 BPM unless noted. To check timing precisely, record the Drum Rack's output to an audio track and zoom in on the transients against the grid.

| # | Setup | Expect |
| --- | --- | --- |
| 1 | RTRG off | Output identical to the device being bypassed. |
| 2 | RATE 1/16, LEN 1/4 | 4 hits per note, on the 16th grid. Note any offset or jitter of the transients (in ms). |
| 3 | RATE 1/5, 1/3, 1/80; LEN 1/1 | Hits stay evenly spaced and on time across several bars. 1/5 gives 5 hits per bar. |
| 3b | RATE 1/80, LEN 0.313 | 2 hits. LEN 0.313 is 37.5 ticks, not a whole number, so this checks the half-tick maths. |
| 4 | Automate tempo 90 → 160 during a long burst (LEN 64 or INF) | Hit spacing follows the tempo. |
| 5 | LEN 1/1, notes on every beat | Each new note cuts the previous burst cleanly: no double hits, no stuck notes. |
| 6 | RATE 1/4, LEN 0.125 | One hit per note. |
| 7 | LEN INF | Burst runs until the next note; stopping the transport silences it. |
| 8 | Transport stopped, play the pad by hand | Retrigs still fire at RATE. ⚑ Also tell me whether this works *without* the ms fallback (open item). |
| 9 | Put a second pad in the same choke group | The burst chokes the other pad and is choked by it. |
| 10 | Instrument in Gate mode (not One-Shot) | Each hit sounds for about one RATE interval; nothing hangs. |
| 11 | Toggle RTRG during a long burst, and while holding a note with RTRG off | Burst stops; no stuck notes either way. |
| 12 | Copy the chain to 16 pads, all retrigging at 1/32 | Note Live's CPU meter. |

## Velocity tests (v2)

Turn on the **Debug** toggle and read the velocities from the Max console (`retrig: note P V`). Play the pad at a known velocity: put a note in a clip and set its velocity, rather than playing it by hand. Each burst starts at the played velocity.

The fade ends exactly on the last hit. Check the instrument's velocity-to-volume amount is high (e.g. 100 % in Simpler), or fades will sound flat even when the velocities are right.

| # | Setup (note velocity 100, RATE 1/16, LEN 1/4 = 4 hits) | Expect |
| --- | --- | --- |
| V1 | VFAD 0 %, any CRV | 100, 100, 100, 100 |
| V2 | VFAD −80 %, CRV 0 % | 100, 74, 47, 21 |
| V3 | VFAD −80 %, CRV 100 % | 100, 59, 35, 21 |
| V4 | VFAD +80 %, CRV 0 % | 100, 107, 114, 122 |
| V5 | VFAD −100 %, CRV 0 % | 100, 67, 34, 1 |
| V6 | VFAD −100 %, CRV 100 % | 100, 22, 5, 1 |
| V7 | CRV 50 %, VFAD −80 % | 100, 66, 41, 21 (between V2 and V3) |

| # | Setup | Expect |
| --- | --- | --- |
| V8 | VFAD −100 %, CRV 0 %, LEN 1/1 (16 hits) | Falls evenly from 100 to exactly 1 on the last hit, never 0 (velocity 0 would be a note-off). |
| V9 | VFAD +100 %, RATE 1/32 (8 hits) | Rises from 100; the last hit is exactly 127. |
| V10 | VFAD +100 %, note velocity 127 | Stays at 127 (it can't fade up). |
| V11 | VFAD −100 %, LEN 0.125 (one hit) | One hit at 100 (nothing to fade across). |
| V12 | VFAD −80 %, LEN INF | No fade: every hit at 100. |
| V13 | VFAD −80 %, turn VFAD to +80 % halfway through a long burst (LEN 1/1) | The running burst keeps fading down; the next note fades up. |

## Probability tests (v3)

Use a clip with a note on every beat, RATE 1/16, LEN 1/4 (4 hits per note), and let it loop for a few bars. The Debug console shows which hits fire.

| # | Setup | Expect |
| --- | --- | --- |
| R1 | PROB 100 %, any PMODE | Every burst plays all 4 hits (same as v2). |
| R2 | PMODE Repeats, PROB 50 % | Every note sounds; about half the repeats are missing, at random, as gaps. |
| R3 | PMODE Repeats, PROB 0 % | Only the played notes; no repeats. |
| R4 | PMODE Burst, PROB 50 % | Each note is either a full burst or a single hit, about half each. |
| R5 | PMODE Note, PROB 50 % | About half the notes play a full burst; the rest are silent. |
| R6 | PMODE Note, LEN 1/1, PROB 50 %, notes on every beat | A failed note doesn't cut the burst before it: that burst keeps going. |
| R7 | PROB 0 %, LOCK on, each PMODE | Everything fires, like R1. |
| R8 | PMODE Repeats, PROB 50 %, VFAD −100 % | The repeats that do play keep their place in the fade (100, 67, 34, 1), they just have gaps. |
| R9 | Two pads, same settings, PROB 50 % | ⚑ The two pads skip *different* repeats, not the same ones in lockstep. |
| R10 | Hold a step on Push, turn LOCK on for that step only | Only that step always bursts fully. |

## Push 3

### If Push standalone says "This device contains missing or incompatible Max objects"

Ableton doesn't publish which objects standalone rejects, so find out with probe devices:

```bash
python3 scripts/make_probes.py
```

This writes one probe per object type used in Retrig to `build/probes/`. Each probe has Retrig's real parameters and Push bank, because some objects only fail alongside them.

- Load each probe on a **fresh track** (new track, then load). The error usually only shows on the first load onto a new track, so a reload doesn't count.
- `Probe 00 baseline` must load cleanly.
- `Probe 99 moses (known bad)` must show the error. If it doesn't, the test isn't reproducing the problem.
- `Probe 98 all objects` has every object in the device, unconnected. If it fails but every single-object probe passes, it's a combination: split the objects in half and repeat.

Known cause so far: `moses` (now replaced with `sel`, see REQUIREMENTS.md).

| # | Setup | Expect |
| --- | --- | --- |
| P1 | Select the pad on Push, open the device (on a fresh track) | A bank called "Retrig" with RTRG, RATE, LEN, VFAD, CRV, PROB, LOCK on encoders 1–7. No error screen. |
| P1a | Page to the second bank | "Setup" with PMODE on encoder 1 (Repeats / Burst / Note). |
| P1b | Turn VFAD and CRV; then hold Shift and turn | A normal turn moves quickly across the range; Shift gives fine steps. Tell me if either feels too coarse or too slow. |
| P2 | Hold a step, turn RATE | The p-lock applies to that step only. ⚑ Open item: confirm the lock reaches the device before that step's note (if not, the step plays with the previous RATE). |
| P3 | Standalone mode: repeat tests 2, 5 and 12 | Same results; note CPU. |
