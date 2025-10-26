-- Script functionality:
-- Toggle mute on selected media items with the following conditions:
-- If the selected media items are all muted, then unmute all the selected media items.
-- If the selected media items are all unmuted, then mute all the selected media items.
-- If the selected media items are both muted and unmuted (they differ), then mute all the selected media items.

-- USER CONFIG AREA -----------------------------------------------------------

-- Bool. Set to true if item should unmute(instead of mute) if the selected item mute states don't match.
unmuteItem = false

------------------------------------------------------- END OF USER CONFIG AREA

function CountSelItems()
    itemSum = reaper.CountSelectedMediaItems(0)
end

function GetMuteStates()

    muteStateTable = {}
    itemNumberTable = {}

    for i = 1, itemSum do

        itemNumber = reaper.GetSelectedMediaItem(0, i - 1)
        item_mute = reaper.GetMediaItemInfo_Value(itemNumber, "B_MUTE")
        
        table.insert(muteStateTable, item_mute)
        table.insert(itemNumberTable, itemNumber)
    end
end

function CheckMuteStateMatch()
    firstItemState = muteStateTable[1]
    
    for i,v in ipairs(muteStateTable) do
        if (firstItemState ~= v) then
            itemStateMatch = false
            break
        else
            itemStateMatch = true
        end
    end
end

function SetItemMute()
    if (itemStateMatch == false and unmuteItem == false) then
        for i = 1, itemSum do
            reaper.SetMediaItemInfo_Value(itemNumberTable[i], "B_MUTE", 1)
        end
    elseif (itemStateMatch == false and unmuteItem == true) then
        for i = 1, itemSum do
        reaper.SetMediaItemInfo_Value(itemNumberTable[i], "B_MUTE", 0)
        end
    elseif (itemStateMatch == true) then
        -- Reaper action || Item Properties: Toggle Mute
        reaper.Main_OnCommand(40175, 0)
    end
end

-- execute functions
CountSelItems()
GetMuteStates()
CheckMuteStateMatch()
SetItemMute()

-- update GUI
reaper.UpdateArrange()
