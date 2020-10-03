#!/bin/bash
    cp temp/nginx /etc/nginx/sites-available/default
    mv var/www/html/index.html temp/index.html
    service nginx reload