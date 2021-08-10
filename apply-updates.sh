#!/bin/bash

for pkg in $(ls -1 .needs_update)
do
	echo
	cat .needs_update/$pkg
	read -p "(Y)es, (N)o, or enter your version  " ANSW
	case $ANSW in
		y|Y)
			VERSION=$(cat .needs_update/$pkg | cut -d' ' -f4)
			sed -i "s/VER=.*/VER=\"$VERSION\"/" $pkg/Buildfile
			echo "Changes written"
		;;
		N|n)
			echo "No changes"
		;;
		*)
			VERSION="$ANSW"
			sed -i "s/VER=.*/VER=\"$VERSION\"/" $pkg/Buildfile
			echo "Written changes ($VERSION)"
	esac
done
