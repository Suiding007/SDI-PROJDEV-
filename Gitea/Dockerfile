FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update

RUN apt-get update && apt-get install -y \
    apache2 \
    mysql-client \
    php8.1 \
    php8.1-cli \
    php8.1-mysql \
    php8.1-xmlrpc \
    php8.1-intl \
    php8.1-curl \
    php8.1-zip \
    php8.1-gd \
    php8.1-xml \
    php8.1-mbstring \
    php8.1-soap \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite ssl headers



RUN git clone --branch MOODLE_401_STABLE git://git.moodle.org/moodle.git 
RUN cp -a /moodle /var/www/moodle 

RUN mkdir /var/www/moodledata && \
    chown -R www-data /var/www/moodledata && \
    chmod -R 777 /var/www/moodledata && \
    chmod -R 777 /var/www/moodle

# Set Moodle as the DocumentRoot for Apache
RUN sed -i 's|/var/www/html|/var/www/moodle|g' /etc/apache2/sites-available/000-default.conf \
    && sed -i 's|/var/www/html|/var/www/moodle|g' /etc/apache2/apache2.conf

RUN sed -i 's/^\s*;\s*max_input_vars\s*=.*/max_input_vars = 5000/' /etc/php/8.1/apache2/php.ini \
    && sed -i 's/^\s*;\s*max_input_vars\s*=.*/max_input_vars = 5000/' /etc/php/8.1/cli/php.ini

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
