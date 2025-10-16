-- Script functionality:
-- Toggles between trim/read and latch preview on selected tracks automation mode.
-- If latch preview mode is not selected it sets all tracks to trim/read mode (to prevent mistakes) and then sets the selected track to latch preview.
-- If latch preview mode is selected it writes the changed values(changed during latch preview mode) to the track envelopes within the time selection,
-- and then sets all tracks to trim/read mode, inlcuding the selected ones(to prevent mistakes).

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
    if (track_automationMode ~= 5.0) then
        -- Reaper action || Automation: Set all tracks automation mode to trim/read
        reaper.Main_OnCommand(40088, 0)
        reaper.SetMediaTrackInfo_Value(trackNumber, "I_AUTOMODE", 5.0)
    else
        -- Reaper action || Automation: Write current values for actively-writing envelopes to time selection
        reaper.Main_OnCommand(42013, 0)
        reaper.SetMediaTrackInfo_Value(trackNumber, "I_AUTOMODE", 0.0)
        -- Reaper action || Automation: Set all tracks automation mode to trim/read
        reaper.Main_OnCommand(40088, 0)
    end
end

-- execute functions
CountSelTracks()
GetTrackAutomationState()

-- update GUI
reaper.UpdateArrange()
