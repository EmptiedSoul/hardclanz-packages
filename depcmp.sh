#!/bin/bash

. /usr/lib/hpkglib.sh
. /etc/hpkg/make.conf

[[ -z "$1" ]] && exit 1

package="$1"

pointer "Package $package depends on following shared libraries:"
cat .depends/$package

pointer "These packages provide such libraries:"
nDEPS=" "

for lib in $(cat .depends/$package)
do
	nDEPS+="$(grep $lib -R .provides | sed -e 's|^.*/||' -e 's/:.*$//' -e "/$package$/d") "
done

nDEPS=$(echo $nDEPS | tr ' ' '\n'  | sort | uniq | tr '\n' ' ')
echo $nDEPS

pointer "Current DEPENDS:"
. $1/Buildfile
echo "DEPENDS=(${DEPENDS[@]})"

pointer "Suggested DEPENDS:"
echo "DEPENDS=($nDEPS)"

TO_ADJ=" "

for dep in $(echo $nDEPS | tr ' ' '\n')
do
	 if  [[ "${DEPENDS[@]}" == *" $dep "* ]] || [[ "${DEPENDS[@]}" == "$dep "* ]] || [[ "${DEPENDS[@]}" == *" $dep" ]] || [[ "${DEPENDS[@]}" == "$dep" ]]; then
	 	true 
	 else
		warn "Mismatch: there is no \"$dep\" package in current DEPENDS, but its necessary"
		BAD=y
		TO_ADJ+="$dep "
	 fi
done

[[ "$TO_ADJ" == " " ]] || {
	is_true $AUTO_ADJUST && {
		echo "Adjusting package dependencies"
		newdeps=$(echo "${DEPENDS[@]} $TO_ADJ" | sort | uniq)
		sed -i "s/DEPENDS.*$/DEPENDS=( $newdeps )/" $package/Buildfile
	}
}
is_true $BAD && exit 111
