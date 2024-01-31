# Import json parsing and urllib
import json
import urllib.request
# Import subprocess for running dpkg
import subprocess

# Endpoint for the latest release
API_URL = "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"

# DEB file name, will be filled in later
DEB_NAME = ""
# URL for the latest deb file, will be filled in later
DEB_URL = ""
# Version number, will be filled in later
DEB_VERSION = ""
# Installed version number, will be filled in later
INSTALLED_VERSION = ""

# Get the latest release from the API
with urllib.request.urlopen(API_URL) as url:
    data = json.loads(url.read().decode())
    assets = data["assets"]
    for asset in assets:
        if asset["name"].endswith(".deb"):
            DEB_NAME = asset["name"]
            DEB_URL = asset["browser_download_url"]

# Parse the version number from the deb file name
# Example: obsidian_0.12.15_amd64.deb -> 0.12.15
DEB_VERSION = DEB_NAME.split("_")[1]

print("Latest version: " + DEB_VERSION)

# Get the installed version number by parsing the output of dpkg -s obsidian
output = subprocess.run(["dpkg", "-s", "obsidian"], capture_output=True)
# Parse the output for the version number
# Example: Version: 0.12.15
for line in output.stdout.decode().split("\n"):
    if line.startswith("Version:"):
        INSTALLED_VERSION = line.split(" ")[1]

print("Installed version: " + INSTALLED_VERSION)

def semver_check_new(old, new):
    # Split the version numbers into arrays of numbers
    old_split = old.split(".")
    new_split = new.split(".")
    # Loop through the numbers
    for i in range(len(old_split)):
        # If the new version is higher, return true
        if int(new_split[i]) > int(old_split[i]):
            return True
    # If the new version is the same or lower, return false
    return False

# Check if the new version is higher than the installed version
if semver_check_new(INSTALLED_VERSION, DEB_VERSION):
    print("New version available!")
    # Download the deb file
    urllib.request.urlretrieve(DEB_URL, DEB_NAME)
    # Install the deb file
    subprocess.run(["pkexec", "apt", "install", f"./{DEB_NAME}"])
    # Remove the deb file
    subprocess.run(["rm", DEB_NAME])
else:
    print("No new version available")
