#!/bin/bash

for pkg in $(ls -1d */ --hide=\!verchecks --hide=logs | sed 's/\///')
do
	AUTO_ADJUST=y ./depcmp.sh $pkg
done
