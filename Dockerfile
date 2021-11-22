# codemonauts/craft-cms-dev-env
FROM ubuntu:focal

LABEL MAINTAINER felix@codemonauts.com

ENV DEBIAN_FRONTEND noninteractive

ENV NODE_VERSION "node_12.x"
ENV DISTRO "focal"
ENV COMPOSER_VERSION "2.0.11"

ENV PHPVERSION="7.4"

RUN apt-get update &&\
    apt-get upgrade -y &&\
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
    php7.0-bcmath php7.0-cli php7.0-curl php7.0-fpm php7.0-gd php7.0-imagick php7.0-intl php7.0-mbstring php7.0-mysql php7.0-xml php7.0-zip php7.0-soap php7.0-mcrypt  \
    php7.2-bcmath php7.2-cli php7.2-curl php7.2-fpm php7.2-gd php7.2-imagick php7.2-intl php7.2-mbstring php7.2-mysql php7.2-xml php7.2-zip php7.2-soap \
    php7.4-bcmath php7.4-cli php7.4-curl php7.4-fpm php7.4-gd php7.4-imagick php7.4-intl php7.4-mbstring php7.4-mysql php7.4-xml php7.4-zip php7.4-soap \
    php8.0-bcmath php8.0-cli php8.0-curl php8.0-fpm php8.0-gd php8.0-imagick php8.0-intl php8.0-mbstring php8.0-mysql php8.0-xml php8.0-zip php8.0-soap \
    python3 \
    python3-pip \
    redis-tools \
    rsync \
    ruby \
    ruby-dev \
    sudo \
    unzip \
    vim \
    wget \
    zip \
    zstd &&\
    locale-gen en_US.UTF-8 &&\
    gem update --system

# Install sqlstrip
RUN  cd /tmp &&\
    wget https://github.com/codemonauts/sqlstrip/releases/download/v1.0/sqlstrip_1.0_Linux_x86_64.tar.gz -O sqlstrip.tar.gz &&\
    tar xvf sqlstrip.tar.gz &&\
    mv sqlstrip /usr/local/bin

# Setup
WORKDIR /local

# Get Composer
RUN wget https://getcomposer.org/download/$COMPOSER_VERSION/composer.phar -O /usr/local/bin/composer &&\
    chmod +x /usr/local/bin/composer

# Install node including global packages
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - &&\
    echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list &&\
    apt-get update &&\
    apt-get install -y nodejs &&\
    npm install --global gulp-cli pug-cli yarn

COPY includes /

# Set a shell and password-less sudo for www-data so we can use this account
RUN usermod --shell /bin/bash www-data && \
    echo "www-data         ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R www-data:www-data /var/www


CMD ["run.sh"]
