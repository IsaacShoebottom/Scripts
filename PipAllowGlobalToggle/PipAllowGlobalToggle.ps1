# Pip config location: C:\Users\{username}\AppData\Roaming\pip\pip.ini
$location = "$env:APPDATA\pip\pip.ini"

# Check if pip.ini exists
if (Test-Path $location) {
	# If it exists, read it
	$pipConfig = Get-Content $location
	# Content for pip.ini
	$newPipConfig = foreach ($line in $pipConfig) {
		# If the line starts with "require-virtualenv"
		if ($line.StartsWith("require-virtualenv")) {
			# If it exists, toggle it
			if($line.EndsWith("True")) {
				$line.Replace("True", "False")
			} else {
				$line.Replace("False", "True")
			}
		} else {
			# If it doesn't exist, just write the line
			$line
		}
	}

	Write-Host $pipConfig
	Write-Host "-----------------"
	Write-Host $newPipConfig

	# Write the new content to the file
	$newPipConfig | Out-File $location -Force
} else {
	# If it doesn't exist, create it
	New-Item -Path $location -ItemType File
	Add-Content -Path $location -Value "[global]"
	Add-Content -Path $location -Value "require-virtualenv = True"
}

# Command using python
# python -m pip config set global.require-virtualenv True