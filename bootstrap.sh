#!/usr/bin/env bash

yum update
yum install -y httpd
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi
