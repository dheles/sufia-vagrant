#!/usr/bin/env bash

APPLICATION_NAME="newsletter-demo"

# install and enable apache
sudo yum install -y httpd
sudo systemctl enable httpd.service

# Install EPEL and other prereqs
sudo yum install -y epel-release pygpgme curl

# Add phusion's el7 YUM repository
sudo curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo

# Install Passenger + Apache module
sudo yum install -y mod_passenger

# OPTIONAL: install httpd-devel
# so we can test apache install
sudo yum install -y httpd-devel

# restart apache
sudo systemctl restart httpd

# NOTE: this won't work in automation, but manually, one could test the installation thus:
#sudo /usr/bin/passenger-config validate-install

# TODO: make sure this automates ok:
sudo /usr/sbin/passenger-memory-stats

# TODO: this should probably be run as the application user:
passenger-config about ruby-command

# TODO: path properly, then audit &/or edit
# sudo cp ../conf/application-apache.conf.template /etc/httpd/conf.d/$APPLICATION_NAME.conf

# TODO: can't really do this until we are able to edit that^
#sudo systemctl restart httpd
