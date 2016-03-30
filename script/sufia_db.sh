#!/usr/bin/env bash

# NOTE: this script is not yet done - essentially notes for a script for a time when there is more time

APPLICATION_USER="vagrant"
APPLICATION_USER_PASSWORD="vagrant"
APPLICATION_NAME="newsletter-demo"
APPLICATION_LOCATION="/opt/$APPLICATION_NAME"
# TODO: get this from a single location:
RAILS_ENVIRONMENT="development"

# database setup

sudo -u postgres bash -c "psql -c \"CREATE USER $APPLICATION_USER WITH CREATEDB PASSWORD '$APPLICATION_USER_PASSWORD';\""

# drop the databases in case they already exist. i damn potent.
sudo -u postgres bash -c "dropdb ${APPLICATION_NAME}_development;"
sudo -u postgres bash -c "dropdb ${APPLICATION_NAME}_test;"
sudo -u postgres bash -c "dropdb ${APPLICATION_NAME}_production;"

# surely, we don't really need all three...
sudo -u postgres bash -c "createdb -O $APPLICATION_USER ${APPLICATION_NAME}_development;"
sudo -u postgres bash -c "createdb -O $APPLICATION_USER ${APPLICATION_NAME}_test;"
sudo -u postgres bash -c "createdb -O $APPLICATION_USER ${APPLICATION_NAME}_production;"

echo -e "*:*:${APPLICATION_NAME}_production:$APPLICATION_USER:$APPLICATION_USER_PASSWORD" | sudo tee -a /home/$APPLICATION_USER/.pgpass
sudo chmod 0600 /home/$APPLICATION_USER/.pgpass
# TODO: review this:
sudo su - $APPLICATION_USER bash -c "sed -i 's/password:/#password:/g' /opt/$APPLICATION_NAME/config/database.yml"

# for stage and test:
# TODO: this one really needs work...
# TODO: look at this as an alternative: rake scholarsphere:generate_secret (https://github.com/psu-stewardship/scholarsphere/blob/146522c609c2f22d5ea274f1c791edbc109a9055/lib/tasks/scholarsphere.rake)
#sed "s/secret_key_base: 993763a6cb3b9fc264065d2fae1910b8d54a8ccdc0bd0d886fdc46996a79e8f2c4567798a8e2548d59bb4756e78ba3385338073095b9a83531dd0e74670d816b/secret_key_base: `bundle exec rake secret`/" < /opt/$APPLICATION_NAME/config/secrets.yml
# for production:
#export "SECRET_KEY_BASE=`bundle exec rake secret`"

sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle exec rake db:migrate RAILS_ENV=$RAILS_ENVIRONMENT"
