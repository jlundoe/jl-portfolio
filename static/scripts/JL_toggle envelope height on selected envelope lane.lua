-- This script requires the SWS extension installed.

-- Script functionality:
-- Toggles between two different heights for the selected envelope.
-- It reads the individual selected envelope height and toggles to the other one.
-- If height does not match neither of the configurated envelope heights the bool default_envelope_a determines if set to a(true) or b(false).

-- thanks to Edgemeal for posting code snippets of reaper.BR_EnvAlloc on the Cockos forum


-- USER CONFIG AREA -----------------------------------------------------------

-- Set Track Height A in pixels(default)
envelope_height_a = 116

-- Set Track Height B in pixels
envelope_height_b = 500

-- Bool. Set to false if envelope should default to envelope_height_b instead of a.
default_envelope_a = true

------------------------------------------------------- END OF USER CONFIG AREA

function SetEnvHeightA()
    local br_env = reaper.BR_EnvAlloc(envelopeID, false)
    local active, visible, armed, inLane, laneHeight, defaultShape, _, _, _, _, faderScaling = reaper.BR_EnvGetProperties(br_env)
    local laneHeight = envelope_height_a
    reaper.BR_EnvSetProperties(br_env, active, visible, armed, inLane, laneHeight, defaultShape, faderScaling)
    reaper.BR_EnvFree(br_env, true)
end

function SetEnvHeightB()
    local br_env = reaper.BR_EnvAlloc(envelopeID, false)
    local active, visible, armed, inLane, laneHeight, defaultShape, _, _, _, _, faderScaling = reaper.BR_EnvGetProperties(br_env)
    local laneHeight = envelope_height_b
    reaper.BR_EnvSetProperties(br_env, active, visible, armed, inLane, laneHeight, defaultShape, faderScaling)
    reaper.BR_EnvFree(br_env, true)
end

function GetSetEnvelopeHeight()
    envelopeID =  reaper.GetSelectedEnvelope(0)

    if (not envelopeID) then
    printMsgBox("No envelope is selected. Action cannot be called.", "Envelope Height Toggle Failed")
    return end
    
    currentEnvHeight = reaper.GetEnvelopeInfo_Value(envelopeID, "I_TCPH")
  
    if (currentEnvHeight == envelope_height_b) then
        SetEnvHeightA()
    elseif (currentEnvHeight == envelope_height_a) then
        SetEnvHeightB()
    elseif (currentEnvHeight ~= envelope_height_b and currentEnvHeight ~= envelope_height_a and default_envelope_a == true) then
        SetEnvHeightA()
    else
        SetEnvHeightB()
    end
end

function printMsgBox (msg, title)
    reaper.ShowMessageBox(msg, title, 0)
end

-- execute functions
GetSetEnvelopeHeight()

-- update GUI
reaper.TrackList_AdjustWindows(0)



