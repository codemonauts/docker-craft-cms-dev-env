#! /bin/bash

echo "Starting craft container"

if [ ! -z "$CUSTOM_UID" ] && [ ! -z "$CUSTOM_GID" ]; then
    echo "Adding custom user to www-data group"
    usermod -u $CUSTOM_UID www-data && groupmod -g $CUSTOM_GID www-data
fi

echo "Checking if we need to chown the docroot"
OWNER=`stat -c '%U' /local/config`
if [ $OWNER != "www-data" ]; then
    echo "Need to fix permissions of your project..."
    chown -R www-data:www-data /local/
fi

echo "Switch php version for the cli"
sudo update-alternatives --set php /usr/bin/php"$PHPVERSION"

echo "Starting php-fpm$PHPVERSION"
sudo service php"$PHPVERSION"-fpm start

echo "Clearing /storage/runtime/"
rm -rf /local/craft/storage/runtime

echo "Starting nginx"
sudo /usr/sbin/nginx -c /etc/nginx/nginx-"$PHPVERSION".conf
