; This script is very simple, it just starts a timer when the Ctrl + Shift + F11 key is pressed, starts recording in OBS, and then stops recording after 11 minutes using hotkeys within OBS
; 11 minutes is because I want to have a minute to make better looping while as close to 10m after editing
; Ctrl + Shift + F10 is what I use to toggle recording in OBS, so this script is useful for me to stop recording after 10 mins

^+F11::
	Send, ^+F10
	SetTimer, Timer, 600000
	Return

Timer:
	Send, ^+F10
	Return