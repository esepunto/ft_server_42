#!/bin/bash
    cp temp/nginx_on /etc/nginx/sites-available/default
    mv var/www/html/index.html temp/index.html
    service nginx reload