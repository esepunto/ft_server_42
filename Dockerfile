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
RUN apt-get install -y vim
RUN apt-get install -y wordpress/wp.admin && \
	phpmyadmin/config.inc.php
#RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt


##	php7.0 php7.0-fpm php7.0-mysql

# Replace html from Apache to set localhost page
COPY srcs/nginx/index.html var/www/html/index.html
COPY srcs/nginx/default /etc/nginx/sites-available/default 
COPY srcs/nginx/nginx.conf /etc/nginx/sites-available/localhost
COPY srcs/nginx/ssl/self-signed.conf /etc/nginx/snippets/self-signed.conf


# Start autoindex on (put "no" to off)
ENV	AUTOINDEX=yes

EXPOSE 80 443

# Initialize nginx
CMD service nginx start && \
	service mysql start && \
	bash



# Crear bd MySQL desde Linux
	#create database nombre_bd;
	#GRANT ALL PRIVILEGES ON nombre_bd.* TO 'usuario'@'localhost' IDENTIFIED BY 'contraseña';
	#flush privileges;

# Config nginx
#/etc/nginx/nginx.conf
