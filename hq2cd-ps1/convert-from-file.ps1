# Read each line in the file
$filePaths = Get-Content -Path $args[0]
$files = @()
foreach ($filePath in $filePaths) {
	$files += Get-Item -Path "$($filePath)" -Force
}

# Save to output folder "Output"
$destination = "Output"
if (-not (Test-Path -Path $destination)) {
	New-Item -Path $destination -ItemType Directory
}

# Now use ffmpeg to convert each file to 16-bit 44.1kHz
<# This is the old way, use the new way below using -Parallel
foreach ($file in $files) {
	$destinationPath = $destination + "\" + $file.Name
	ffmpeg -i $file.FullName -c:a flac -sample_fmt s16 -ar 44100 $destinationPath
} 
#>

$prefix = "Z:\Music-HQ\"
$files | ForEach-Object -Parallel {
	$oldLocation = $_.FullName
	# Remove the prefix
	$newLocation = $oldLocation.Substring($prefix.Length)
	# Remove the name of the file for folder creation
	$newLocation = $newLocation.Substring(0, $newLocation.IndexOf($_.Name))

	# Create the folder if it doesn't exist
	if (-not (Test-Path -Path $destination\$newLocation)) {
		New-Item -Path $destination\$newLocation -ItemType Directory
	}

	$destinationPath = $destination + "\" + $newLocation + $_.Name
	Write-Host $destinationPath
	# ffmpeg -i $_.FullName -c:a flac -sample_fmt s16 -ar 44100 $destinationPath
}