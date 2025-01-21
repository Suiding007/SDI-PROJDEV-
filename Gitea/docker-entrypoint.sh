#!/bin/bash

# Wait for MySQL to be ready
until mysql -h db -u moodleuser -ppassword moodle -e "SELECT 1" > /dev/null 2>&1; do
  echo "Waiting for MySQL..."
  sleep 2
done

# Check if the Moodle config.php already exists (i.e., if Moodle has been installed)
if [ ! -f /var/www/moodle/config.php ]; then
  echo "Config file not found. Running Moodle installation."

  # Dynamically create config.php
  echo "<?php
unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();

\$CFG->dbtype    = 'mysqli';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = 'db'; // Service name of the MySQL container in docker-compose.yaml
\$CFG->dbname    = 'moodle';
\$CFG->dbuser    = 'moodleuser';
\$CFG->dbpass    = 'password';
\$CFG->prefix    = 'mdl_';
\$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => 3306,
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_unicode_ci',
);

\$CFG->wwwroot   = 'http://localhost:8080';
\$CFG->dataroot  = '/var/www/moodledata';
\$CFG->admin     = 'admin';

\$CFG->directorypermissions = 02777;

require_once(__DIR__ . '/lib/setup.php');
" > /var/www/moodle/config.php


  # Run Moodle install script with the pre-configured database and user details
  php /var/www/moodle/install.php --agree-license --wwwroot=http://localhost:8080 --dataroot=/var/www/moodledata --dbtype=mysqli --dbname=moodle --dbhost=db --dbuser=moodleuser --dbpass=password --adminuser=admin --adminpass=adminpassword --adminemail=admin@example.com
else
  echo "Moodle is already installed, skipping installation."
fi

# Start Apache in the foreground
exec apachectl -D FOREGROUND
