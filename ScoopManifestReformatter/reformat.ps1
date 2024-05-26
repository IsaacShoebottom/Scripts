<#
use this order to reformat json objects:
version
description
homepage
license
notes
depends
suggest
architecture
url
hash
extract_dir
extract_to
pre_install
installer
post_install
env_add_path
env_set
bin
shortcuts
persist
pre_uninstall
uninstaller
post_uninstall
checkver
autoupdate
#>

# Read all json files in the current directory
Get-ChildItem -Filter *.json | ForEach-Object {
    # Read the file
    $json = Get-Content $_.FullName | ConvertFrom-Json -Depth 9

    # Create a new object with the properties in the desired order
    $newJson = [ordered]@{
        version = $json.version
        description = $json.description
        homepage = $json.homepage
        license = $json.license
        notes = $json.notes
        depends = $json.depends
        suggest = $json.suggest
        architecture = $json.architecture
        url = $json.url
        hash = $json.hash
        extract_dir = $json.extract_dir
        extract_to = $json.extract_to
        pre_install = $json.pre_install
        installer = $json.installer
        post_install = $json.post_install
        env_add_path = $json.env_add_path
        env_set = $json.env_set
        bin = $json.bin
        shortcuts = $json.shortcuts
        persist = $json.persist
        pre_uninstall = $json.pre_uninstall
        uninstaller = $json.uninstaller
        post_uninstall = $json.post_uninstall
        checkver = $json.checkver
        autoupdate = $json.autoupdate
    }
    # Remove any null properties
    $newJson = $newJson | Where-Object { $_.Value -ne $null }

    # Convert the new object back to json and write it back to the file
    $newJson | ConvertTo-Json -Depth 9 | Set-Content $_.FullName
}

# Run scoop json prettier on all json files in the current directory
~/scoop/apps/scoop/current/bin/formatjson.ps1 -Dir .