# Rencode arg file 1 with ffmpeg crf and veryslow preset in x264 format, and audio with aac 192kbps and append "-Small" to the output filename
# Usage: ffmpeg-encode.ps1 arg1
$file = Get-ChildItem $args[0]
ffmpeg -i $file.FullName -c:v libx264 -preset veryslow -crf 20 -c:a aac -b:a 192k "$($file.BaseName)-Small.mp4"