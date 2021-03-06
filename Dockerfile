# See best practices in Dockerfile: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run 

# Have you any doubt about nginx? Please, visit https://www.nginx.com/resources/wiki/ 

# INSTALL LINUX #
FROM	debian:buster

# WHO'RE ME # (“I know perfectly well my own egotism...”) 
LABEL	maintainer = "ssacrist@student.42madrid.com"

# UPDATE LINUX AND INSTALL NGINX, MYSQL (mariaDB), PHP and WGET #
RUN	apt-get update && \
	apt install -y \
	nginx \
	mariadb-server \
	php-fpm php-mysql \
	wget 

# CONFIG PHP #
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
# Permiss to phpmyadmin
RUN chmod 0755 var/www/html/phpmyadmin/config.inc.php && \
# Create temporal folder to store templates
	mkdir /var/www/html/phpmyadmin/tmp && chmod 0777 /var/www/html/phpmyadmin/tmp -R && \
# Create user and pass to access PhpMyAdmin (samuel/samuel)
	service mysql start && \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'samuel'@'localhost' IDENTIFIED BY 'samuel' WITH GRANT OPTION;" | mysql -u root  && \
	echo "FLUSH PRIVILEGES;" | mysql -u root 


#####################
# INSTALL WORDPRESS #
#####################
# Download wordppress
RUN	wget https://wordpress.org/latest.tar.gz && \
# Extract wordpress
	tar xvzf latest.tar.gz && \
# Move directories
	mv wordpress var/www/html/ && \
# Delete wordpress.tar	
	rm latest.tar.gz && \
# Create database and user (no password) 
	service mysql start && \
	mysql -e "CREATE DATABASE wpdb;" | mysql -u root --skip-password && \
	mysql -e "GRANT ALL PRIVILEGES ON wpdb.* TO 'root'@'localhost';" | mysql -u root --skip-password && \
	mysql -e "FLUSH PRIVILEGES;" | mysql -u root -p --skip-password && \
# Change MySQL Server authentication plugin for root user	
	echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root
# Config wordpress
COPY srcs/wordpress/wp-config.php var/www/html/wordpress/
COPY srcs/wordpress/wordpress.conf /etc/nginx/sites-available/


################################
# CREATING THE SSL CERTIFICATE #
################################
RUN apt-get install -y openssl && \
	openssl req -x509 -nodes -days 42 -newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=esepunto" -keyout /etc/ssl/private/ssacrist.key -out /etc/ssl/certs/ssacrist.crt
#COPY srcs/nginx/ssl/self-signed.conf /etc/nginx/snippets/self-signed.conf
#COPY srcs/nginx/ssl/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
COPY srcs/nginx/ssl/*.* /etc/nginx/snippets/


####################
# MANAGE AUTOINDEX #
####################
COPY srcs/nginx/nginx_on /etc/nginx/sites-available/default
RUN chmod 755 var/www/html/*.* && \
	mkdir temp && \ 
	rm -r var/www/html/index.nginx-debian.html && \
	chmod 755 ./
COPY srcs/nginx/index.html temp
COPY srcs/nginx/nginx_on temp
COPY srcs/nginx/nginx_off temp
COPY srcs/nginx/*.sh ./


# PORTS THAT LISTEN #
EXPOSE 80 443

# Initialize services #
CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	bash
