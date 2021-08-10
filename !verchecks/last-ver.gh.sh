#!/bin/bash
. /usr/lib/hpkglib.sh
. $1/Buildfile || error "No such package: $1" 2


ver_compare(){
	{ [[ -z "$newver" ]] || grep " " <<<"$newver"; } && {
		pointer "Needs vercheck correction"
		echo "$PACKAGE: $newver" > .needs_correction/$PACKAGE
		exit 1
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

owner="$(echo $URL | cut -d/ -f4)"
repo="$(echo $URL | cut -d/ -f5)"

newver=$(curl -sH "Accept: application/vnd.github.v3+json" https://api.github.com/repos/$owner/$repo/tags | grep name -w | sed -e "s/^.*\"$PACKAGE//" -e 's/\",$//' -e 's/^[^0-9]*//' | sort -V | tail -1)

pointer "New version: $newver"

ver_compare
