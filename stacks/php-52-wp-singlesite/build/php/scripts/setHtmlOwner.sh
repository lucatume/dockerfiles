#!/usr/bin/env bash
htmlOwner=$(ls -ld /var/www/html | awk '{print $4}')
sedString="s/^www-data:x:33:33:/www-data:x:$htmlOwner:50:/"
sed -ri $sedString /etc/passwd
