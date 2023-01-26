# codemonauts/craft-cms-dev-env
FROM ubuntu:jammy

LABEL MAINTAINER felix@codemonauts.com

ENV DEBIAN_FRONTEND noninteractive

ENV NODE_VERSION "node_18.x"
ENV DISTRO "jammy"
ENV COMPOSER_VERSION "2.5.1"

ENV PHPVERSION="8.1"

RUN apt update && apt install -y curl gnupg-agent && rm -rf /var/lib/apt/lists

# Install nodejs repo
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/nodejs.gpg &&\
    echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list

# Install ondrej repo
RUN curl -sSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c" | gpg --dearmor > /etc/apt/trusted.gpg.d/ondrej.gpg &&\
    echo "deb https://ppa.launchpadcontent.net/ondrej/php/ubuntu $DISTRO main" | tee /etc/apt/sources.list.d/ondrej.list

RUN apt-get update &&\
    apt-get -y --no-install-recommends install \
    autoconf \
    autogen \
    build-essential \
    git \
    imagemagick \
    iwatch \
    libtool \
    locales \
    mysql-client \
    nginx \
    php8.0-bcmath php8.0-cli php8.0-curl php8.0-fpm php8.0-gd php8.0-imagick php8.0-intl php8.0-mbstring php8.0-mysql php8.0-xml php8.0-zip php8.0-soap \
    php8.1-bcmath php8.1-cli php8.1-curl php8.1-fpm php8.1-gd php8.1-imagick php8.1-intl php8.1-mbstring php8.1-mysql php8.1-xml php8.1-zip php8.1-soap \
    python3 \
    python3-pip \
    redis-tools \
    rsync \
    sudo \
    unzip \
    vim \
    wget \
    zip \
    zstd &&\
    rm -rf /var/lib/apt/lists &&\
    locale-gen en_US.UTF-8

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

# Install node and yarn
RUN apt update && apt-get install -y nodejs &&\
    rm -rf /var/lib/apt/lists &&\
    corepack enable &&\
    corepack prepare yarn@stable

COPY includes /

# Set a shell and password-less sudo for www-data so we can use this account
RUN usermod --shell /bin/bash www-data && \
    echo "www-data         ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R www-data:www-data /var/www


CMD ["run.sh"]
