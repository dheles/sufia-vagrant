#!/usr/bin/env bash

# TODO: confirm we have all the right files for configuration
# TODO: consider using .template files instead
# TODO: get values from environment vars for production

APPLICATION_LOCATION="/opt/newsletter-demo"
DEFAULT_EMAIL="dheles@jhu.edu"
DEFAULT_EMAIL_CONFIG1="$APPLICATION_LOCATION/config/initializers/mailboxer.rb"
DEFAULT_EMAIL_CONFIG2="$APPLICATION_LOCATION/config/initializers/devise.rb"

sed -i s/"no-reply@mailboxer.com"/$DEFAULT_EMAIL/ $DEFAULT_EMAIL_CONFIG1
sed -i "s/config.mailer_sender.*/config.mailer_sender = '$DEFAULT_EMAIL'/" $DEFAULT_EMAIL_CONFIG2

# TODO: script:
# additional settings in:
# config/environments/development.rb and config/environments/production.rb:
# When setting this property to :smtp, also ensure
# additional config.action_mailer properties are
# set in  ../initializers/setup_mail.rb
config.action_mailer.delivery_method = :smtp

# # rename and edit:
# # config/initializers/setup_mail.rb.template
# ActionMailer::Base.smtp_settings = {
#   address: ENV["SMTP_ADDRESS"]
# }
