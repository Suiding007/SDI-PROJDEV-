mysql -u root -pWelkom123 <<EOF
#DROP DATABASE moodle;
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
create user 'moodledude'@'localhost' IDENTIFIED BY 'passwordformoodledude';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, CREATE TEMPORARY TABLES, DROP, INDEX, ALTER ON moodle.* TO 'moodledude'@'localhost';
FLUSH PRIVILEGES;
EOF

