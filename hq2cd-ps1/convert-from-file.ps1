# Output to a flat directory as I am going to use picard to rename the files after the fact

# Read each line in the file
$filePaths = Get-Content -Path $args[0]
$files = @()
foreach ($filePath in $filePaths) {
	$files += Get-Item -Path $filePath
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
$files | ForEach-Object -Parallel {
	$destinationPath = $destination + "\" + $_.Name
	ffmpeg -i $_.FullName -c:a flac -sample_fmt s16 -ar 44100 $destinationPath
}