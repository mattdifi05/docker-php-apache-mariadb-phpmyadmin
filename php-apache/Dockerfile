FROM php:8.5-apache

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# Apache modules (SSL + reverse proxy)
RUN a2enmod rewrite ssl headers proxy proxy_http

# OS deps (ImageMagick CLI + dev libs for imagick, + tools)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates curl git unzip zip \
    imagemagick libmagickwand-dev libmagickcore-dev \
 && rm -rf /var/lib/apt/lists/*

# Install "install-php-extensions" (pinned to latest release URL but executed explicitly)
ADD --chmod=755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    /usr/local/bin/install-php-extensions

# Sanity check: script must be executable and callable
RUN command -v install-php-extensions \
 && install-php-extensions --version || true

# Install bundled/common extensions + MySQL + others
# (If any extension fails, build FAILS and you see the exact reason)
RUN install-php-extensions \
  bcmath \
  bz2 \
  calendar \
  dba \
  enchant \
  exif \
  ffi \
  ftp \
  gd \
  gettext \
  gmp \
  intl \
  ldap \
  mysqli \
  opcache \
  pcntl \
  pdo_mysql \
  shmop \
  snmp \
  soap \
  sockets \
  sodium \
  sysvmsg \
  sysvsem \
  sysvshm \
  tidy \
  xsl \
  zip

# imagick (PHP extension) - requires ImageMagick headers (already installed above)
RUN install-php-extensions imagick

# Composer (latest)
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN composer --version

# Enable SSL site, disable plain HTTP site (redirect handled in :80 vhost)
RUN a2ensite default-ssl && a2dissite 000-default

WORKDIR /var/www/html
