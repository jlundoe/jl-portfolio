-- Script functionality:
-- Reads the height of a selected envelope in pixels and displays it in the reaper console.

-------------------------------------------------------------------------------

function Print(param)
    reaper.ClearConsole()
    reaper.ShowConsoleMsg(tostring(param).."\n")
end

function GetEnvHeight()
    envelopeID =  reaper.GetSelectedEnvelope(0)
    currentEnvHeight = reaper.GetEnvelopeInfo_Value(envelopeID, "I_TCPH")
    Print("Envelope height in pixels: "..currentEnvHeight)
end

-- execute functions
GetEnvHeight()