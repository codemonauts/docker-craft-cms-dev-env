#!/bin/bash
service php7.0-fpm start
rm -rf /local/craft/storage/runtime/*
/usr/sbin/nginx -c /etc/nginx/nginx.conf
