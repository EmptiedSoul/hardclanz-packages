#!/bin/bash

exec 2>/dev/null

LC_ALL=C readelf -a $1 | grep NEEDED | awk '{print $5}' | sed -e 's/\[//' -e 's/\]//' 
