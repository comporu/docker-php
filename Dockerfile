FROM php:7.2-fpm

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get update && apt-get install -y \
    openssl \
    git \
    unzip \
    libicu-dev \
    libpng-dev \
    gnupg

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql intl gd bcmath zip opcache

RUN pecl --soft install apcu  \
  && docker-php-ext-enable apcu

COPY "php.ini" "/usr/local/etc/php/conf.d/php.ini"

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -LO https://deployer.org/deployer.phar
RUN mv deployer.phar /usr/local/bin/dep
RUN chmod +x /usr/local/bin/dep

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g bower

RUN useradd -ms /bin/bash vagrant

RUN ln -s /var/www/project/app/config/docker/php/php-fpm.conf /usr/local/etc/php-fpm.d/zz-project.conf

WORKDIR /var/www/project
