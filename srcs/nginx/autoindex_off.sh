#!/bin/bash
	cp temp/index.html var/www/html/
	cp /temp/nginx_off /etc/nginx/sites-available/default
	service nginx reload