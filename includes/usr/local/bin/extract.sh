#! /usr/bin/env bash
set -e

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
	echo "Usage: import <database name> <filename>"
	exit 1
fi

DATABASE=$1
FILENAME=$2

if [[ ! -f "$FILENAME" ]]; then
	echo "Error: Database dump was not found in the project folder"
	exit 1
fi

if [[ "$FILENAME" == *.sql ]]; then
    mysql "$DATABASE" < /local/"$FILENAME"
elif [[ "$FILENAME" == *.sql.gz ]]; then
	zcat /local/"$FILENAME" | mysql "$DATABASE"
elif [[ "$FILENAME" == *.sql.zst ]]; then
	zstd -d -c /local/"$FILENAME" | mysql "$DATABASE"
elif [[ "$FILENAME" == *.zip ]]; then
	unzip -p "$FILENAME" | mysql "$DATABASE"
else
	echo "Unknown file format"
fi
