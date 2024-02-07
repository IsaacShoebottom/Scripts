ASAR = "app.asar"
ASAR_BACKUP = ASAR + ".bak"
SYMLINK_PATH = ""
REAL_PATH = ""
DISCORD_FOLDER = ""
RESOURCES_PATH = ""

def root():
    import os
    if os.geteuid() != 0:
        print("Script not running as root")
        exit()

def backup():
    import os
    # Check for existing backup
    if os.path.isfile(RESOURCES_PATH + ASAR_BACKUP):
        print("Backup already exists, openasar is already installed")
        exit()
    try:
        print(RESOURCES_PATH + ASAR)
        os.rename(RESOURCES_PATH + ASAR, RESOURCES_PATH + ASAR_BACKUP)
    except Exception as e:
        print("Couldn't rename file: " + str(e)) 

def find():
    import os
    from shutil import which

    # Get full path of discord symlink on path
    global SYMLINK_PATH
    SYMLINK_PATH = which("discord")
    # Parse real path of discord symlink
    global REAL_PATH
    REAL_PATH = os.path.realpath(SYMLINK_PATH)
    # Get containing folder
    global DISCORD_FOLDER
    DISCORD_FOLDER = os.path.dirname(REAL_PATH)
    # Add /resources/ to the real path
    global RESOURCES_PATH
    RESOURCES_PATH = DISCORD_FOLDER + "/resources/"


def download():
    import urllib.request
    import json
    # Get nightly release from github
    # url: https://github.com/GooseMod/OpenAsar/
    # release: https://github.com/GooseMod/OpenAsar/releases/tag/nightly
    API_URL = "https://api.github.com/repos/GooseMod/OpenAsar/releases/latest"
    DOWNLOAD_URL = ""

    with urllib.request.urlopen(API_URL) as url:
        data = json.loads(url.read().decode())
        DOWNLOAD_URL = data['assets'][0]['browser_download_url']

    # Download the file
    urllib.request.urlretrieve(DOWNLOAD_URL, RESOURCES_PATH + ASAR)

def kill():
    import os
    import signal
    import psutil

    # Get discord process
    for proc in psutil.process_iter():
        if proc.name() == "Discord":
            # Kill discord
            os.kill(proc.pid, signal.SIGTERM)

def uninstall():
    import os
    if os.path.isfile(RESOURCES_PATH + ASAR_BACKUP):
        try:
            os.remove(RESOURCES_PATH + ASAR)
            os.rename(RESOURCES_PATH + ASAR_BACKUP, RESOURCES_PATH + ASAR)
        except Exception as e:
            print("Couldn't remove/rename file: " + str(e))
    else:
        print("No backup found, openasar is not installed")
        exit()


# Should check if the package has been updated, as discords asar is much larger
def sanity_check():
    import os
    # Get file size of asar
    asar_size = os.path.getsize(RESOURCES_PATH + ASAR)
    # If the asar is larger than 1MB, discord has probably updated
    if asar_size > 1000000:
        print("Discord has probably updated, please clear backups and reinstall")
        print("Would you like to clear backups? (y/n)")
        answer = input().lower()
        if answer == "y":
            if os.path.isfile(RESOURCES_PATH + ASAR_BACKUP):
                os.remove(RESOURCES_PATH + ASAR_BACKUP)
                print("Backup cleared, installation will continue as normal")
            print("Backups cleared, installation will continue as normal")
        else:
            print("Backups not cleared, please clean manually")
            exit()


def main():
    import sys
    root()
    kill()
    find()
    sanity_check()
    if len(sys.argv) > 1:
        if sys.argv[1] == "uninstall":
            uninstall()
            print("Uninstalled openasar")
        else:
            print("Unknown argument")
    else:
        backup()
        download()
        print("Installed openasar")

if __name__ == "__main__":
    main()
