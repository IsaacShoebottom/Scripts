import json
import os
import subprocess


def _ffprobe(file_path):
	command = (
		'ffprobe -v quiet -print_format json -show_streams -select_streams a "'f'{file_path}"'
	)
	result = subprocess.run(command, capture_output=True)
	if result.returncode == 0:
		return json.loads(result.stdout)
	raise RuntimeError(
		f'FFProbe failed for {file_path}, output: {result.stderr}'
	)

def scan_dir():
	flac_files = []
	for root, dirs, files in os.walk(os.getcwd()):
		for file in files:
			if file.endswith(".flac"):
				flac_files.append(os.path.join(root, file))
	return flac_files

def filter_files(flac_files):
	filtered_files = []
	counter = 0
	max_counter = len(flac_files)
	for file in flac_files:
		counter += 1
		print("Progress: " + str(counter) + "/" + str(max_counter))
		metadata = _ffprobe(file)
		if int(metadata['streams'][0]['bits_per_raw_sample']) > 16 and int(
				metadata['streams'][0]['sample_rate']) > 44100:
			filtered_files.append(file)
	return filtered_files
def print_files(filtered_files):
	for file in filtered_files:
		print(file)

def get_albums(filtered_files):
	albums = []
	for file in filtered_files:
		album = os.path.dirname(file)
		if album not in albums:
			albums.append(album)
	return albums

flac_files = scan_dir()
filtered_files = filter_files(flac_files)
albums = get_albums(filtered_files)
print_files(albums)

print_files(filtered_files)
with open("filtered_files.txt", "w") as f:
	for file in filtered_files:
		f.write(file + "\n")

with open("albums.txt", "w") as f:
	for album in albums:
		f.write(album + "\n")