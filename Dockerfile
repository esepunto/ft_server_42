# See best practices in Dockerfile: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run 

# Install Debian
FROM	debian:buster

# Who are me?
LABEL	maintainer = "ssacrist@student.42madrid.com"

# Update and install. 
RUN	apt-get update && apt install -y \
	nginx \
	php php-mysql \
	mariadb-server

# Segurizar servicio mariadb ¿? https://www.atareao.es/tutorial/raspberry-pi-primeros-pasos/infraestructura-lemp-con-nginx-en-raspberry/
#RUN	mysql_secure_installation  

##	php7.0 php7.0-fpm php7.0-mysql

# Replace html from Apache
COPY srcs/nginx/index.html var/www/html/index.html

# Start autoindex on (put "no" to off)
ENV	AUTOINDEX=yes

# Initialize nginx
#CMD service nginx start \
#	service mysql start

# Crear bd MySQL desde Linux
	#create database nombre_bd;
	#GRANT ALL PRIVILEGES ON nombre_bd.* TO 'usuario'@'localhost' IDENTIFIED BY 'contraseña';
	#flush privileges;

# Config nginx
#/etc/nginx/nginx.conf
