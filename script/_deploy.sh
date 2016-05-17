#!/usr/bin/env bash

# master script for sufia deployment
# runs various provisioning scripts directly in leiu of the Vagrantfile

# TODO: add remaining arguments

function usage
{
  echo "usage: _deploy [[[-a ADMIN ] [-u APPLICATION_USER]] | [-h]]"
}

# set defaults:
ADMIN="deploy"
RAILS_ENVIRONMENT="production"
DEFAULT_EMAIL="CHANGEME@CHANGEME.EDU"
SMTP_ADDRESS="SMTP.CHANGEME.EDU"
SERVER_NAME="sufia-demo"
SERVER_ALIAS="sufia-demo.library.jhu.edu"

# install prereqs
bash bootstrap.sh -a $ADMIN

# ruby_and_rails
bash ruby_and_rails.sh -a $ADMIN

# confirmation
bash bootstrap_confirm.sh

# sufia repo
bash sufia_repo.sh -a $ADMIN -e $RAILS_ENVIRONMENT

# environment variables
bash env_vars.sh -a $ADMIN -e $RAILS_ENVIRONMENT

# config files
bash config_files.sh -a $ADMIN

# database setup
bash sufia_db.sh -a $ADMIN -e $RAILS_ENVIRONMENT

# hydra jetty
bash hydra-jetty.sh -a $ADMIN

# configure email
bash mail_config.sh -a $ADMIN -m $DEFAULT_EMAIL -s $SMTP_ADDRESS

# background workers
bash background_workers.sh -a $ADMIN -e $RAILS_ENVIRONMENT

# firewall
bash firewall.sh -a $ADMIN

# passenger + apache
bash passenger_apache.sh -a $ADMIN -e $RAILS_ENVIRONMENT -s $SERVER_NAME -l $SERVER_ALIAS

# precompile
bash precompile.sh -a $ADMIN -e $RAILS_ENVIRONMENT
