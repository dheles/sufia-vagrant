#!/usr/bin/env bash

# generates template files from the config files
# during deployment, this process can be reversed with the config_files.sh script
# TODO: finish for provisioning

APPLICATION_LOCATION=~/Source/archives-demo/project-code/newsletter-demo

cd $APPLICATION_LOCATION/config
cp analytics.yml analytics.yml.template
cp blacklight.yml blacklight.yml.template
cp database.yml database.yml.template
cp fedora.yml fedora.yml.template
# jetty.yml not auto-generated
cp jetty.yml jetty.yml.template
cp redis.yml redis.yml.template
cp secrets.yml secrets.yml.template
cp solr.yml solr.yml.template
cp environments/development.rb environments/development.rb.template
cp environments/production.rb environments/production.rb.template
