if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Write-Host("Would you like to randomize the MacAddress of your network adapter (y or n): ") -NoNewline
$MacAddrPrompt = Read-Host
if ($MacAddrPrompt -eq "y") {
    [string]$MacAddr1 = Get-Random -Minimum 10 -Maximum 99
    [string]$MacAddr2 = Get-Random -Minimum 10 -Maximum 99
    [string]$MacAddr3 = Get-Random -Minimum 10 -Maximum 99
    [string]$MacAddr4 = Get-Random -Minimum 10 -Maximum 99
    [string]$MacAddr5 = Get-Random -Minimum 10 -Maximum 99
    [string]$MacAddr6 = Get-Random -Minimum 10 -Maximum 99

    Get-NetAdapter
    Write-Host("Write the name of the network adapter you would like to change the MacAddress of: ") -NoNewline
    $InterfaceToBeChanged = Read-Host
    $MacAddrFull = $MacAddr1 + ":" + $MacAddr2 + ":" + $MacAddr3 + ":" + $MacAddr4 + ":" + $MacAddr5 + ":" + $MacAddr6
    Set-NetAdapter -Name $InterfaceToBeChanged -MacAddress $MacAddrFull
    Write-Host("Restart your computer to finalize the change. You may be able to restart the network adapter but restarting is eaasier.")
    }


Write-Host("Would you like to change the host name of your computer (y or n): ") -NoNewline
$HostNamePrompt = Read-Host
#if ($HostNamePrompt -eq "y") {
#    Write-Host("Click rename pc and change it to something like Google-Home. You will be prompted to restart")
#    $HostNameOutputFile = ".\OriginalHostName [" + (Get-Date -UFormat "%Y-%m-%d") + "].txt"
#    Set-Content -LiteralPath $HostNameOutputFile -Value $env:ComputerName
#    Write-Host("Your old hostname has been saved to the folder the program was run from, for your conveinence")
#    Start-Sleep -Seconds 2
#    start ms-settings:about
#    }

if ($HostNamePrompt -eq "y") {
    if ($env:ComputerName -ne "Google Home") {
    $HostNameOutputFile = ".\OriginalHostName [" + (Get-Date -UFormat "%Y-%m-%d") + "].txt"
    Set-Content -LiteralPath $HostNameOutputFile -Value $env:ComputerName
    }
    #Write-Host("Enter your local username (should be what the folder in C:\Users\ is called): ") -NoNewline
    #$Username = Read-Host
    #$Username = $env:ComputerName + "\" + $Username
    #Write-Host("Enter your password for the account you specified: ") -NoNewline
    #$Password = Read-Host
    #$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force

    #$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $SecurePassword
    #$c = Get-Credential
    
    Write-Host("What should your new hostname be? There cannot be spaces: ") -NoNewline
    $NewHostName = Read-Host

    Rename-Computer -NewName $NewHostName #-LocalCredential domain\user
    Write-Host("Your hostname is now " + $NewHostName)
}
Write-Host("Would you like to restart your computer (required to register hostname change) (y or n): ") -NoNewline
$RestartPrompt = Read-Host
if ($RestartPrompt -eq "y") {
    Restart-Computer
    }