FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION 6.11.0
ENV NVM_DIR /root/.nvm
RUN apt-get update && apt-get -uy upgrade
RUN apt-get -y install locales ruby-dev git vim rsync ruby iwatch nginx php7.0-fpm php7.0-zip php7.0-intl php7.0-cli php7.0-mysql php7.0-curl php7.0-gd php-imagick php7.0-mcrypt php7.0-mbstring mysql-client php-soap php-xml curl build-essential
RUN phpenmod mcrypt
RUN locale-gen en_US.UTF-8
RUN mkdir /local
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
RUN . ~/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && npm install --global gulp-cli pug-cli bower postcss-cli autoprefixer uglify-js
RUN ln -sf /local/craft/app/etc/console/yiic /usr/local/bin/yiic
RUN gem update --system
RUN gem install sass
RUN gem install compass
ADD includes /
CMD . /run.sh
