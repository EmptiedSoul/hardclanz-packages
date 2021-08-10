#!/bin/bash

. /usr/lib/hpkglib.sh
. /etc/hpkg/make.conf

pointer "Scanning packages for provided shared libraries..."

NPKGS=$(ls -1 --hide=*.sh --hide=README --hide=TODO --hide=Buildfile-example --hide=\!* | wc -l)
CURPKG=0

for package in $(ls -1 --hide=*.sh --hide=README --hide=TODO --hide=Buildfile-example --hide=\!*  ) 
do
	(( CURPKG = CURPKG + 1 ))
	pointer "($CURPKG/$NPKGS) Scaninng package $package..."
	. $package/Buildfile
	[[ -d $DISTDIR/$package/root ]] || continue
	find $DISTDIR/$package/root/ -name "*.so.*" | sed 's|^.*/||' | sort | uniq > .provides/$package 2>/dev/null
done
