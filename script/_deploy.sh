#!/usr/bin/env bash

# master script for sufia deployment
# runs various provisioning scripts directly in leiu of the Vagrantfile

function usage
{
  echo "usage: _deploy [[[-a ADMIN ] [-u APPLICATION_USER]] | [-h]]"
}

# set defaults:
ADMIN="deploy"
APPLICATION_USER="sufia"
RAILS_ENVIRONMENT="production"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    shift
                      ADMIN=$1
                      ;;
    -u | --user )     shift
                      APPLICATION_USER=$1
                      ;;
    -h | --help )     usage
                      exit
                      ;;
    * )               usage
                      exit 1
  esac
  shift
done

# install prereqs
sudo bash bootstrap.sh -a $ADMIN -u $APPLICATION_USER
# ruby_and_rails
sudo bash ruby_and_rails.sh -a $ADMIN
# confirmation
sudo bash bootstrap_confirm.sh
# sufia repo
# sudo bash sufia_repo.sh -e $RAILS_ENVIRONMENT
