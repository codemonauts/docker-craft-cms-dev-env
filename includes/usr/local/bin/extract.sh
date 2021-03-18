#! /usr/bin/env bash
set -eu

DATABASE=$1
FILENAME=$2

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

