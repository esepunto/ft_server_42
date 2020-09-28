# See best practices in Dockerfile: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run 

# Install Debian
FROM	debian:buster

# Who are me?
LABEL	maintainer = "ssacrist@student.42madrid.com"

# Update and install. 
RUN	apt-get update && apt install -y \
	nginx \
	mariadb-server
RUN	apt-get install -y php-fpm php-mysql

RUN apt-get install -y vim
RUN apt-get install -y wget
#RUN apt-get install -y wordpress/wp.admin && phpmyadmin/config.inc.php
#RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt



# Replace html from Apache to set localhost page
COPY srcs/nginx/index.html var/www/html/index.html
COPY srcs/nginx/default /etc/nginx/sites-available/default 

# Config php
COPY srcs/php/info.php var/www/html/

# INSTALL PHPMYADMIN
#
# Install some packages
RUN apt-get install -y php-mbstring php-zip php-gd
#
# Download phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
#
# Extract phpmyadmin
RUN tar xvzf phpMyAdmin-4.9.5-all-languages.tar.gz
#
# Move directories
#RUN mv phpMyAdmin-4.9.5-all-languages /usr/share/phpmyadmin
RUN mv phpMyAdmin-4.9.5-all-languages var/www/html/phpmyadmin
#RUN mv phpMyadmin var/www/html/
#
# Delete phppmyadmin.tar
RUN rm phpMyAdmin-4.9.5-all-languages.tar.gz

COPY srcs/phpmyadmin/config.inc.php var/www/html/phpmyadmin
#
# Create temp directory (it´s necessary to run phpmyadmin)
#RUN mkdir -p /var/lib/phpmyadmin/tmp
#
# Asign web-user and group to apache server ¿¿¿???)
#RUN chown -R www-data:www-data /var/lib/phpmyadmin
#
# Data base to phpmyadmin (create_tables.sql is a command create when we install phpmyadmin)
#RUN mariadb < /usr/share/phpmyadmin/sql/create_tables.sql
#
# Connect to ddata vbase server
#RUN mysql 
####Insertamos la contraseña que le dimos en la instalación al administrador root y pulsamos la tecla Enter.
#
# Create the user 'user', the password 'pass' and get permisions# 
#RUN GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'user'@'localhost' IDENTIFIED BY 'pass';
#
# Create a user to access PhpMyAdmin
#RUN GRANT ALL PRIVILEGES ON *.* TO 'samuel'@'localhost' IDENTIFIED BY 'samuel' WITH GRANT OPTION;
#
# Goto phpmyadmin directory




#RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
#RUN tar xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
#RUN mv phpMyAdmin-4.9.0.1-all-languages/ /usr/share/phpmyadmin
#RUN mkdir -p /var/lib/phpmyadmin/tmp
#RUN chown -R www-data:www-data /var/lib/phpmyadmin
#RUN cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php




# ¿Borrar? COPY srcs/nginx/nginx.conf /etc/nginx/sites-available/localhost
# ¿Borrar? COPY srcs/nginx/ssl/self-signed.conf /etc/nginx/snippets/self-signed.conf



# ¿Borrar? COPY srcs/nginx/default.conf /etc/nginx/conf.d/



# Start autoindex on (put "no" to off)
ENV	AUTOINDEX=yes

EXPOSE 80 443

# Initialize services
CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	bash



# Crear bd MySQL desde Linux
	#create database nombre_bd;
	#GRANT ALL PRIVILEGES ON nombre_bd.* TO 'usuario'@'localhost' IDENTIFIED BY 'contraseña';
	#flush privileges;

# Config nginx
#/etc/nginx/nginx.conf
