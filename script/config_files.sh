#!/usr/bin/env bash

# TODO: script configuration of these files
# TODO: run as application user or chown the results to them

APPLICATION_LOCATION=~/Source/archives-demo/project-code/newsletter-demo

cd $APPLICATION_LOCATION/config
cp analytics.yml.template analytics.yml
cp blacklight.yml.template blacklight.yml
cp database.yml.template database.yml
cp fedora.yml.template fedora.yml
cp jetty.yml.template jetty.yml
cp redis.yml.template redis.yml
cp secrets.yml.template secrets.yml
cp solr.yml.template solr.yml
cp environments/development.rb.template environments/development.rb
cp environments/production.rb.template environments/production.rb
