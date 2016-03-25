#!/usr/bin/env bash

APPLICATION_LOCATION="/opt/newsletter-demo"
APPLICATION_USER="vagrant"
# TODO: get this from a single location:
RAILS_ENVIRONMENT="development"

sudo chmod +x $APPLICATION_LOCATION/script/restart_resque.sh
sudo -u $APPLICATION_USER $APPLICATION_LOCATION/script/restart_resque.sh $RAILS_ENVIRONMENT
