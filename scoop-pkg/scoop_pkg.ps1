if ($args[0] -eq "freeze") {
	if (!$args[1]) {
		scoop export | Out-File -Encoding utf8 -FilePath $env:HOMEPATH\scoop_pkg.json
	} else {
		scoop export | Out-File -Encoding utf8 -FilePath $args[1]
	}
} else {
	if (!$args[0]) {
		scoop import $env:HOMEPATH\scoop_pkg.json
	} else {
		scoop import $args[0]
	}
}