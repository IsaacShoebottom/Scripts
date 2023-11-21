# From the current folder, make a powershell array that finds all files with the .flac extension and add them to a list

# Get all files with the .flac extension
$files = Get-ChildItem -Path . -Filter *.flac -Recurse

Write-Host "Found" $files.Count "files"

# For each file, run ffprobe with json ouptut, and include it in a new list if it has a sample rate above 44100, and a bit depth above 16

$hq = @()

<# This is the old way, use the new way below using -Parallel
foreach ($file in $files) {
	$ffprobe = ffprobe -v quiet -print_format json -show_format -show_streams $file.FullName
	$ffprobe = $ffprobe | ConvertFrom-Json
	$stream = $ffprobe.streams | Where-Object {$_.codec_name -eq "flac"}

	if ($stream.sample_rate -gt 44100 -or $stream.bits_per_raw_sample -gt 16) {
		Write-Host $file.FullName
		$hq += $file
	}
} 
#>
$files | ForEach-Object -Parallel {
	$ffprobe = ffprobe -v quiet -print_format json -show_format -show_streams $_.FullName
	$ffprobe = $ffprobe | ConvertFrom-Json
	$stream = $ffprobe.streams | Where-Object {$_.codec_name -eq "flac"}

	if ($stream.sample_rate -gt 44100 -or $stream.bits_per_raw_sample -gt 16) {
		Write-Host $_.FullName
		$hq += $_
	}
}

# Save each file in hq to a text file with its full path
foreach ($file in $hq) {
	$file.FullName | Out-File -FilePath hq.txt -Append
}