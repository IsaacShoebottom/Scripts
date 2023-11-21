# With ffmpeg simply copy the vidoe and auto contents into an mp4 container

# args[0] = file path
# args[1] = -d or --delete to delete the original file after conversion
$file = Get-ChildItem $args[0]
$del = $args[1]
# Invoke ffmpeg to copy the video and audio streams into an mp4 container
ffmpeg -i $file.FullName -c copy "$($file.BaseName).mp4"
# Delete the original file if the second argument is -d or --delete
if ($del -eq "-d" -or $del -eq "--delete") {
	Remove-Item $file
}