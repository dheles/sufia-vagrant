#!/usr/bin/env bash

APPLICATION_USER="vagrant"
APPLICATION_LOCATION="/opt/newsletter-demo"
RAILS_ENVIRONMENT="development"

sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle exec rake assets:precompile RAILS_ENV=$RAILS_ENVIRONMENT"
sudo systemctl restart httpd
