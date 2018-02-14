#!/bin/bash

composer self-update

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if [ -e /local/composer.json ]; then
	cd /local
	composer install --ignore-platform-reqs
fi

if [ -e /local/.env.local ]; then
	echo "Copying .env.local to .env"
	cp /local/.env.local /local/.env
fi

if [ -d /local/src ]; then
	echo "Running gulp from /src"
	cd /local/src
elif [ -d /local/resources ]; then
	echo "Running gulp from /resources"
	cd /local/resources
else
	echo "No valid directory found!"
	exit
fi

npm install
gulp
