FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    apache2 \
    mysql-client \
    mysql-server \
    libapache2-mod-php \
    php7.4 \
    php7.4-pspell \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mysql \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-ldap \
    php7.4-zip \
    php7.4-soap \
    php7.4-mbstring \
    git && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get clean


COPY init_mysql.sql /docker-entrypoint-initdb.d/init_mysql.sql

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
RUN git clone -b MOODLE_400_STABLE --depth=1 git://git.moodle.org/moodle.git /opt/moodle

RUN cp -R /opt/moodle /var/www/html/moodle

RUN mkdir /var/moodledata && \
    chown -R www-data:www-data /var/moodledata && \
    chmod -R 777 /var/moodledata && \
    chmod -R 777 /var/www

COPY config.php /var/www/html/moodle/config.php

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN service apache2 restart
# RUN php /var/www/html/moodle/admin/cli/install_database.php \
#     --adminuser=pcgebruiker \
#     --adminpass=Welkom123 \
#     --adminemail=testmail@test.nl \ 
#     --agree-license

CMD bash -c "service mysql start && mysql < /docker-entrypoint-initdb.d/init_mysql.sql && exec /usr/sbin/apachectl -D FOREGROUND"
# ###############################################3
