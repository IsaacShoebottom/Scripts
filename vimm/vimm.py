import json
import sys
import logging

import requests
from enum import Enum
from bs4 import BeautifulSoup

# User Agent
user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0"

# Referer
referer = "https://vimm.net/"

# Download URL
download_url2 = "https://download2.vimm.net/download/"


# Enum for type of download,
class WiiType(Enum):
	wbfs = 0
	rvz = 1


def get_media_id(page_content):
	# Could be used later to be a method to extract the id from passed in json
	pass


def download(url, filetype):
	page_request = requests.get(url, headers={"User-Agent": user_agent})
	page_content = BeautifulSoup(page_request.content, 'html.parser')

	# Find div with the class "sectionTitle"
	section_titles = page_content.find_all("div", class_="sectionTitle")
	section_title = section_titles[0].text

	# TODO: use match statement
	if section_title == "Wii":
		if filetype == "wbfs":
			download_wii(page_content, WiiType.wbfs)
		elif filetype == "rvz":
			download_wii(page_content, WiiType.rvz)


def download_wii(page_content, filetype):
	# Wish there was a better way to do this, manually parsing javascript for a variable

	# Find script that contains 'var media = '
	scripts = page_content.find_all("script")

	script = str
	# Find script that contains 'var media = '
	for i in scripts:
		if "var media = " in i.text:
			script = i.string

	media = list()
	# This is the default usage, pycharm bug
	# noinspection PyArgumentList
	for lines in script.splitlines():
		if "var media = " in lines:
			media.append(lines)

	for i in range(0, len(media)):
		media[i] = media[i].replace("        var media = ", "")
		media[i] = media[i].replace(";", "")

	# Parse lines as json
	media_json = list()
	for i in media:
		media_json.append(json.loads(i))

	# Sort by version
	media_json.sort(key=lambda x: x["Version"])

	# Get ID of last entry
	last_id = media_json[-1]["ID"]

	logging.log(logging.INFO, "File ID of Download: " + str(last_id))

	# Get the title of the last entry
	filename = media_json[-1]["GoodTitle"].replace(".iso", ".7z")

	logging.log(logging.INFO, "File Name of Download: " + filename)

	# TODO: Parse json for file size

	chunk_size = 1024 * 1024 * 10  # 10 MB

	# Build request
	request = requests.Session()
	request.headers.update({"User-Agent": user_agent, "Referer": referer})
	request.params.update({"mediaId": last_id})
	if filetype == WiiType.rvz:
		request.params.update({"alt": filetype.value})
	r = request.get(download_url2, stream=True)
	with open(filename, "wb") as file:
		for chunk in r.iter_content(chunk_size=chunk_size):
			if chunk:
				file.write(chunk)


def main():
	# Comment out to disable logging
	logging.getLogger().setLevel(logging.INFO)

	if len(sys.argv) != 3:
		print("Usage: python vimm.py <url> <filetype>")
		exit(1)

	# Get arguments
	url = sys.argv[1]
	filetype = sys.argv[2]
	download(url, filetype)


if __name__ == "__main__":
	main()
