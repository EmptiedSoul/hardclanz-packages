#!/bin/bash

for pkg in $(ls -1d */ --hide=*.sh --hide=README --hide=TODO --hide=Buildfile-example --hide=\!* | sed 's;/;;')
do
	pushd $pkg &>/dev/null
	. ./Buildfile &>/dev/null
	for dependency in "${DEPENDS[@]}"
	do
		ls -1d ../*/ | sed 's;/;;' | grep -q "$dependency" || echo "$pkg: missing $dependency"
	done
	popd &>/dev/null
done
