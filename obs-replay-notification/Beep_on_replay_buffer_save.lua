local obs = obslua
local ffi = require("ffi")
local winmm = ffi.load("Winmm")

-- Put a sound of your choosing next to "Beep on replay save.lua" and don't forget to match its name either in code below or rename your file.
PROP_AUDIO_FILEPATH = script_path() .. "sound_npc_scanner_scanner_photo1.wav"

ffi.cdef[[
    bool PlaySound(const char *pszSound, void *hmod, uint32_t fdwSound);
]]

function playsound(filepath)
    winmm.PlaySound(filepath, nil, 0x00020000)
end

function on_event(event) 
  if event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_SAVED 
    then playsound(PROP_AUDIO_FILEPATH) 
  end 
end

function script_load(settings)
  obs.obs_frontend_add_event_callback(on_event)
end

-- This Lua script was downloaded from https://gist.github.com/snakecase/e816384a071cec31efbb4b9e429c108d

-- Credits: upgradeQ (https://gist.github.com/upgradeQ/b2412242d76790d7618d6b0996c4562f), gima (https://gitlab.com/gima/obsnotification)
-- Thank you guys!