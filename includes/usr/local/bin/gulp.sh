#!/bin/bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if [ -e /local/composer.json ]; then
	cd /local
	composer install
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

if [ -d /local/scripts ]; then
	( cd /local
	for SCRIPT in `find scripts/ -name "*.sh"`; do
		echo "Executing  '$SCRIPT' ..."
		/bin/bash -eu $SCRIPT
	done )
fi

# Check if we really need to run 'npm install'
OLD=$(cat .lockfile-hash 2>/dev/null)
CURRENT=$(md5sum package-lock.json | cut -d" " -f1)
if [ "$OLD" == "$CURRENT" ]; then
	echo "package-lock.json didn't change since last time. Won't run npm install!"
else
	echo "package-lock.json did change since last time. Will run npm install!"
	npm ci
	# Save the current version of the lockfile
	echo -n $CURRENT > .lockfile-hash
fi

if [ -z $1 ]; then
	# Use the default action if the user did not provide one
	gulp
else
	gulp $1
fi
