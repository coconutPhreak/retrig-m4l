# Retrig

Elektron-style retrigs for every pad in an Ableton Drum Rack, as a Max for Live MIDI effect. Works in Live and on Push 3, in both Standalone and Control Mode.

Put one Retrig in a pad's chain, in front of the instrument. Each note on that pad then becomes a burst of repeats, synced to Live's tempo. The burst can fade its velocity, speed up or slow down, skip repeats at random, and overlap with other bursts. Every control can be p-locked per step (Push step automation or clip envelopes).

## Requirements

- Ableton Live 12 Suite, or Live 12 Standard with Max for Live
- Optional: Push 3 (Standalone or Control Mode)

## Install

1. Download `Retrig.amxd` from the [latest release](https://github.com/coconutPhreak/retrig-m4l/releases/latest).
2. In a Drum Rack, show a pad's chain and drop `Retrig.amxd` into it, **before** the instrument.
3. Turn **RTRG** on (it's off by default, so the pad plays normally until you want retrigs).
4. Repeat for every pad you want to retrig. Each pad has its own settings.

On Push 3 Standalone, put `Retrig.amxd` in the User Library that your Push syncs with (see Ableton's Push 3 manual), then load it into a pad's chain the same way.

## Controls

A "step" is a 1/16 note.

| Control | Values | Default | What it does |
| --- | --- | --- | --- |
| RTRG | Off / On | Off | Retrig on or off. Off passes notes through unchanged. |
| RATE | 1/1 … 1/80 (17 values, including triplets and 1/5, 1/10 …) | 1/16 | Time between repeats. |
| LEN | 0.125 … 128 steps, INF | 1/4 (4 steps) | Length of the burst. INF keeps going until the next note, or until the transport stops. |
| VFAD | −100 … +100 % | 0 % | Velocity fade across the burst. Starts at the played velocity; −100 % ends on velocity 1, +100 % ends on 127. The fade lands exactly on the last hit. No fade with LEN INF. |
| CRV | 0 … 100 % | 0 % | Fade curve: 0 % linear, 100 % exponential. |
| PROB | 0 … 100 % | 100 % | Chance that retrigs fire. What it decides depends on PMODE. |
| LOCK | Off / On | Off | Ignore PROB: everything fires. Handy as a per-step p-lock. |
| PMODE | Repeats / Burst / Note | Repeats | **Repeats**: each repeat rolls on its own (the first hit always plays). **Burst**: one roll per note decides all of its repeats. **Note**: one roll decides whether the note plays at all. |
| TRATE | Off, 1/1 … 1/80 | Off | Speed fade: the rate the burst glides to. Off keeps RATE throughout. |
| GLIDE | 0 … 128 steps | 4 | How long the glide from RATE to TRATE takes. 0 jumps straight to TRATE. The rate changes evenly by ratio, then holds at TRATE. |
| VOICES | Mono, 2 … 8 | Mono | **Mono**: a new note cuts the running burst. **2–8**: bursts overlap, up to that many at once; when all are running, a new note stops the oldest. |

All settings are read when a note starts, so turning a control changes the next burst, and a p-locked step keeps its own settings for its whole burst. With VOICES above Mono, overlapping bursts can each have their own rate, fade and glide.

### Push banks

| Bank | Encoders 1–8 |
| --- | --- |
| Retrig | RTRG, RATE, LEN, VFAD, CRV, PROB, TRATE, GLIDE |
| Chance | PROB, LOCK, PMODE |
| Setup | VOICES |

Continuous controls (VFAD, CRV, PROB, GLIDE) turn quickly; hold Shift on Push for fine steps. List controls (RATE, LEN, TRATE, PMODE, VOICES) move one entry per encoder click.

## Tips and limits

- **Instrument settings.** Turn velocity-to-volume up (e.g. 100 % in Simpler), or VFAD fades will sound flat even though the velocities change.
- **Overlapping bursts (VOICES 2–8).** All bursts on a pad play the same note. Use One-Shot mode and give the instrument enough voices (Simpler: 8 or more, Retrigger off). In Gate mode, a note-off from one burst can cut a hit from another, so overlapping hits may sound short.
- **Choke groups** work as usual: a burst chokes, and is choked by, other pads in the same group.
- **Transport stopped.** Retrigs still work when you play pads by hand with the transport stopped. Stopping the transport ends every running burst.
- **Speed fade cap.** With TRATE on and a finite LEN, a burst stops after 256 hits.
- **CPU.** Tested with 16 pads retrigging at once, including with VOICES 8, in Live and on Push 3 Standalone, with no dropouts.

## Building from source

The device is built from readable patcher JSON in `src/`:

```bash
python3 scripts/build_amxd.py
```

This writes `build/Retrig.amxd`. It uses native Max objects only (no externals, no JavaScript), so it runs on Push 3 Standalone. See [TESTING.md](TESTING.md) for how to load and test it, [REQUIREMENTS.md](REQUIREMENTS.md) for the full spec and design decisions, and `scripts/make_probes.py` for checking new Max objects against Push Standalone.

## License

[MIT](LICENSE) © 2026 coconutPhreak
