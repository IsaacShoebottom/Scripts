# Delete output folder if it exists
if (Test-Path -Path "Output") {
	Remove-Item -Path "Output" -Recurse -Force
}

# Read each line in the file
$filePaths = Get-Content -Path $args[0]

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

$filePaths | ForEach-Object -Parallel {
	# Stupid apostrophe in the file name
	# Intentional, as this is how Picard names files with apostrophes
	$path = $_.Replace("'", "’")

	$file = Get-Item -LiteralPath $path

	$destination = "Output"
	$prefix = "Z:\Music-HQ\"



	$oldLocation = $file.FullName
	# Remove the prefix
	$newLocation = $oldLocation.Substring($prefix.Length)
	# Remove the name of the file for folder creation
	$newLocation = $newLocation.Substring(0, $newLocation.IndexOf($file.Name))

	# Create the folder if it doesn't exist
	if (-not (Test-Path -Path $destination\$newLocation)) {
		New-Item -Path $destination\$newLocation -ItemType Directory
	}
	$destinationPath = $destination + "\" + $newLocation + $file.Name

	Write-Host $destinationPath

	ffmpeg -i $_.FullName -c:a flac -sample_fmt s16 -ar 44100 $destinationPath
}