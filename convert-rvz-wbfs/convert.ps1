# Converts all rvz files in the current directory to wbfs files
# Warning: Removes the RVZ files after conversion if the -r argument is passed
# Requires: dolphintool, wit

$files = Get-ChildItem -Filter *.rvz .
foreach ($file in $files) {
	$name = $file.BaseName
	$rvz = $name + ".rvz"
	$iso = $name + ".iso"
	$wbfs = $name + ".wbfs"
	dolphintool convert -i $rvz -o $iso -f iso
	if ($args[0] -eq "-r") {
		Remove-Item $rvz
	}
	wit copy -B $iso $wbfs
	Remove-Item $iso
}
