-- Script functionality:
-- Reads the height of a track in pixels and displays it in the reaper console.
-- If several tracks is selected it displays an error message and do not get called.

-------------------------------------------------------------------------------
function Print(param)
    reaper.ClearConsole()
    reaper.ShowConsoleMsg(tostring(param).."\n")
end

function CountSelTracks()
    TrackSum = reaper.CountSelectedTracks2(0, true)
end

function GetTrackHeight()
    if (TrackSum > 1) then
        Print("Error. More than one track selected. Select one track you wish to read the height of.")
    elseif (TrackSum == 1) then
        local trackNumber = reaper.GetSelectedTrack2(0, 0, true)
        local trackHeight = reaper.GetMediaTrackInfo_Value(trackNumber, "I_TCPH")
        Print("Track height in pixels: "..trackHeight)
    end
end

-- execute functions
CountSelTracks()
GetTrackHeight()