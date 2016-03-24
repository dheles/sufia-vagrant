#!/usr/bin/env bash

# NOTE: this script is untested - essentially notes for a script for a time when there is more time

APPLICATION_USER="vagrant"
APPLICATION_USER_PASSWORD="vagrant"

# database setup

sudo -u postgres bash -c "psql -c \"CREATE USER $APPLICATION_USER WITH CREATEDB PASSWORD '$APPLICATION_USER_PASSWORD';\""

# surely, we don't really need all three...
sudo -u postgres bash -c "psql -c \"CREATEDB -O $APPLICATION_USER ${APPLICATION_NAME}_development;\""
sudo -u postgres bash -c "psql -c \"CREATEDB -O $APPLICATION_USER ${APPLICATION_NAME}_test;\""
sudo -u postgres bash -c "psql -c \"CREATEDB -O $APPLICATION_USER ${APPLICATION_NAME}_production;\""

echo -e "*:*:${APPLICATION_NAME}_production:$APPLICATION_USER:$APPLICATION_USER_PASSWORD" | sudo tee -a /home/$APPLICATION_USER/.pgpass
sudo chmod 0600 /home/$APPLICATION_USER/.pgpass
sed "s/password:/#password:/" < /opt/$APPLICATION_NAME/config/database.yml

# for stage and test:
# TODO: this one really needs work...
sed "s/secret_key_base: 993763a6cb3b9fc264065d2fae1910b8d54a8ccdc0bd0d886fdc46996a79e8f2c4567798a8e2548d59bb4756e78ba3385338073095b9a83531dd0e74670d816b/secret_key_base: `bundle exec rake secret`/" < /opt/$APPLICATION_NAME/config/secrets.yml
# for production:
export "SECRET_KEY_BASE=`bundle exec rake secret`"

cd /opt/$APPLICATION_NAME
rake db:migrate RAILS_ENV=production
