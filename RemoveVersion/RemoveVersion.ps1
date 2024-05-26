# Get each folder in the current directory
$folders = Get-ChildItem -Directory
foreach ($folder in $folders) {
    # Get each folder in the folder
    $new_folders = Get-ChildItem -Path $folder.FullName -Directory
    foreach ($folder in $new_folders) {
        # Find the version number in the folder name 
        $version = $folder.Name -match '(\d+\.\d+\.\d+\.\d+)'
        if ($version) {
            # Replace entire folder name with the version number
            $new_name = $matches[0]

            # if version has a alpha character, remove it, eg 0.1.0a, then re-add it to new name
            $alpha = $folder.Name -match '(\d+\.\d+\.\d+\.\d+)([a-zA-Z])'
            if ($alpha) {
                $new_name = $matches[1]
                $new_name = $new_name + $matches[2]
            }

            #Rename-Item -Path $folder.FullName -NewName $new_name
            Write-Host "Renamed $folder to $new_name"
            continue
        }
        # Find the version number in the folder name
        $version = $folder.Name -match '(\d+\.\d+\.\d+)'
        if ($version) {
            # Replace entire folder name with the version number
            $new_name = $matches[0]

            # if version has a alpha character, remove it, eg 0.1.0a, then re-add it to new name
            $alpha = $folder.Name -match '(\d+\.\d+\.\d+)([a-zA-Z])'
            if ($alpha) {
                $new_name = $matches[1]
                $new_name = $new_name + $matches[2]
            }

            #Rename-Item -Path $folder.FullName -NewName $new_name
            Write-Host "Renamed $folder to $new_name"
            continue
        }
        # Find the version number in the folder name
        $version = $folder.Name -match '(\d+\.\d+)'
        if ($version) {
            # Replace entire folder name with the version number
            $new_name = $matches[0]

            # if version has a alpha character, remove it, eg 0.1.0a, then re-add it to new name
            $alpha = $folder.Name -match '(\d+\.\d+)([a-zA-Z])'
            if ($alpha) {
                $new_name = $matches[1]
                $new_name = $new_name + $matches[2]
            }

            #Rename-Item -Path $folder.FullName -NewName $new_name
            Write-Host "Renamed $folder to $new_name"
            continue
        }
    }
}