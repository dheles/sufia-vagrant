#!/usr/bin/env bash

# turns a generic rails app into a sufia app
function usage
{
  echo "usage: new_sufia [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] [-v BUILD_VERSION]] [-e RAILS_ENVIRONMENT]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"

APPLICATION_USER="sufia"
APPLICATION_USER_HOME="/home/$APPLICATION_USER"
APPLICATION_NAME="newsletter-demo"
APPLICATION_BUILD_LOCATION="$APPLICATION_USER_HOME/$APPLICATION_NAME"
BUILD_VERSION="0.0.0.0"
#  TODO: test and remove, if not needed
RAILS_ENVIRONMENT="development"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )        shift
                          ADMIN=$1
                          ;;
    -u | --user )         shift
                          APPLICATION_USER=$1
                          ;;
    -n | --name )         shift
                          APPLICATION_NAME=$1
                          ;;
    -v | --version )      shift
                          BUILD_VERSION=$1
                          ;;
    -e | --environment )  shift
                          RAILS_ENVIRONMENT=$1
                          ;;
    -h | --help )         usage
                          exit
                          ;;
    * )                   usage
                          exit 1
  esac
  shift
done

if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +$APPLICATION_NAME $ADMIN_HOME/.provisioning-progress; then
  echo "--> $APPLICATION_NAME already created, moving on."
else
  echo "--> creating $APPLICATION_NAME"

	cat >> $APPLICATION_BUILD_LOCATION/Gemfile <<EOF

  # Sufia-related dependencies
  gem 'sufia', '6.6.0'
  gem 'kaminari', github: 'jcoyne/kaminari', branch: 'sufia'  # required to handle pagination properly in dashboard. See https://github.com/amatsuda/kaminari/pull/322'

  # resolve hopefully temporary issue with devise-guests:
  gem 'rsolr', '~> 1.0.6'
  gem 'devise'
  gem 'devise-guests', '~> 0.3'

  # limit ActiveFedora to safe range
  gem 'active-fedora', '~> 9.4', '< 9.8'

  # pin mail gem to avoid mime-types compatibility issues
  gem 'mail', '2.6.3'

  # we need jettywrapper, even for a "production" build for now
  # TODO: remove redundant entry in the development and test groups
  gem 'jettywrapper'

  # use figaro to set environment variables
  gem 'figaro'

  group :development, :test do
    gem 'rspec-rails'
  end

EOF

	# NOTE: currently a problem with rubyracer. use nodejs instead
	# TODOn't: gem 'therubyracer', platforms: :ruby
	# nodejs installed in bootstrap.sh

	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_BUILD_LOCATION && bundle install --path vendor/bundle"
	# error: quiver:///notes/5AD6FA54-F5AE-4573-8177-BFC6D587499F
	#bundle update needed to resolve multiple dependency conflicts
  sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_BUILD_LOCATION && bundle update"

	# install sufia
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_BUILD_LOCATION && bundle exec rails generate sufia:install -f"

  # install figaro
  sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_BUILD_LOCATION && bundle exec figaro install"

  # version the build
  sudo su - $APPLICATION_USER bash -c "sed -i 's/sufia-vagrant version.*/sufia-vagrant version $BUILD_VERSION/' $APPLICATION_BUILD_LOCATION/README.md"

	echo +$APPLICATION_NAME >> $ADMIN_HOME/.provisioning-progress
	echo "--> $APPLICATION_NAME created"
fi
