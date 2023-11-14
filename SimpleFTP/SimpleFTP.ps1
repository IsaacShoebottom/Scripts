# Create virtual environment
if (-not (Test-Path venv)) {
	virtualenv venv
}

# Activate virtual environment
.\venv\Scripts\activate.ps1

# Install dependencies
pip install pyftpdlib

# Run FTP server
python -m pyftpdlib

# Not working for streaming video files
# twistd -n ftp -r .