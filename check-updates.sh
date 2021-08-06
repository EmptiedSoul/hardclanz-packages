#!/bin/bash

. /usr/lib/hpkglib.sh

pointer "Checking versions..."

PKGS=$(ls -1 --hide=*.sh --hide=README --hide=TODO --hide=Buildfile-example | wc -l)

i=0

time for pkg in $(ls --hide=*.sh --hide=README --hide=TODO --hide=Buildfile-example -1)
do
	pointer "($i/$PKGS) Checking for updates for package $pkg"
	./last-ver.sh $pkg | awk '{print "\t"$0; }'
	(( i = i + 1 ))
done
