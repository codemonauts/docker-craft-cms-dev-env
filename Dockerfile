FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION "9.11"
ENV NVM_VERSION "v0.33.11" 
ENV NVM_DIR /root/.nvm

RUN apt-get update
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
    php7.0-intl \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-mysql \
    php7.0-zip \
    rsync \
    ruby \
    ruby-dev \
    vim \
    zip &&\
    locale-gen en_US.UTF-8 &&\
    gem update --system &&\
    gem install sass &&\
    gem install compass 

# mcrypt has to be activated by hand due to a bug in 16.04
# In Craft3 the mcrypt dependency is dropped
RUN phpenmod mcrypt

# Setup
RUN mkdir /local
RUN ln -sf /local/craft/app/etc/console/yiic /usr/local/bin/yiic
COPY includes /

# Install NVM
RUN mkdir $NVM_DIR && curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash

# Install composer
RUN cd /tmp &&\
    curl --silent --show-error https://getcomposer.org/installer | php &&\
    mv composer.phar /usr/local/bin/composer

# Install node including global packages
RUN . /root/.nvm/nvm.sh &&\
    nvm install $NODE_VERSION &&\
    nvm alias default $NODE_VERSION &&\
    npm install --global npm gulp-cli pug-cli bower 

CMD ./run.sh
