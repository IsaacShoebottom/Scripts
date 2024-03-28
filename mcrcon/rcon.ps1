$ip = "localhost"
$ip = Read-Host -Prompt 'Enter the RCON IP (default: localhost)'
$password = Read-Host -MaskInput -Prompt 'Enter the RCON Password'
mcrcon -H $ip -p $password
