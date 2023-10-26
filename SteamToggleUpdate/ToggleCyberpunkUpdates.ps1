$appId = 1091500
$networkLocation = "https://raw.githubusercontent.com/IsaacShoebottom/Scripts/master/SteamToggleUpdate/ToggleUpdates.ps1"

# Test if ToggleUpdates.ps1 exists and invoke it if it does
If (Test-Path -Path ".\ToggleUpdates.ps1" -PathType Leaf) {
	.\ToggleUpdates.ps1 $appId
}
Else {
	# Download the network script
	$wc = New-Object System.Net.WebClient
	$wc.DownloadFile($networkLocation, ".\ToggleUpdates.ps1")
	# Invoke the network script
	.\ToggleUpdates.ps1 $appId
	# Delete the network script
	Remove-Item -Path ".\ToggleUpdates.ps1"
}