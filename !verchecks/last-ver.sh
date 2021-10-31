#!/bin/bash
. /usr/lib/hpkglib.sh
. $1/Buildfile || error "No such package: $1" 2

is_true $GITHUB_CHECK && exec ./\!verchecks/last-ver.gh.sh $1

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
	latest=$(echo -e "$VER $newver" |tr ' ' '\n'| sort -V | tail -1)
	[[ "$VER" == "$latest" ]] && {
		pointer "Up to date"
		exit
	} || {
		pointer "Needs update"
		echo "$PACKAGE ($VER) -> $newver" > .needs_update/$PACKAGE
	}
}

pointer "Current version: $VER"

newver=$(curl -Ls $URL | html2text |grep "$PACKAGE-" | sed -e "s/^.*$PACKAGE-//" -e 's/\.tar.*$//' -e 's/\.zip.*$//' -e 's/\.cpio.*$//' -e 's/^[^0-9]*//' | awk '{print $1}'|sort | uniq | sort -V | tail -1)

pointer "New version: $newver"

ver_compare
