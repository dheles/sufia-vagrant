#!/usr/bin/env bash

# TODO: script configuration of these files

APPLICATION_LOCATION=~/Source/sufia-vm/newsletter-demo

cd $APPLICATION_LOCATION/config
cp analytics.yml.template analytics.yml
cp blacklight.yml.template blacklight.yml
cp database.yml.template database.yml
cp fedora.yml.template fedora.yml
cp jetty.yml.template jetty.yml
cp redis.yml.template redis.yml
cp secrets.yml.template secrets.yml
cp solr.yml.template solr.yml
cp initializers/setup_mail.rb.template initializers/setup_mail.rb
