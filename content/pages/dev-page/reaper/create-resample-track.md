---
title: "Create Resample Track"
tags: [script, reaper, automation]
thumbnail: "/gifs/JL_Create Resample Track.gif"
download: "/audio-tools/reaper-scripts/JL_Create Resample Track.lua"
order: 4
---
### JL_Create Resample Track
Inserts a new track that acts as a resampling track for 'live resampling' purposes. Audio input is based on currently selected track(s). If you are familiar with Abletons 'resampling input option' it is similar, with the main difference being that you choose the specific tracks you wish to receive audio from.
![create resample track gif](/gifs/JL_Create%20Resample%20Track.gif)
###### User Config<br>
-- Set Track Height A in pixels(default).
-- Set same track color. If several tracks selected the first selected track color is copied.
-- Set track recording state if selected track is used as a midi instrument (midi input needs to be enable). true = Record: disable (input monitoring only). false = Record: input(audio or MIDI).