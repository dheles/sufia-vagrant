#!/usr/bin/env bash

APPLICATION_USER="vagrant"
APPLICATION_NAME="newsletter-demo"
APPLICATION_LOCATION="/opt/$APPLICATION_NAME"

# TODO: test
sudo su - $APPLICATION_USER bash -c "kill -INT $(cat $APPLICATION_LOCATION/tmp/pids/_opt_newsletter-demo_jetty_development.pid)"

sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle exec rake jetty:stop"
sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle exec rake jetty:clean"
sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle exec rake sufia:jetty:config"
sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle exec rake jetty:start"
