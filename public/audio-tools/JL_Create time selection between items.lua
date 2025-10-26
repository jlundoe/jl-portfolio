-- Script functionality:
-- This script creates a timeselection between to items in the arrange view.
-- It uses default Reaper action commands to achieve this behaviour.

-- The cursor needs to be placed between the two items where you want to create the time selection,
-- since the script uses the cursor to achieve the desired behaviour.

-- You can assign it to a mouse modifier of your choice. For example:
-- Preferences/Editing Behavior/Mouse Modifiers: Track | Double-Click | Default Action

-------------------------------------------------------------------------------

function CreateTimeSelectionBetweenItems()
    -- Action || Item navigation: Move cursor left to nearest item edge
        reaper.Main_OnCommand(41167, 0)
    -- Action || Time selection: Set start point
        reaper.Main_OnCommand(40625, 0)
    -- Action || Item navigation: Move cursor right to nearest item edge
        reaper.Main_OnCommand(41168, 0)
    -- Action || Time selection: Set end point
        reaper.Main_OnCommand(40626, 0)
end

-- execute functions
CreateTimeSelectionBetweenItems()

-- update GUI
reaper.UpdateArrange()