#1/bin/bash

echo ".PHONY: $(ls -1d */ | sed 's/\///' | tr '\n' ' '))"

for pkg in $(ls -1d */ | sed 's/\///')
do
	rdeps="$(grep DEPENDS -R . | grep " $pkg "| sed -e 's/\.\///' -e 's/\/.*$//' -e '/^.*\.sh/d'| tr '\n' ' ')"
	echo -e "$pkg: $rdeps"
	echo -e "\t$1"
done
