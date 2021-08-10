#!/bin/bash

. /usr/lib/hpkglib.sh
. /etc/hpkg/make.conf

UPDATE_LIST=" "
based="$(pwd)"

pointer "Searching packages requiring update..."

for pkg in $(ls -1d */ | sed -e 's/\///' -e '/logs/d' -e '/!verchecks/d')
do
	[[ $pkg/Buildfile -ot $DISTDIR/$pkg/METADATA ]] || UPDATE_LIST+="$pkg "
done

pointer "Packages requiring update: $UPDATE_LIST"
pointer "Building rebuild graph..."

TO_REBUILD="$(make -s -f .work/Makefile $UPDATE_LIST --no-print-directory 2>/dev/null | tac)"

for pkg in $TO_REBUILD
do
	[[ "$UPDATE_LIST" == *"$pkg"* ]] && \
	echo -e "[\e[1;32mupdate\e[0m  ] $pkg" || \
	echo -e "[\e[1;33mrebuild\e[0m ] $pkg"
done

is_true $REALLY_BUILD && {

for pkg in $TO_REBUILD
do
	echo
	pointer "Building $pkg..."
	cd $pkg &>/dev/null
		hpkg-make clean
		hpkg-make build && {
			echo $pkg >> ../.done
			pointer "Installing $pkg..."
			hpkg -fnp $DISTDIR/$pkg/$pkg.hard
		} || {
			echo $pkg >> ../.failed
			cp -v $DISTDIR/hpkg-make.log ../logs/$pkg.log
			echo 
			echo "$pkg failed to build, log: ./logs/$pkg.log"
			echo "Resolve failure and build again."
			echo "Bailing out"
			cd ..
			exit 101
		}
	cd .. &>/dev/null
done

}
