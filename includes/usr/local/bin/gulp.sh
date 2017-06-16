#!/bin/bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if [ -d /local/src ]; then
	cd /local/src
elif [ -d /local/resources ]; then
	cd /local/resources
else
	echo "No valid directory found!"
fi

npm install
gulp
