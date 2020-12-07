FROM ubuntu:focal

LABEL MAINTAINER felix@codemonauts.com

ENV DEBIAN_FRONTEND noninteractive

ENV NODE_VERSION "node_12.x"
ENV DISTRO "focal"
ENV COMPOSER_VERSION "2.0.8"

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
    gnupg-agent \
    imagemagick \
    iwatch \
    libtool \
    locales \
    mysql-client \
    nginx \
    php-imagick \
    php-soap \
    php-xml \
    php7.0-bcmath php7.0-cli php7.0-curl php7.0-fpm php7.0-gd php7.0-imagick php7.0-intl php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-xml php7.0-zip php7.0-imagick php7.0-soap \
    php7.2-bcmath php7.2-cli php7.2-curl php7.2-fpm php7.2-gd php7.2-intl php7.2-mbstring php7.2-mysql php7.2-xml php7.2-zip php7.2-soap \
    php7.4-bcmath php7.4-cli php7.4-curl php7.4-fpm php7.4-gd php7.4-intl php7.4-mbstring php7.4-mysql php7.4-xml php7.4-zip php7.4-soap \
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
    gem update --system

# Setup
WORKDIR /local

# Get Composer
RUN wget https://getcomposer.org/download/$COMPOSER_VERSION/composer.phar -O /usr/local/bin/composer

# Install node including global packages
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - &&\
    echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list &&\
    apt-get update &&\
    apt-get install -y nodejs &&\
    npm install --global npm gulp-cli pug-cli yarn

COPY includes /

CMD ["run.sh"]
