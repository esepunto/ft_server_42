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
RUN apt-get install -y sudo

# Replace html from Apache to set localhost page
COPY srcs/nginx/index.html var/www/html/index.html
COPY srcs/nginx/default /etc/nginx/sites-available/default 

# Config php
COPY srcs/php/info.php var/www/html/

# INSTALL PHPMYADMIN #
# Install some packages
RUN apt-get install -y php-mbstring php-zip php-gd
# Download phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
# Extract phpmyadmin
RUN tar xvzf phpMyAdmin-4.9.5-all-languages.tar.gz
# Move directories
RUN mv phpMyAdmin-4.9.5-all-languages var/www/html/phpmyadmin
# Delete phppmyadmin.tar
RUN rm phpMyAdmin-4.9.5-all-languages.tar.gz
# Config phpmyadmin
COPY srcs/phpmyadmin/config.inc.php var/www/html/phpmyadmin
# Create user and pass to access PhpMyAdmin (samuel/samuel)
RUN service mysql start && \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'samuel'@'localhost' IDENTIFIED BY 'samuel' WITH GRANT OPTION;" | mysql -u root  && \
	echo "FLUSH PRIVILEGES;" | mysql -u root

# CREATING THE SSL CERTIFICATE
# Mod 1
RUN apt-get install -y openssl
#RUN mkdir etc/nginx/ssl
#RUN chmod 700 /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=ssacrist" -keyout /etc/ssl/private/ssacrist.key -out /etc/ssl/certs/ssacrist.crt
COPY srcs/nginx/ssl/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY srcs/nginx/ssl/ssl-params.conf /etc/nginx/snippets/ssl-params.conf

# Start autoindex on (put "no" to off)
ENV	AUTOINDEX=yes

EXPOSE 80 443

# Initialize services
CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	bash

