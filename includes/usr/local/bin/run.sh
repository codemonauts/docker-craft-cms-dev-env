#!/bin/bash

service php"$PHPVERSION"-fpm start
rm -rf /local/craft/storage/runtime/*
/usr/sbin/nginx -c /etc/nginx/nginx-"$PHPVERSION".conf
