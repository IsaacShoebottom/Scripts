# From the current folder, make a powershell array that finds all files with the .flac extension and add them to a list

# Get all files with the .flac extension
$files = Get-ChildItem -Path . -Filter *.flac -Recurse

# For each file, run ffprobe with json ouptut, and include it in a new list if it has a sample rate above 44100, and a bit depth above 16

$hq = @()

$files | ForEach-Object -Parallel {
	$ffprobe = ffprobe -v quiet -print_format json -show_format -show_streams $_.FullName
	$ffprobe = $ffprobe | ConvertFrom-Json
	if ($ffprobe.format.sample_rate -gt 44100 -and $ffprobe.streams.bits_per_raw_sample -gt 16) {
		$hq += $_
	}
}

Write-Host $hq