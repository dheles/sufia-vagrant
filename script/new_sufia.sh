#!/usr/bin/env bash

# turns a generic rails app into a sufia app

USER="vagrant"
USERHOME="/home/$USER"

APPLICATION_NAME="newsletter-demo"
APPLICATION_USER="sufia"
APPLICATION_USERHOME="/home/$APPLICATION_USER"
APPLICATION_LOCATION="$APPLICATION_USERHOME/$APPLICATION_NAME"

if [ ! -f $USERHOME/.provisioning-progress ]; then
  touch $USERHOME/.provisioning-progress
  echo "--> Progress file created in $USERHOME/.provision-progress"
else
  echo "--> Progress file exists in $USERHOME/.provisioning-progress"
fi

if grep -q +$APPLICATION_NAME $USERHOME/.provisioning-progress; then
  echo "--> $APPLICATION_NAME already created, moving on."
else
  echo "--> creating $APPLICATION_NAME"

	cat >> $APPLICATION_LOCATION/Gemfile <<EOF

  # Sufia-related dependencies
  gem 'sufia', '6.6.0'
  gem 'kaminari', github: 'jcoyne/kaminari', branch: 'sufia'  # required to handle pagination properly in dashboard. See https://github.com/amatsuda/kaminari/pull/322'

  # resolve hopefully temporary issue with devise-guests:
  gem 'rsolr', '~> 1.0.6'
  gem 'devise'
  gem 'devise-guests', '~> 0.3'

EOF

	# NOTE: currently a problem with rubyracer. use nodejs instead
	# TODOn't: gem 'therubyracer', platforms: :ruby
	# install a javascript runtime
	sudo yum install -y nodejs

	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle install --path vendor/bundle"
	# error: quiver:///notes/5AD6FA54-F5AE-4573-8177-BFC6D587499F
	#bundle update needed to resolve gem "mime-types" dependency conflict
  sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle update"

	# install sufia
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && rails generate sufia:install -f"

	echo +$APPLICATION_NAME >> $USERHOME/.provisioning-progress
	echo "--> $APPLICATION_NAME created"
fi
