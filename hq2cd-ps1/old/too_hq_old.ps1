# Function to check if a file is not CD quality
function IsNotCDQuality($filePath) {
    $ffprobeOutput = & ffprobe.exe -v error -select_streams a:0 -show_entries stream=sample_fmt,sample_rate -of csv=p=0 "$filePath"
    
    if ($ffprobeOutput -eq $null) {
        # ffprobe didn't return any output, possibly due to unsupported file format
        return $true  # Treat it as not CD quality
    }
    
    $sampleFormat, $sampleRate = $ffprobeOutput.Split(',')
    
    return ($sampleFormat -ne "s16" -or $sampleRate -ne "44100")
}

# Recursive function to scan directories
function ScanDirectories($path) {
    # Get all files in the current directory
    $files = Get-ChildItem -File -Path $path

    # Check each file
    foreach ($file in $files) {
        if (IsNotCDQuality $file.FullName) {
            if ($path.Length -ge 12) {
                $forPrint = $path.Substring(12)
                $forPrint = $forPrint.Replace("\", " - ")
                Write-Output $forPrint
            }
            break  # Only need to output the directory once
        }
    }

    # Recursively scan subdirectories
    $subdirectories = Get-ChildItem -Directory -Path $path
    foreach ($subdirectory in $subdirectories) {
        ScanDirectories $subdirectory.FullName
    }
}

# Start scanning from the current directory
ScanDirectories (Get-Location).Path
