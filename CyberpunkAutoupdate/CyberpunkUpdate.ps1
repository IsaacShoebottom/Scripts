# Store manifest variable
$Manifest = "H:\Games\Steam\steamapps\appmanifest_1091500.acf"

# Get the read only attribute
$ReadOnly = (Get-Item $Manifest).IsReadOnly

# If the file is read only, remove the read only attribute, If the file is not read only, set the read only attribute
If ($ReadOnly) {Set-ItemProperty $Manifest -Name IsReadOnly -Value $false} Else {Set-ItemProperty $Manifest -Name IsReadOnly -Value $true}

# Display the read only attribute for reference
Write-Host "Manifest file's read only attribute is now $((Get-Item $Manifest).IsReadOnly)"

# Pause the script to see the output
Read-Host -Prompt "Press Enter to exit"