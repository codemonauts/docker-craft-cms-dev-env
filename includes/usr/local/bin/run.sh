#!/bin/bash

if [ ! -z "$CUSTOM_UID" ] && [ ! -z "$CUSTOM_GID" ]; then
    usermod -u $CUSTOM_UID www-data && groupmod -g $CUSTOM_GID www-data
fi

OWNER=`stat -c '%U' /local/config`
if [ $OWNER != "www-data" ]; then
    echo "Need to fix permissions of your project..."
    chown -R www-data:www-data /local/
fi

# Switch php version for the cli
sudo update-alternatives --set php /usr/bin/php"$PHPVERSION"

sudo service php"$PHPVERSION"-fpm start
rm -rf /local/craft/storage/runtime
sudo /usr/sbin/nginx -c /etc/nginx/nginx-"$PHPVERSION".conf
