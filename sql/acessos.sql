ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
CREATE USER 'root'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'root';
CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;

