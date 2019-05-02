#!/bin/bash

# Switch php version for the cli
update-alternatives --set php /usr/bin/php"$PHPVERSION"

service php"$PHPVERSION"-fpm start
rm -rf /local/craft/storage/runtime
/usr/sbin/nginx -c /etc/nginx/nginx-"$PHPVERSION".conf
