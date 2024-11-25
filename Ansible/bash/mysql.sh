mysql -u root -pWelkom123 <<EOF
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
create user 'pcgebruiker'@'localhost' IDENTIFIED BY 'Welkom123';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, CREATE TEMPORARY TABLES, DROP, INDEX, ALTER ON moodle.* TO 'pcgebruiker'@'localhost';
FLUSH PRIVILEGES;
EOF

