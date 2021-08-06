#!/bin/bash

. /etc/hpkg/make.conf

gpg-agent --daemon

opwd=$(pwd)
logsd="$opwd/logs/"
mkdir -pv $logsd

trap exit INT

for dir in $(ls -1 --hide=*.sh)
do
	grep -qr "^$dir$" .done && continue
	echo
	echo "Making $dir"
	echo
	pushd $dir &>/dev/null
		hpkg-make clean
		{ hpkg-make build && echo $dir >> $opwd/.done; } || { echo $dir >> $opwd/.failed
		cp $DISTDIR/hpkg-make.log $logsd/$dir.failed
		}
	popd &>/dev/null
done
