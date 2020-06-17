#!/bin/bash

if [ ! -z "$CUSTOM_UID" ] && [ ! -z "$CUSTOM_GID" ]; then
    usermod -u $CUSTOM_UID www-data && groupmod -g $CUSTOM_GID www-data
fi

# Switch php version for the cli
update-alternatives --set php /usr/bin/php"$PHPVERSION"

service php"$PHPVERSION"-fpm start
rm -rf /local/craft/storage/runtime
/usr/sbin/nginx -c /etc/nginx/nginx-"$PHPVERSION".conf
