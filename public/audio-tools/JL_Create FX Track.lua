-- Inserts a new track that acts as an FX send. Audio input based on currently selected track(s).

-- USER CONFIG AREA -----------------------------------------------------------

-- Set Track Height A in pixels(default).
TrackHeight_A = 116

-- Set same track color. If several tracks selected the first selected track color is copied.
SetSameTrColor = false
CustomTrackColor = 29378772

-- Place new FX track right below selected tracks
PlaceNewDestTrAsLast = true

------------------------------------------------------- END OF USER CONFIG AREA

local defsendflag = ({reaper.BR_Win32_GetPrivateProfileString('REAPER', 'defsendflag', '0',  reaper.get_ini_file() )})[2]

function Main()
  local returnValue, sname = reaper.GetUserInputs('Send name', 1, 'FX track name' ,'FX: ')

  if returnValue then 
    TrackSum = reaper.CountSelectedTracks(0)
    local maxTrackNumber = -math.huge
    local minTrackNumber = math.huge

    -- get first and last (of selected tracks) position
    for i = 1, TrackSum do
      local tr = reaper.GetSelectedTrack(0, i - 1)
      local trPosNumber = reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER")
      minTrackNumber = math.min(minTrackNumber, trPosNumber)
      maxTrackNumber = math.max(maxTrackNumber, trPosNumber)
    end

    FirstSelTr = reaper.GetTrack(0, minTrackNumber - 1)
    NewDestTr = InsertTrackBelowSelTracks(maxTrackNumber)

    for i = 1, TrackSum do
      local trackID = reaper.GetSelectedTrack(0, i - 1)
      NewSendID = reaper.CreateTrackSend(trackID, NewDestTr)
      -- set track send volume to -inf dB
      reaper.SetTrackSendInfo_Value(trackID, 0, NewSendID, 'D_VOL', 0)
      -- set track to send as post-fx
      reaper.SetTrackSendInfo_Value(trackID, 3, NewSendID, 'I_SENDMODE', defsendflag)
    end

    if NewSendID >= 0 then
      if NewDestTr then
        SetDestTrackColor(FirstSelTr, NewDestTr)

        -- select created track
        reaper.SetOnlyTrackSelected(NewDestTr)

        reaper.GetSetMediaTrackInfo_String(NewDestTr, 'P_NAME', sname ,true)

        -- set track height to custom track_height
        reaper.SetMediaTrackInfo_Value(NewDestTr, "I_HEIGHTOVERRIDE", TrackHeight_A)

        --  set to "Display gain reduction in track meters for plug-ins that support it
        reaper.Main_OnCommand(42705, 0)
      end
    end
    reaper.TrackList_AdjustWindows(false)
  end
end

-- insert track right below last selected track
function InsertTrackBelowSelTracks(lastSelTrackPos)
    if PlaceNewDestTrAsLast == false then
      reaper.InsertTrackAtIndex(lastSelTrackPos, true)
      NewDestTr = reaper.GetTrack(0, lastSelTrackPos)
    else
      local varTotalTrNumber = reaper.GetNumTracks()
      reaper.InsertTrackAtIndex(varTotalTrNumber, true)
      NewDestTr = reaper.GetTrack(0, varTotalTrNumber)
    end
  return NewDestTr
end

-- set track color of new destination track
function SetDestTrackColor(firstSelTrack, destinationTrack)
  if firstSelTrack and SetSameTrColor then 
    TrackColor = reaper.GetTrackColor(firstSelTrack)
    if TrackColor ~= 0 then
      reaper.SetTrackColor(destinationTrack, TrackColor)
    end
  end
  if SetSameTrColor == false then
    reaper.SetTrackColor(destinationTrack, CustomTrackColor)
  end
end

Main()