#!/bin/bash

# Trying various verchecks on package

for vercheck in $(ls \!verchecks -1)
do
	echo "VERCHECK: $vercheck"
	./\!verchecks/$vercheck $1 && { echo "Working: $vercheck"; exit 0; } || \
		echo "$vercheck: not working, trying next"
done
