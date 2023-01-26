#!/bin/bash
#
if [ -e /local/.env.local ]; then
	echo "Copying .env.local to .env"
	cp /local/.env.local /local/.env
fi

if [ -e /local/composer.json ]; then
	cd /local
	composer install
fi

if [ -d /local/src ]; then
	cd /local/src
else
	echo "No /src directory found!"
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
cd /local/src
OLD=$(cat .lockfile-hash 2>/dev/null)
CURRENT=$(md5sum package-lock.json | cut -d" " -f1)
if [ "$OLD" == "$CURRENT" ]; then
	echo "package-lock.json didn't change since last time. Won't run npm ci!"
else
	echo "package-lock.json did change since last time. Will run npm ci!"
	npm ci
	# Save the current version of the lockfile
	echo -n $CURRENT > .lockfile-hash
fi

if [ -z $1 ]; then
	# Run 'build' if the user did not provide any argument
	npm run build
else
	npm run $1
fi
