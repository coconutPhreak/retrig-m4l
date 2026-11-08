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
- Workflow: Claude writes the patcher; the user opens it in Max, tests in Live, saves it as `.amxd`, and pastes any Max console errors back.

## Out of scope and open items

Rack-wide features (sample assignment, pad naming, auto-inserting this device into chains) belong to the separate Kit device, not this one.

- [ ] Confirm the exact RATE value list against the Elektron manual
- [ ] Confirm the VFAD range and how it maps to the end velocity
- [ ] Decide fade behaviour when LEN is INF
- [ ] Test the device on Push 3 standalone early
