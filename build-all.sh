#!/bin/bash

gpg-agent --daemon

for dir in $(ls -1)
do
	grep -qr $dir .done && continue
	echo
	echo "Making $dir"
	echo
	pushd $dir &>/dev/null
		hmake mrproper
		{ hmake build && echo $dir >> ../.done; } || { echo $dir >> ../.failed
		cp /var/log/hmake ../$dir.failed
		}
	popd
done
