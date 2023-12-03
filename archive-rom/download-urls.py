import os
import sys
import requests
import humanize
from urllib.parse import unquote


def parse_file(file_name):
	urls = []
	with open(file_name, 'r') as f:
		for line in f:
			urls.append(unquote(line.strip()))
	return urls


def get_filename(url):
	return url.split('/')[-1]


def print_progress(amount_written, file_size, sizes):
	for size in sizes:
		if amount_written >= size:
			sizes.remove(size)
			percentage = (10 - len(sizes)) * 10
			print(f"{percentage}% Written {humanize.naturalsize(amount_written)} / {humanize.naturalsize(file_size)}")
	return sizes


def download_url(url, filename):
	# Constant
	temp_file = filename + ".tmp"
	chunk_size = 1024 * 1024 * 8  # 8MB
	# Request
	r = requests.get(url, stream=True)
	# More constants
	file_size = int(r.headers.get('Content-Length'))
	sizes = [file_size * (i / 100) for i in range(0, 101, 10)]  # 101, because range is exclusive lmao
	# Statistics
	amount_written = 0
	with open(temp_file, 'wb') as f:
		for chunk in r.iter_content(chunk_size=chunk_size):
			if chunk:
				f.write(chunk)
				amount_written += chunk_size
				sizes = print_progress(amount_written, file_size, sizes)
	# Rename
	os.rename(temp_file, filename)


def main():
	file = sys.argv[1]
	urls = parse_file(file)
	for url in urls:
		filename = get_filename(url)
		print(f"Downloading {filename}")
		download_url(url, filename)


if __name__ == '__main__':
	main()
