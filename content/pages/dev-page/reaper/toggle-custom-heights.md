---
title: "Toggle Custom Heights - Envelopes and Tracks"
tags: [script, reaper, automation]
thumbnail: "/gifs/JL_Set custom height actions - envelopes and tracks.gif"
download: "/audio-tools/reaper-scripts/JL_Toggle Custom Heights - Envelopes and Tracks.zip"
order: 2
---
### Set custom height actions - envelopes and tracks
![custom height actions gif](/gifs/JL_Set%20custom%20height%20actions%20-%20envelopes%20and%20tracks.gif)

### JL_read envelope height in pixels(utility)
Reads the height of a selected envelope in pixels and displays it in the reaper console.

### JL_read track height in pixels(utility)
Reads the height of a track in pixels and displays it in the reaper console. If several tracks is selected it displays an error message and do not get called.

### JL_toggle envelope height on selected envelope lane
This script requires the SWS extension installed.
Script functionality:
Toggles between two different heights for the selected envelope. It reads the individual selected envelope height and toggles to the other one. If height does not match neither of the configurated envelope heights the bool default_envelope_a determines if set to a(true) or b(false). Thanks to Edgemeal for posting code snippets of reaper.BR_EnvAlloc on the Cockos forum.
###### User Config
-- Set Track Height A in pixels(default)
-- Set Track Height B in pixels
-- Bool. Set to false if envelope should default to envelope_height_b instead of a.

### JL_toggle track height on all visible tracks in tcp
Toggles between two different heights for visible tracks in tcp. It reads all the visible tracks height and if their height differs it sets all visible tracks to track_height_a. If track heights match each other and match either track_height_a or track_height_b it toggles to the opposite track height.
###### User Config
-- Set Track Height A in pixels(default)
-- Set Track Height B in pixels

### JL_toggle track height on selected tracks in tcp if match
Toggles between two different heights for selected tracks in tcp. It reads the selected tracks height and if their height differs it sets all selected tracks to track_height_a. If track heights match each other and either track_height_a or track_height_b it toggles to the opposite track height.
###### User Config
-- Set Track Height A in pixels(default)
-- Set Track Height B in pixels