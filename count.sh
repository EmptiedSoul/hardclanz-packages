#!/bin/bash

. /etc/hpkg/make.conf

for dir in $(ls -1 --hide=README --hide=repo --hide=TODO --hide=Buildfile-example --hide=*.sh --hide=\!*)
do
	[[ -e "$DISTDIR/$dir/$dir.hard" ]] || echo "Missing $dir"
done

