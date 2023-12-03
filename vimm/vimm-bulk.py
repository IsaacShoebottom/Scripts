import sys

from vimm import download


def main():
	if len(sys.argv) != 3:
		print("Usage: python vimm-bulk.py <filename> <filetype>")
		exit(1)

	with open(sys.argv[1], "r") as file:
		for line in file:
			line = line.strip()
			download(line, sys.argv[2])


if __name__ == "__main__":
	main()
