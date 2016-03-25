#!/usr/bin/env bash

APPLICATION_LOCATION="/opt/newsletter-demo"
RAILS_ENVIRONMENT="development"

cd $APPLICATION_LOCATION
rake assets:precompile RAILS_ENV=$RAILS_ENVIRONMENT
sudo systemctl restart httpd
