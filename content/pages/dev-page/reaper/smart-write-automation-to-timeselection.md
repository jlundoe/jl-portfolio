---
title: "Smart Write Automation to Timeselection"
tags: [script, reaper, automation]
thumbnail: "/gifs/JL_smart write automation to timeselection.gif"
download: "/audio-tools/reaper-scripts/JL_Smart Write Automation To Timeselection.lua"
order: 6
---
### JL_Smart Write Automation to Timeselection
Writes automation to selection (based on time selection) when toggling from latch preview to trim/read mode. Toggles between trim/read and latch preview on selected tracks automation mode. If latch preview mode is not selected it sets all tracks to trim/read mode (to prevent mistakes) and then sets the selected track to latch preview. If latch preview mode is selected it writes the changed values(changed during latch preview mode) to the track envelopes within the time selection, and then sets all tracks to trim/read mode, including the selected ones(to prevent mistakes).
![latch preview toggle action gif](/gifs/JL_smart%20write%20automation%20to%20timeselection.gif)