-- Inserts a new track that acts as a resampling track for 'live resampling' purposes.
-- Audio input based on currently selected track(s).
-- If you are familiar with abletons 'resampling input option' it is similar, with the main difference
-- being that you choose the specific tracks you wish to receive audio from.
-- If both folder track and some of its child tracks is selected the script omits the child track in those folders (to prevent duplicating sources)

-- USER CONFIG AREA -----------------------------------------------------------

-- Set Track Height A in pixels(default).
MinimizedHeight = 116

-- Set same track color. If several tracks selected the first selected track color is copied.
SetSameTrColor = true

------------------------------------------------------- END OF USER CONFIG AREA

local defsendvol = ({reaper.BR_Win32_GetPrivateProfileString('REAPER', 'defsendvol', '1',  reaper.get_ini_file() )})[2]
local defsendflag = ({reaper.BR_Win32_GetPrivateProfileString('REAPER', 'defsendflag', '0',  reaper.get_ini_file() )})[2]
local isFolderTrackSelected = false
local selectedTracksArr = {}
local folderTrackArr = {}
local childTrackArr = {}
local maxTrackNumber = -math.huge
local minTrackNumber = math.huge

function Main()
  TrackSum = reaper.CountSelectedTracks(0)

  for i = 1, TrackSum do
    local tr = reaper.GetSelectedTrack(0, i - 1)
    -- insert selected tracks into array
    table.insert(selectedTracksArr, tr)
    --- check for folder tracks and set global bool
    if CheckFolderTracksSelected(tr) == 1 then
      if not isFolderTrackSelected then
        isFolderTrackSelected = true
      end
    end
    -- get first and last (of selected tracks) position
    local trPosNumber = reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER")
    minTrackNumber = math.min(minTrackNumber, trPosNumber)
    maxTrackNumber = math.max(maxTrackNumber, trPosNumber)
  end
  
  local returnvalue, trackname = setNewTrackName(minTrackNumber)
  -- insert track (if script name isn't cancelled)
  if returnvalue then 
    -- if the last track is a child track within a selected folder track
    -- iterate through selectedtracksarr
    for _, v in pairs(selectedTracksArr) do
      -- check for maxTrackNumber match with getmediatrack number
      if (reaper.GetMediaTrackInfo_Value(v, "IP_TRACKNUMBER") == maxTrackNumber) then
        -- when match, check if current track has parent in selected array
        local lastParentTrack = reaper.GetParentTrack(v)
        -- if parent exist, find last child track of that parent
        local lastChildTrack = getLastChildTrackInFolder(lastParentTrack)
        -- get that child tracks track number
        -- replace that track number in maxTrackNumber variable
        maxTrackNumber = reaper.GetMediaTrackInfo_Value(lastChildTrack, "IP_TRACKNUMBER")
      end
    end
    -- if a folder track is selected
    if isFolderTrackSelected then
      -- sort child and folder tracks into two new arrays
      for _, v in pairs(selectedTracksArr) do
        if (reaper.GetMediaTrackInfo_Value(v, "I_FOLDERDEPTH") == 1) then
          table.insert(folderTrackArr, v)
        else
          table.insert(childTrackArr, v)
        end
      end
      for _, childtr in pairs(childTrackArr) do
        local parentTrack = reaper.GetParentTrack(childtr)
        -- if child track is linked to a selected parent track remove that child track from the global array
        for _, foldertr in pairs(folderTrackArr) do
          if (parentTrack == foldertr) then
            local trackKey = getKeyFromValue(childtr)
            table.remove(selectedTracksArr, trackKey)
          end
        end
      end
    end

    local newDestTr = InsertTrackBelowSelTracks(maxTrackNumber)
    ConfigureNewTrack(newDestTr, trackname)
  end

  
end

function getLastChildTrackInFolder (tr)
  -- count all tracks in project and put in variable
  local projectTrackSum = reaper.CountTracks(0)
  -- change to zero-based index
  projectTrackSum = projectTrackSum - 1
  -- get parent track number
  local folderTrackNumber = reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER")
  -- change to zero based index
  local folderTrackIndex = folderTrackNumber - 1
  -- subtract current parent track number from project track sum variable
  local trSum = projectTrackSum - folderTrackIndex

  -- loop through tracks from current track number
  for i = folderTrackIndex, trSum + folderTrackIndex do
    local tr = reaper.GetTrack(0, i)
    -- check for last track in folder and if match return track
    if (reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH") == -1) then
      local lastTrackInFolder = tr
      return lastTrackInFolder
    end
  end
end

-- get key from value in selected tracks array
function getKeyFromValue(value)
  for i, v in pairs(selectedTracksArr) do
    if (value == v) then
      return i
    end
  end
end

function setNewTrackName(minTrackNumber)
  FirstSelTr = reaper.GetTrack(0, minTrackNumber - 1)
  local retval, FirstSelTrName = reaper.GetTrackName(FirstSelTr)
  if retval then
    -- popup window to input new destination track name. Is populated with ReSmpl + first selected track name
    returnvalue, strname = reaper.GetUserInputs('Send name', 1, 'Resampling track name' ,'ReSmpl: ' .. FirstSelTrName)
    return returnvalue, strname
  end
end

-- insert track right below last selected track
function InsertTrackBelowSelTracks(lastSelTrackPos)
  reaper.InsertTrackAtIndex(lastSelTrackPos, true)
  local newDestTr = reaper.GetTrack(0, lastSelTrackPos)
  return newDestTr
end

function ConfigureNewTrack(tr, trackname)
  for _, v in pairs(selectedTracksArr) do
    NewSendID = reaper.CreateTrackSend(v, tr)
    reaper.SetTrackSendInfo_Value(v, 0, NewSendID, 'D_VOL', defsendvol)
    reaper.SetTrackSendInfo_Value(v, 0, NewSendID, 'I_SENDMODE', defsendflag)
    SetOriginTrackRecState(v)
  end

  if NewSendID >= 0 then
    if tr then
      SetDestTrackColor(FirstSelTr, tr)

      -- select created track
      reaper.SetOnlyTrackSelected(tr)

      reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', trackname ,true)
      reaper.SetMediaTrackInfo_Value(tr, "I_RECMODE_FLAGS", 2)
      reaper.SetMediaTrackInfo_Value(tr, "I_RECMODE", 1)
      reaper.SetMediaTrackInfo_Value(tr, "I_RECARM", 1)
      reaper.SetMediaTrackInfo_Value(tr, "B_MUTE", 1)

      -- set track height to custom track_height
      reaper.SetMediaTrackInfo_Value(tr, "I_HEIGHTOVERRIDE", MinimizedHeight)

      --  set to "Display gain reduction in track meters for plug-ins that support it
      reaper.Main_OnCommand(42705, 0)
    end
  end
  reaper.TrackList_AdjustWindows(false)
end

-- set track color of new destination track
function SetDestTrackColor(firstSelTrack, destinationTrack)
  if firstSelTrack and SetSameTrColor then 
    TrackColor = reaper.GetTrackColor(firstSelTrack)
    if TrackColor ~= 0 then
      reaper.SetTrackColor(destinationTrack, TrackColor)
    else
      do return end
    end
  end
end

-- set recording state on original track based on its input-setting
function SetOriginTrackRecState(originTrack)
  MidiInputIsEnabled = false;

  if originTrack then
    local inputStateData = reaper.GetMediaTrackInfo_Value(originTrack, "I_RECINPUT")
    if inputStateData >= 4096 then
      MidiInputIsEnabled = true;
    else
      MidiInputIsEnabled = false;
    end
  end

  if MidiInputIsEnabled then
    reaper.Main_OnCommand(40491, 0)
    reaper.SetMediaTrackInfo_Value(originTrack, "I_RECARM", 0)
    reaper.SetMediaTrackInfo_Value(originTrack, "I_RECMODE", 0)
  else
    reaper.Main_OnCommand(40491, 0)
    reaper.SetMediaTrackInfo_Value(originTrack, "I_RECARM", 0)
    reaper.SetMediaTrackInfo_Value(originTrack, "I_RECMODE", 0)
  end
end

function CheckFolderTracksSelected (tr)
  local checkFolder = reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
  return checkFolder
end

Main()