# Testing Retrig

How to build the device, load it in Live, and what to check. v1 added RTRG, RATE and LEN (timing), v2 VFAD and CRV (velocity fade), v3 PROB, LOCK and PMODE, v4 TRATE and GLIDE (speed fade), v5 VOICES (polyphony).

## Build and load

1. Build the device from the patcher source:

   ```bash
   python3 scripts/build_amxd.py
   ```

   This writes `build/Retrig.amxd`.
2. In Live, make a Drum Rack and load Simpler (or Drum Sampler) on one pad with a short click or rim sample.
3. Show the pad's chain and drag `build/Retrig.amxd` into it, *before* the instrument.
4. The device should show RTRG (**off**), RATE (1/16), LEN (1/4), VFAD and CRV (0 %), PROB (100 %), LOCK (off), PMODE (Repeats), TRATE (Off), GLIDE (4) and VOICES (Mono). Turn RTRG on before testing retrigs.

After every rebuild, drag the new `Retrig.amxd` in again to replace the old one (or delete and re-add it).

### If you edit the patch in Live's device editor

Save from the device editor (unfrozen), then copy the changes back into the source so they end up in git:

```bash
python3 scripts/build_amxd.py --extract build/Retrig.amxd
```

The burst engine is in eight identical `p voice` subpatchers (v5). An edit to one voice has to be made to all eight: the build refuses to run if they differ.

### Console output for bug reports

In the device editor (patching view), turn on the **Debug** toggle (right side, next to `print retrig`). The Max console then shows:

- `retrig: burst_hits N`, the hit count for each new note (`0` means INF)
- `retrig: note P V` for each note-on, and `retrig: note P 0` for each note-off
- `retrig: voice N`, which of the 8 voices took the note (v5). With strict stealing (v5.1) a free voice is reused, so the numbers don't simply count up.

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

## Speed fade tests (v4)

v4 also moved the timing core from `metro` to `delay`, so re-run timing tests 2, 3, 4, 5 and 8 once with TRATE Off: they should behave exactly as before.

| # | Setup (RATE 1/16, LEN 1/1 unless noted) | Expect |
| --- | --- | --- |
| S1 | TRATE Off | Identical to v3. |
| S2 | TRATE 1/64, GLIDE 4 | Hits speed up smoothly over the first beat (4 steps), then hold at 1/64 until the bar ends. |
| S3 | TRATE 1/4, GLIDE 8 | Hits slow down smoothly over half a bar, then hold at 1/4. |
| S4 | TRATE 1/64, GLIDE 0 | Jumps: first gap is 1/64 already. |
| S5 | TRATE 1/64, GLIDE 64 (longer than LEN) | Still speeding up when the burst ends. |
| S6 | TRATE 1/64, GLIDE 4, LEN INF | Glides to 1/64, then keeps going until the next note. |
| S7 | TRATE 1/64, GLIDE 4, VFAD −100 % | The fade still ends on velocity 1 on the last hit, however many hits the glide makes. |
| S8 | RATE 1/80, TRATE 1/64, GLIDE 0, LEN 128 | Stops after 256 hits (the cap); burst_hits shows 256 in the console. |
| S9 | Transport stopped, play S2 by hand | Same glide. |
| S10 | TRATE 1/64, GLIDE 4, PROB 50 % (Repeats) | Glide with random gaps; the remaining hits keep their timing. |
| S11 | 16 pads, all with TRATE 1/64, hit together | No late or flammed notes; check CPU (the note-on calculation runs per pad). |

## Polyphony tests (v5)

Use RATE 1/16, LEN 1/1 (16 hits, one bar), and notes 1/8 apart unless noted. The instrument should be in One-Shot mode with enough voices (Simpler: Voices 8 or more, Retrigger off), or overlapping hits cut each other's tails.

| # | Setup | Expect |
| --- | --- | --- |
| Y1 | VOICES Mono | Identical to v4: each note cuts the burst before it. |
| Y2 | VOICES 2, two notes 1/8 apart | Both bursts play all 16 hits, interleaved. |
| Y3 | VOICES 2, three notes 1/8 apart | The first burst stops when the third note starts; the second and third run in full. |
| Y4 | VOICES 8, LEN INF, nine notes | The ninth note stops the first burst; the other eight keep going. |
| Y5 | VOICES 4, first note p-locked to RATE 1/4, second to 1/16 | The two bursts keep their own rates (polyrhythm on one pad). |
| Y6 | VOICES 8 with several INF bursts running; next step p-locked to VOICES Mono | That step cuts every running burst. |
| Y12 | VOICES 2. Note A with LEN 1/1, note B 1/8 later p-locked to LEN 0.125 (one hit), note C 1/4 after A (v5.1) | B ends early, so C takes the free voice: **A keeps playing to the end of its bar**. A fourth note while A and C run stops A. |
| Y13 | VOICES 8, six INF bursts running, next step p-locked to VOICES 2 (v5.1) | That step stops the oldest five: one old burst plus the new one keep going. |
| Y7 | VOICES 8, several bursts, then stop the transport / turn RTRG off | Everything stops; no stuck notes. |
| Y8 | VOICES 2, VFAD −100 %, two notes at velocities 100 and 50 | Each burst fades from its own velocity to 1. |
| Y9 | VOICES 4, PMODE Note, PROB 50 % | Failed notes don't cut or steal anything. |
| Y10 | VOICES 4, instrument in Gate mode | Overlapping hits may sound short (expected: same pitch); nothing hangs. |
| Y11 | 16 pads, VOICES 8, dense notes (e.g. 1/16 notes, LEN 1/1, TRATE 1/64) | Note the CPU, in Live and on Push standalone. Listen for late or flammed notes. |

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

v5 adds subpatchers (`p`, with `inlet` and `outlet` inside). If v5 shows the error, load `Probe 97 p (empty subpatcher)` and `Probe 17 p` (the eight voices as they are) on fresh tracks and tell me which fail.

| # | Setup | Expect |
| --- | --- | --- |
| P1 | Select the pad on Push, open the device (on a fresh track) | A bank called "Retrig" with RTRG, RATE, LEN, VFAD, CRV, PROB, TRATE, GLIDE on encoders 1–8. No error screen. |
| P1a | Page to the second bank | "Chance" with PROB, LOCK, PMODE on encoders 1–3. PROB moves together on both banks. |
| P1c | Turn GLIDE, then Shift+turn | Fast sweep 0–128 with finer steps near 0; Shift fine-tunes. |
| P1d | Page to the third bank; also time how long the device takes to load on Push standalone | "Setup" with VOICES on encoder 1, stepping Mono, 2 … 8. ⚑ v5 is about 8 times the size of v4: tell me if loading feels slow. |
| P1b | Turn VFAD and CRV; then hold Shift and turn | A normal turn moves quickly across the range; Shift gives fine steps. Tell me if either feels too coarse or too slow. |
| P2 | Hold a step, turn RATE | The p-lock applies to that step only. ⚑ Open item: confirm the lock reaches the device before that step's note (if not, the step plays with the previous RATE). |
| P3 | Standalone mode: repeat tests 2, 5 and 12 | Same results; note CPU. |
