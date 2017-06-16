#!/bin/bash
if [ -d /local/src ]; then
	cd /local/src
elif [ -d /local/resources ]; then
	cd /local/resources
else
	echo "No valid directory found!"
fi

npm install
gulp