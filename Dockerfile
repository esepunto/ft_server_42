# Install Debian
FROM	debian:buster

# Who are me?
LABEL	maintainer = "ssacrist@student.42madrid.com"

# Update and install. See best practices in Dockerfile: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run 
RUN	apt-get update && apt install -y \
	nginx \
	php php-mysql \
	mariadb-server

# Segurizar servicio mariadb ¿? https://www.atareao.es/tutorial/raspberry-pi-primeros-pasos/infraestructura-lemp-con-nginx-en-raspberry/
#RUN	mysql_secure_installation  

# Delete index.html in var/www/html && rename index.nginx-debian.html in same path
#mv index.nginx-debian.html index.html
 
##	php7.0 php7.0-fpm php7.0-mysql

# Start autoindex on (put "no" to off)
ENV	AUTOINDEX=yes

# Crear bd MySQL desde Linux
	#create database nombre_bd;
	#GRANT ALL PRIVILEGES ON nombre_bd.* TO 'usuario'@'localhost' IDENTIFIED BY 'contraseña';
	#flush privileges;


# Config nginx
#/etc/nginx/nginx.conf
