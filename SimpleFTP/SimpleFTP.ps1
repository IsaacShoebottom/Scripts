param (
	[int] [alias('p')] $port = 21,
	[string] [alias('d')] $directory = '.',
	[bool] [alias('w')] $write = $false
)

$venv = "\.pyftplib"
$venv = $HOME + $venv
# Create virtual environment
if (-not (Test-Path $venv)) {
	write-host "Creating virtual environment at $venv"
	virtualenv "$venv"
}

# Activate virtual environment
. ($venv + "\Scripts\Activate.ps1")

# Install dependencies
pip install pyftpdlib

# Run FTP server
if ($write) {
	python -m pyftpdlib -p $port -d $directory -w
} else {
	python -m pyftpdlib -p $port -d $directory
}