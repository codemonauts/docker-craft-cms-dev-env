FROM ubuntu:bionic

LABEL MAINTAINER felix@codemonauts.com

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION "9.11"
ENV NVM_VERSION "v0.33.11" 
ENV NVM_DIR /root/.nvm

RUN apt-get update &&\
    apt-get install -y --no-install-recommends software-properties-common &&\
    add-apt-repository ppa:ondrej/php &&\
    apt-get update

RUN apt-get -y --no-install-recommends install \
    autoconf \
    autogen \
    build-essential \
    curl \
    git \
    iwatch \
    libtool \
    locales \
    mysql-client \
    nginx \
    php-imagick \
    php-soap \
    php-xml \
    php7.0-bcmath \
    php7.0-cli \
    php7.0-curl \
    php7.0-fpm \
    php7.0-gd \
    php7.0-imagick \
    php7.0-intl \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-mysql \
    php7.0-xml \
    php7.0-zip \
    php7.0-imagick \
    php7.0-soap \
    php7.2-bcmath \
    php7.2-cli \
    php7.2-curl \
    php7.2-fpm \
    php7.2-gd \
    php7.2-intl \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-xml \
    php7.2-zip \
    php7.2-soap \
    redis-tools \
    rsync \
    ruby \
    ruby-dev \
    unzip \
    vim \
    wget \
    zip \
    zstd &&\
    locale-gen en_US.UTF-8 &&\
    gem update --system &&\
    gem install sass &&\
    gem install compass 

# Setup
WORKDIR /local
RUN ln -sf /local/craft/app/etc/console/yiic /usr/local/bin/yiic
COPY includes /

# Install NVM
RUN mkdir $NVM_DIR && curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash

# Download GeoIP2 database
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz -O /tmp/geolite2.gz && \
    gzip -d /tmp/geolite2.gz && \
    mv /tmp/geolite2 /opt/GeoLite2-Country.mmdb

# Install composer
RUN cd /tmp &&\
    curl --silent --show-error https://getcomposer.org/installer | php &&\
    mv composer.phar /usr/local/bin/composer

# Install yarn
RUN apt install -y gpg-agent && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt update &&\
    apt install -y yarn

# Install node including global packages
RUN . /root/.nvm/nvm.sh &&\
    nvm install $NODE_VERSION &&\
    nvm alias default $NODE_VERSION &&\
    npm install --global npm gulp-cli pug-cli bower yarn

CMD ["run.sh"]
