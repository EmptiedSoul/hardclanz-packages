#!/bin/bash
. /usr/lib/hpkglib.sh
# Temporarily

PKGFILE="${2##*/}"
_PKG="${PKGFILE//.hard/}"
PKG="${_PKG//_*/}"

. /var/hpkg/packages/$PKG
old_version="$VERSION"
new_version=$(hpkg-info -p $2 -k "VERSION")

if [[ "$old_version" == "$new_version" ]]; then
	pointer "Old: $old_version. New: $new_version (same)"
	pointer "Reinstalling package $PKG"
	hpkg $1 $2
elif [[ -z "$old_version" ]]; then
	pointer "Installing package $PKG (first time)"
	hpkg $1 $2
else
	pointer "Old: $old_version. New: $new_version (differ)"
	pointer "Updating package $PKG ($new_version over $old_version)"
	hpkg $1 $2
	diff -u /var/hpkg/installed-files/$PKG-{$old_version,$new_version}.list | grep '^-' | sed -e 's/^-\.//' -e '/^---/d' | xargs -i% rm -fd %
	true
fi
