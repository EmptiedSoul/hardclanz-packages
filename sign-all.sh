#!/bin/bash

. /etc/hpkg/make.conf

for pkg in $(ls -1)
do
	echo "Sign: $pkg"
	pushd $DISTDIR/$pkg
		. ./METADATA || { popd && continue; }
		gpg -s $PKGNAME.hard
		mv  $PKGNAME.hard.gpg ${PKGNAME}_${VERSION}.hard
		unset PKGNAME VERSION
	popd
done
