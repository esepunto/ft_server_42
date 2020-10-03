#!/bin/bash
	cp srcs/nginx/index.html var/www/html/
	cp temp/index.html var/www/html/
	cp /temp/nginx_off /etc/nginx/sites-available/default
	service nginx reload