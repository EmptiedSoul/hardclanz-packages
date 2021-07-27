#!/bin/bash
. /usr/lib/hpkglib.sh
. $1/Buildfile || error "No such package: $1"

ver_compare(){
	{ [[ -z "$newver" ]] || grep " " <<<"$newver"; } && {
		pointer "Needs vercheck correction"
		echo "$PACKAGE: $newver" > .needs_correction/$PACKAGE
		exit
	}
	[[ "$VER" == "$newver" ]] && {
		pointer "Up to date"
		exit
	}
	latest=$(echo -e "$VER\n$newver" | sort -V | tail -1)
	[[ "$VER" == "$latest" ]] && {
		pointer "Up to date"
		exit
	} || {
		pointer "Needs update"
		echo "$PACKAGE ($VER) -> $newver" > .needs_update/$PACKAGE
	}
}

pointer "Current version: $VER"

newver=$(curl -s $URL | sed 's/<[^>]*>//g' | grep -e "$PACKAGE-[0-9]" | sed -e "s/$PACKAGE-//" -e "s/\.tar.*$//" -e '/Index/d'  | sort -V | tail -1)

pointer "New version: $newver"

ver_compare
