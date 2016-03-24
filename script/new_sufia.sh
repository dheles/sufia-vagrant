#!/usr/bin/env bash

# NOTE: this script is untested - essentially notes for a script for a time when there is more time

# NOTE: currently a problem with rubyracer. use nodejs instead
# TODOn't: gem 'therubyracer', platforms: :ruby

# install sufia-related dependencies:
# add to Gemfile:
# gem 'sufia', '6.6.0'
# gem 'kaminari', github: 'jcoyne/kaminari', branch: 'sufia'  # required to handle pagination properly in dashboard. See https://github.com/amatsuda/kaminari/pull/322

# TODO: figure out how much this really matters in dev:
# sudo su - sufia
cd /opt/newsletter-demo/
bundle install
# error: quiver:///notes/5AD6FA54-F5AE-4573-8177-BFC6D587499F
bundle update

# install a javascript runtime
sudo yum install -y nodejs

# install sufia
# TODO: this one takes for. bloody. ever.
rails generate sufia:install -f
