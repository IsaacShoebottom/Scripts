# Recursivly scan from the currenct directory and add every flac file to an array

import os

import json
import subprocess
import ffmpeg

# TODO: Rewrite using ffmpeg-python probe functionality
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


# Filter the array of flac files to only include files with a bit depth higher than 16, and a sample rate higher than 44.1kHz
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


# Print the filtered files to the console

def print_files(filtered_files):
	for file in filtered_files:
		print(file)


def get_relative_path(file):
	return os.path.relpath(file, os.getcwd())

def get_root_path(file):
	return os.path.dirname(file)


def convert_files(filtered_files):
	for file in filtered_files:
		output = ".\\Output\\" + get_relative_path(file)

		output_no_basename = os.path.dirname(output)
		os.makedirs(output_no_basename, exist_ok=True)

		stream = ffmpeg.input(file)
		stream = ffmpeg.output(stream, output, sample_fmt="s16", ar='44100')
		stream = ffmpeg.overwrite_output(stream)
		ffmpeg.run(stream)

# Run the functions

flac_files = scan_dir()
print_files(flac_files)
filtered_files = filter_files(flac_files)
print_files(filtered_files)
convert_files(filtered_files)

