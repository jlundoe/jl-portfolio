-- Script functionality:
-- Deactivate individually targeted FX plugin on monitoring fx chain
-- If FX is active = deactivate it. If FX vst is deactivated - activate it
-- Put it in the global startup actions to reset it to on or off (based on user config below) on when booting Reaper

-- USER CONFIG AREA -----------------------------------------------------------

-- Define name of FX to toggle on/off.
-- MUST be an exact match (except for upper and lower case letters).
local targetFxName = "sonobus-mon"

-- Boolean to determine if reaper should default to on or off on, when action is called
-- the first time.
local resetToOff = true

------------------------------------------------------- END OF USER CONFIG AREA

local mastTrack = reaper.GetMasterTrack(0)
local monFxCount = reaper.TrackFX_GetRecCount(mastTrack)
local monOffset = (0x1000000)-1

is_new_value,filename,sectionID,cmdID,mode,resolution,val,contextstr = reaper.get_action_context()

for i = 0, monFxCount do
    local monitorPlugin = targetFxName
    local retval, individualFxName = reaper.TrackFX_GetFXName(mastTrack, monOffset+i)
    if retval then
        individualFxName = individualFxName:lower();
        if individualFxName == monitorPlugin then
            local fxIsEnabled = reaper.TrackFX_GetEnabled(mastTrack, monOffset+i)
            local calledFirstTime = reaper.GetExtState("toggleMonitorFxScript","calledFirstTime")
            if calledFirstTime == "" then
                reaper.SetExtState("toggleMonitorFxScript", "calledFirstTime", "true", false)
                if resetToOff then
                    reaper.TrackFX_SetEnabled(mastTrack, monOffset+i, false)
                    reaper.SetToggleCommandState(sectionID, cmdID, 0)
                else
                    reaper.TrackFX_SetEnabled(mastTrack, monOffset+i, true)
                    reaper.SetToggleCommandState(sectionID, cmdID, 1)
                end
            else
                if fxIsEnabled then
                    reaper.TrackFX_SetEnabled(mastTrack, monOffset+i, false)
                    reaper.SetToggleCommandState(sectionID, cmdID, 0)
                else
                    reaper.TrackFX_SetEnabled(mastTrack, monOffset+i, true)
                    reaper.SetToggleCommandState(sectionID, cmdID, 1)
                end
            end
        end
    end
end