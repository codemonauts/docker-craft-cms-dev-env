#!/bin/bash

if [ ! -z "$CUSTOM_UID" ] && [ ! -z "$CUSTOM_GID" ]; then
    usermod -u $CUSTOM_UID www-data && groupmod -g $CUSTOM_GID www-data
fi

chown -R www-data:www-data /local/

# Switch php version for the cli
sudo update-alternatives --set php /usr/bin/php"$PHPVERSION"

sudo service php"$PHPVERSION"-fpm start
rm -rf /local/craft/storage/runtime
sudo /usr/sbin/nginx -c /etc/nginx/nginx-"$PHPVERSION".conf
