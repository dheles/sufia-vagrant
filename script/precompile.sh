#!/usr/bin/env bash

APPLICATION_LOCATION="/opt/newsletter-demo"
RAILS_ENVIRONMENT="development"

cd $APPLICATION_LOCATION
bundle exec rake assets:precompile RAILS_ENV=$RAILS_ENVIRONMENT
sudo systemctl restart httpd
