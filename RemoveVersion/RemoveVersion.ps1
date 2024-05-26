# Get each folder in the current directory
$folders = Get-ChildItem -Directory

# Array to store the folders that need to be renamed
$work = @()

foreach ($folder in $folders) {
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
        $toadd = New-Object PSObject
        $toadd | Add-Member -MemberType NoteProperty -Name path -Value $folder.FullName
        $toadd | Add-Member -MemberType NoteProperty -Name newname -Value $new_name
        $work += $toadd

        Write-Host "Rename $folder to $new_name"
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
        $toadd = New-Object PSObject
        $toadd | Add-Member -MemberType NoteProperty -Name path -Value $folder.FullName
        $toadd | Add-Member -MemberType NoteProperty -Name newname -Value $new_name
        $work += $toadd

        Write-Host "Rename $folder to $new_name"
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
        $toadd = New-Object PSObject
        $toadd | Add-Member -MemberType NoteProperty -Name path -Value $folder.FullName
        $toadd | Add-Member -MemberType NoteProperty -Name newname -Value $new_name
        $work += $toadd

        Write-Host "Rename $folder to $new_name"
        continue
    }
}
Read-Host -Prompt "Press Enter to continue"
foreach ($item in $work) {
    Rename-Item -Path $item.path -NewName $item.newname
}