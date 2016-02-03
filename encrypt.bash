#!/bin/bash

if [ -z $1 ] || [ -z $2 ] ; then
        echo "Please run command as: $0 domain.com domain.com,www.domain.com"
        exit
fi

# Install git
if which git ; then
        NOTHINGTOSEEHERE=0
else
        apt-get update
        apt-get install -y git
fi

# checkout etsencrypt
if [ -d /opt/letsencrypt ] ; then
        NOTHINGTOSEEHERE=0
else
        git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
fi

# Request certificates
/opt/letsencrypt/letsencrypt-auto certonly --email ssl_certificates_letsencrypt@$1 --agree-tos --webroot --renew-by-default -w /home/$1/public_html/ -d $2 --authenticator webroot

# Activate SSL cert
virtualmin enable-feature --domain $1 --ssl
virtualmin install-cert --domain $1 --cert /etc/letsencrypt/live/$1/cert.pem --key /etc/letsencrypt/live/$1/privkey.pem --ca /etc/letsencrypt/live/$1/fullchain.pem

