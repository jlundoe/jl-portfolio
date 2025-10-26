---
title: "Toggle Activate Monitor FX"
tags: [script, reaper, automation]
thumbnail: "/gifs/JL_toggle-activate-monitor-fx.gif"
download: "/audio-tools/reaper-scripts/JL_Toggle activate monitor FX.lua"
order: 7
---
### JL_toggle activate monitor FX
Toggle activate/deactivate individually targeted FX or Containers on the monitor FX chain. Useful if you have a setup with special routings or use a plugin like the SonoBus plugin to monitor on different devices. Put it in the Reaper startup actions (requires SWS extension) to reset the state to default (off or on based on user config) when booting Reaper.
![toggle activate monitor FX gif](/gifs/JL_toggle-activate-monitor-fx.gif)
###### User Config<br>
-- Define name of FX to toggle on/off.
-- MUST be an exact match (except for upper and lower case letters).