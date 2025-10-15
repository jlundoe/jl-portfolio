-- Script functionality:
-- Toggles between two different heights for selected tracks in tcp.
-- It reads the selected tracks height and if their height differs it sets all selected tracks to track_height_a.
-- If track heights match each other and either track_height_a or track_height_b it toggles to the opposite track height.

-- USER CONFIG AREA -----------------------------------------------------------

-- Set Track Height A in pixels(default)
track_height_a = 102

-- Set Track Height B in pixels
track_height_b = 493

-- If set to true script affect master track (if selected) as well
setMasterTrack = true

------------------------------------------------------- END OF USER CONFIG AREA
trackHeightTable = {}
trackNumberTable = {}

function CountSelTracks()
    TrackSum = reaper.CountSelectedTracks2(0, setMasterTrack)
end

function GetTrackHeight()
    for i = 1, TrackSum do
        trackNumber = reaper.GetSelectedTrack2(0, i - 1, setMasterTrack)
        trackHeight = reaper.GetMediaTrackInfo_Value(trackNumber, "I_TCPH")
        table.insert(trackHeightTable, trackHeight)
        table.insert(trackNumberTable, trackNumber)
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
        for i = 1, TrackSum do
            reaper.SetMediaTrackInfo_Value(trackNumberTable[i], "I_HEIGHTOVERRIDE", track_height_b)
        end
    else
        for i = 1, TrackSum do
            reaper.SetMediaTrackInfo_Value(trackNumberTable[i], "I_HEIGHTOVERRIDE", track_height_a)
        end
    end
end

-- execute functions
CountSelTracks()
GetTrackHeight()
TrackHeightMatch()
SetTrackHeight()

-- update GUI
reaper.TrackList_AdjustWindows(0)
reaper.UpdateArrange()
reaper.UpdateTimeline()