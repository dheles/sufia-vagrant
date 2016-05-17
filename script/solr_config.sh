#!/usr/bin/env bash

# adjusts solr configuration for a "production" build
# NOTE: this should be a temporary fix to be removed or adjusted
# when we get to a proper external solr server in production
function usage
{
  echo "usage: solr_config [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] | [-h]]"
}

# set defaults:
APPLICATION_USER="sufia"
APPLICATION_USER_HOME="/home/$APPLICATION_USER"
APPLICATION_NAME="sufia-demo"
APPLICATION_BUILD_LOCATION="$APPLICATION_USER_HOME/$APPLICATION_NAME"

OLD_SOLR_URL="http://your.production.server:8080/bl_solr/core0"
NEW_SOLR_URL="http://localhost:8983/solr/development"
sed -i 's|'"$OLD_SOLR_URL"'|'"$NEW_SOLR_URL"'|' $APPLICATION_BUILD_LOCATION/config/solr.yml

sed -i 's/blacklight-core/development/' $APPLICATION_BUILD_LOCATION/config/blacklight.yml
