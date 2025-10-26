---
title: "Smart Item Mute Toggle"
tags: [script, reaper, automation]
thumbnail: "/gifs/JL_toggle mute on items if same else mute.gif"
download: "/audio-tools/reaper-scripts/JL_Toggle mute on items if same else mute.lua"
order: 8
---
### JL_toggle mute on items if same else mute
Toggle mute on selected media items with the following conditions:
If the selected media items are all muted, then unmute all the selected media items.
If the selected media items are all unmuted, then mute all the selected media items.
If the selected media items are both muted and unmuted (they differ), then mute all the selected media items.
![toggle mute gif](/gifs/JL_toggle%20mute%20on%20items%20if%20same%20else%20mute.gif)
###### User Config<br>
-- Bool. Set to true if item should unmute(instead of mute) if the selected item mute states don't match.