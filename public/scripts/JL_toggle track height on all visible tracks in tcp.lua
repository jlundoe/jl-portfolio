-- Script functionality:
-- Toggles between two different heights for visible tracks in tcp.
-- It reads the all visible tracks height and if their height differs it sets all visible tracks to track_height_a.
-- If track heights match each other and match either track_height_a or track_height_b it toggles to the opposite track height.

-- USER CONFIG AREA -----------------------------------------------------------

-- Set Track Height A in pixels(default)
track_height_a = 102

-- Set Track Height B in pixels
track_height_b = 493

-- If set to true script affects master track as well
setMasterTrack = true

------------------------------------------------------- END OF USER CONFIG AREA
visibleTrackTable = {}
visibleTrackIDTable = {}

function CountVisibleTracks()
    local trackSum = reaper.CountTracks(0)

    if (setMasterTrack == true) then
        local masterTrackVisible = reaper.GetMasterTrackVisibility()
        local masterTrackID = reaper.GetMasterTrack()
        if (masterTrackVisible == 1) then
            table.insert(visibleTrackTable, 1)
            table.insert(visibleTrackIDTable, masterTrackID)
        end
    end

    for i = 1, trackSum do
        local trackID = reaper.GetTrack(0, i - 1)
        if (reaper.IsTrackVisible(trackID, 0)) then
            table.insert(visibleTrackTable, #visibleTrackTable + 1)
            table.insert(visibleTrackIDTable, trackID)
        end
    end
    visibleTrackSum = #visibleTrackTable
end

function GetTrackHeight()
    trackHeightTable = {}
    
    for i = 1, visibleTrackSum do
        trackHeight = reaper.GetMediaTrackInfo_Value(visibleTrackIDTable[i], "I_TCPH")
        table.insert(trackHeightTable, trackHeight)
    end
end

function TrackHeightMatch()
    firstTrackHeight = trackHeightTable[1]
    
      for i,v in ipairs(trackHeightTable) do
          if (firstTrackHeight ~= v) then
              trackHeightMatch = false
              break
          else
              trackHeightMatch = true
          end
      end
end

function SetTrackHeight()
    if (trackHeightMatch == true and firstTrackHeight == track_height_a) then
        for i = 1, visibleTrackSum do
            reaper.SetMediaTrackInfo_Value(visibleTrackIDTable[i], "I_HEIGHTOVERRIDE", track_height_b)
        end
    else
        for i = 1, visibleTrackSum do
            reaper.SetMediaTrackInfo_Value(visibleTrackIDTable[i], "I_HEIGHTOVERRIDE", track_height_a)
        end
    end
end

-- execute functions
CountVisibleTracks()
GetTrackHeight()
TrackHeightMatch()
SetTrackHeight()

-- update GUI
reaper.TrackList_AdjustWindows(0)
reaper.UpdateArrange()
reaper.UpdateTimeline()