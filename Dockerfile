# See best practices in Dockerfile: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run 

# Have you any doubt about nginx? Please, visit https://www.nginx.com/resources/wiki/ 

# INSTALL LINUX #
FROM	debian:buster

# WHO'RE ME # (“I know perfectly well my own egotism...”) 
LABEL	maintainer = "ssacrist@student.42madrid.com"

# UPDATE LINUX AND INSTALL NGINX, MYSQL (mariaDB), PHP and WGET #
RUN	apt-get update && apt install -y \
	nginx \
	mariadb-server \
	php-fpm php-mysql \
	wget

# SOME INTERESTINGS PROGRAMS"
RUN apt-get install -y vim
RUN apt-get install -y sudo

# Replace html from Apache to set localhost page
COPY srcs/nginx/index.html var/www/html/index.html

# Config nginx autoindex ON
COPY srcs/nginx/nginx /etc/nginx/sites-available/default
RUN rm -r var/www/html/*.html

# Config nginx autoindex OFF
#COPY srcs/nginx/nginx_off /etc/nginx/sites-available/default

# Config php
COPY srcs/php/info.php var/www/html/


######################
# INSTALL PHPMYADMIN #
######################

# Install some packages
RUN apt-get install -y php-mbstring php-zip php-gd && \
# Download phpmyadmin
	wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz && \
# Extract phpmyadmin
	tar xvzf phpMyAdmin-4.9.5-all-languages.tar.gz && \
# Move directories
	mv phpMyAdmin-4.9.5-all-languages var/www/html/phpmyadmin && \
# Delete phppmyadmin.tar
	rm phpMyAdmin-4.9.5-all-languages.tar.gz
# Config phpmyadmin
COPY srcs/phpmyadmin/config.inc.php var/www/html/phpmyadmin
# Create user and pass to access PhpMyAdmin (samuel/samuel)
RUN service mysql start && \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'samuel'@'localhost' IDENTIFIED BY 'samuel' WITH GRANT OPTION;" | mysql -u root  && \
	echo "FLUSH PRIVILEGES;" | mysql -u root


################################
# CREATING THE SSL CERTIFICATE #
################################

RUN apt-get install -y openssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=esepunto" -keyout /etc/ssl/private/ssacrist.key -out /etc/ssl/certs/ssacrist.crt
COPY srcs/nginx/ssl/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY srcs/nginx/ssl/ssl-params.conf /etc/nginx/snippets/ssl-params.conf


#####################
# INSTALL WORDPRESS #
#####################

# Download wordppress
RUN wget https://wordpress.org/latest.tar.gz && \
# Extract wordpress
	tar xvzf latest.tar.gz && \
# Move directories
	mv wordpress var/www/html/ && \
# Delete wordpress.tar	
	rm latest.tar.gz
# Create database and user (no password) 
RUN service mysql start && \
	mysql -e "CREATE DATABASE wpdb;" | mysql -u root --skip-password && \
	mysql -e "GRANT ALL PRIVILEGES ON wpdb.* TO 'root'@'localhost';" | mysql -u root --skip-password && \
	mysql -e "FLUSH PRIVILEGES;" | mysql -u root -p --skip-password && \
# Change MySQL Server authentication plugin for root user	
	echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root
# Config wordpress
COPY srcs/wordpress/wp-config.php var/www/html/wordpress/
#COPY srcs/wordpress/wordpress.conf /etc/nginx/sites-available/
#COPY srcs/wordpress/otro_wordpress.conf /etc/nginx/sites-available/wordpress.conf

RUN	chown -R www-data:www-data /var/www/html/*

# Start autoindex on (put "no" to off)
ENV	AUTOINDEX=no

EXPOSE 80 443

# Initialize services
CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	bash

