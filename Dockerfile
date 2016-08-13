FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -uy upgrade
RUN apt-get -y install nginx php7.0-fpm php7.0-intl php7.0-cli php7.0-mysql php7.0-curl php7.0-gd php-imagick php7.0-mcrypt php7.0-mbstring mysql-client php-soap php-xml
RUN phpenmod mcrypt
RUN mkdir /local
RUN ln -sf /local/craft/app/etc/console/yiic /usr/local/bin/yiic
ADD includes /
CMD . /run.sh
