#!/usr/bin/env bash

# NOTE: this script is untested - essentially notes for a script for a time when there is more time


USER="vagrant"
USERHOME="/home/$USER"

APPLICATION_NAME="newsletter-demo"
APPLICATION_USER="sufia"
APPLICATION_LOCATION="$USERHOME/$APPLICATION_NAME"

if [ ! -f $USERHOME/.provisioning-progress ]; then
  touch $USERHOME/.provisioning-progress
  echo "--> Progress file created in $USERHOME/.provision-progress"
else
  echo "--> Progress file exists in $USERHOME/.provisioning-progress"
fi

# NOTE: while this works; in the end, it's owned by vagrant.
# ...like really, really owned by vagrant. apparently, you can't chown shared folders.
# ...or more accurately, you can chown all you want, in the end, vagrant just disregards it
if grep -q +$APPLICATION_NAME $USERHOME/.provisioning-progress; then
  echo "--> $APPLICATION_NAME already created, moving on."
else
  echo "--> creating $APPLICATION_NAME"

	cat >> $APPLICATION_LOCATION/Gemfile <<EOF

	# Sufia-related dependencies
	gem 'sufia', '6.6.0'
	gem 'kaminari', github: 'jcoyne/kaminari', branch: 'sufia'  # required to handle pagination properly in dashboard. See https://github.com/amatsuda/kaminari/pull/322'

EOF

	# NOTE: currently a problem with rubyracer. use nodejs instead
	# TODOn't: gem 'therubyracer', platforms: :ruby
	# install a javascript runtime
	sudo yum install -y nodejs

	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle install --path vendor/bundle"
	# error: quiver:///notes/5AD6FA54-F5AE-4573-8177-BFC6D587499F
	#bundle update

	# install sufia
	# TODO: this one takes for. bloody. ever.
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && rails generate sufia:install -f"

	echo +$APPLICATION_NAME >> $USERHOME/.provisioning-progress
	echo "--> $APPLICATION_NAME created"
fi
