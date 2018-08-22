FROM ubuntu:16.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get -y update

RUN apt-get -y install software-properties-common

RUN apt-add-repository -y ppa:ondrej/php
RUN apt update

RUN apt-get update && apt-get install -y –allow-unauthenticated --no-install-recommends\
      apache2 \
      php5.6 \
      php5.6-bcmath \
      php5.6-bz2 \
      php5.6-cli \
      php5.6-common \
      php5.6-curl \
      php5.6-gd \
      php5.6-interbase \
      php5.6-json \
      php5.6-mbstring \
      php5.6-mcrypt \
      php5.6-pgsql \
      php5.6-soap \
      php5.6-sqlite3 \
      php5.6-xml \
      php5.6-xmlrpc \
      php5.6-zip \
      php5.6-fpm \
      ca-certificates \
      curl

RUN a2enmod proxy_fcgi setenvif rewrite

RUN a2enconf php5.6-fpm

RUN touch /var/log/php_errors.log
RUN chown www-data.www-data /var/log/php_errors.log

COPY apache_default /etc/apache2/sites-available/default
RUN a2enmod rewrite

RUN curl -SL https://github.com/myersBR/e-cidade/releases/download/e-cidade2018/e-cidade-2018-2-linux-completo.tar.bz2 | tar -xjf -C /var/www/

RUN mkdir /var/www/tmp \
    && chown -R www-data.www-data /var/www/tmp \
    && chmod -R 777 /var/www/tmp \
    && mkdir /var/www/log \
    && chown -R www-data.www-data /var/www/log \
    && chown root.www-data /var/lib/php5 \
    && chmod g+r /var/lib/php5 \
    && useradd -d /home/dbseller -g www-data -k /etc/skel -m -s /bin/bash dbseller \
    && echo 'dbseller:dbseller' | chpasswd \
    && chown -R dbseller.www-data /var/www/e-cidade \
    && chmod -R 775 /var/www/e-cidade \
    && chmod -R 777 /var/www/e-cidade/tmp

EXPOSE 80

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

