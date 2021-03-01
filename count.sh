#!/bin/bash

for dir in $(ls -1 --hide=README --hide=repo --hide=TODO --hide=Buildfile-example --hide=count.sh)
do
	pushd $dir &>/dev/null
	find . -name "*.hard"|grep -q "." || echo "missing $dir"

	popd &>/dev/null
done

