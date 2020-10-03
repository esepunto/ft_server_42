#!/bin/bash
    cp nginx /etc/nginx/sites-available/default
    rm -r ../var/www/html/*.html
    service nginx reload