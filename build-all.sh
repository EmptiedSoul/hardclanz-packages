#!/bin/bash

gpg-agent --daemon

opwd=$(pwd)
logsd="$opwd/logs/"
mkdir -pv $logsd

for dir in $(ls -1)
do
	grep -qr $dir .done && continue
	echo
	echo "Making $dir"
	echo
	pushd $dir &>/dev/null
		hpkg-make clean
		{ hpkg-make build && echo $dir >> $opwd/.done; } || { echo $dir >> $opwd/.failed
		cp /var/log/hmake $logsd/$dir.failed
		}
	popd
done
