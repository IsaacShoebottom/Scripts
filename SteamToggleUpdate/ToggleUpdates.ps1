# function that takes in an app id as a number and returns the path to the steam library folder that contains the app id
function parseVDFforPath([int]$appId) {
	# Steam libary folder vdf if using scoop
	$scoopVDF = "$env:USERPROFILE\scoop\apps\steam\current\steamapps\libraryfolders.vdf"
	# Steam library folders vdf absolute path
	$normalVDF = "C:\Program Files (x86)\Steam\steamapps\libraryfolders.vdf"

	# Set the path to the vdf file based on whether you are using scoop or not
	$steamLibraryFoldersVDF = if (Test-Path $scoopVDF) { $scoopVDF } else { $normalVDF }

	# convert the app id to a string
	$appIdString = $appId.ToString()

	# Get the contents of the vdf file
	$steamLibraryFoldersVDFContents = Get-Content $steamLibraryFoldersVDF

	# loop through each line of the vdf file
	foreach ($line in $steamLibraryFoldersVDFContents) {
		# if the line contains the app id
		if ($line.Contains($appIdString)) {
			# Take not of the line number
			$lineNumber = $steamLibraryFoldersVDFContents.IndexOf($line)

			# Get the line that contains the path, which you need to iterate backwards through the file, finding the first line that starts with "path"
			for ($i = $lineNumber; $i -gt 0; $i--) {
				# if the line starts with "path"
				if ($steamLibraryFoldersVDFContents[$i].contains("path")) {
					# take note of the line number
					$pathLineNumber = $i

					# get the line that contains the path
					$pathLine = $steamLibraryFoldersVDFContents[$pathLineNumber]

					# split the line by the quotation marks
					$pathLineSplit = $pathLine.Split('"')

					# the path is the 4th item in the array, because the keys are separated by quotation marks, and the values are separated by quotation marks
					$path = $pathLineSplit[3]

					# replace all the double backslashes with single backslashes, looks weird because each backslash needs to be escaped
					$path = $path.Replace("\\\\", "\\")

					# add on the actual manifest file name
					$path = $path + "\steamapps\appmanifest_" + $appIdString + ".acf"

					# return the path
					return $path
				}
			}
		}
	}
}

# function that changes the read only attribute of the manifest file
function toggleUpdate($Manifest) {
	# Get the read only attribute
	$ReadOnly = (Get-Item $Manifest).IsReadOnly

	# If the file is read only, remove the read only attribute, If the file is not read only, set the read only attribute
	If ($ReadOnly) { Set-ItemProperty $Manifest -Name IsReadOnly -Value $false } Else { Set-ItemProperty $Manifest -Name IsReadOnly -Value $true }

	# Display the read only attribute for reference
	Write-Host "Manifest file's read only attribute is now $((Get-Item $Manifest).IsReadOnly)"

	# Pause the script to see the output
	Read-Host -Prompt "Press Enter to exit"
}

toggleUpdate(parseVDFforPath($args[0]))