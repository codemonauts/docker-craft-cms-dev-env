#!/bin/bash
echo "Waiting for changes..."
iwatch -c "/usr/local/bin/process.sh %f" -r -e modify /local/resources
