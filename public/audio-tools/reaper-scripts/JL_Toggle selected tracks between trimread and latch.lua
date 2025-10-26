-- Script functionality:
-- Toggles between trim/read and latch on selected tracks automation mode.
-- If latch mode is not selected it sets the individual selected tracks to latch mode.
-- If latch mode is selected it sets the individual selected tracks to trim/read mode.

-------------------------------------------------------------------------------

function CountSelTracks()
    trackSum = reaper.CountSelectedTracks(0)
end

function GetTrackAutomationState()

    trackNumberTable = {}
    trackStateTable = {}

    for i = 1, trackSum do

        trackNumber = reaper.GetSelectedTrack(0, i - 1)
        track_automationMode = reaper.GetMediaTrackInfo_Value(trackNumber, "I_AUTOMODE")
        
        table.insert(trackStateTable, track_automationMode)
        table.insert(trackNumberTable, trackNumber)
        
        SetTrackAutomationState()
    end
end

function SetTrackAutomationState()
    if (track_automationMode ~= 4.0) then
    reaper.SetMediaTrackInfo_Value(trackNumber, "I_AUTOMODE", 4.0)
    else
    reaper.SetMediaTrackInfo_Value(trackNumber, "I_AUTOMODE", 0.0)
    end
end

-- execute functions
CountSelTracks()
GetTrackAutomationState()

-- update GUI
reaper.UpdateArrange()
