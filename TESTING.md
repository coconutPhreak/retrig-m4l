# Testing Retrig

How to build the device, load it in Live, and what to check. v1 covers RTRG, RATE and LEN (timing only).

## Build and load

1. Build the device from the patcher source:

   ```bash
   python3 scripts/build_amxd.py
   ```

   This writes `build/Retrig.amxd`.
2. In Live, make a Drum Rack and load Simpler (or Drum Sampler) on one pad with a short click or rim sample.
3. Show the pad's chain and drag `build/Retrig.amxd` into it, *before* the instrument.
4. The device should show three controls: RTRG (on), RATE (1/16) and LEN (1/4).

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

## Push 3

### If Push standalone says "This device contains missing or incompatible Max objects"

Ableton doesn't publish which objects standalone rejects, so find out with probe devices:

```bash
python3 scripts/make_probes.py
```

This writes 14 tiny devices to `build/probes/`, one per object type used in Retrig. Load each on Push standalone and note which ones show the error. `Probe 00 baseline` has nothing extra and must load cleanly.

| # | Setup | Expect |
| --- | --- | --- |
| P1 | Select the pad on Push, open the device | A bank called "Retrig" with RTRG, RATE, LEN. No error screen. |
| P2 | Hold a step, turn RATE | The p-lock applies to that step only. ⚑ Open item: confirm the lock reaches the device before that step's note (if not, the step plays with the previous RATE). |
| P3 | Standalone mode: repeat tests 2, 5 and 12 | Same results; note CPU. |
