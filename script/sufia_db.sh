#!/usr/bin/env bash

# sets up a database for a sufia instance
function usage
{
  echo "usage: sufia_db [[[-a ADMIN ] [-u APPLICATION_USER]] [-p APPLICATION_USER_PASSWORD]] [-n APPLICATION_NAME]] [-e RAILS_ENVIRONMENT]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
APPLICATION_USER="sufia"
APPLICATION_USER_PASSWORD=$(openssl rand -base64 33)
APPLICATION_NAME="sufia-demo"
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
    -p | --password )     shift
                          APPLICATION_USER_PASSWORD=$1
                          ;;
    -n | --name )         shift
                          APPLICATION_NAME=$1
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

# set remaining vars
ADMIN_HOME="/home/$ADMIN"
APPLICATION_INSTALL_LOCATION="/opt/$APPLICATION_NAME"

# database setup
if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +database $ADMIN_HOME/.provisioning-progress; then
  echo "--> Database already configured, moving on."
else
  echo "--> Configuring database..."

	# drop the databases and user in case they already exist. i damn potent.
	sudo su - postgres bash -c "dropdb ${APPLICATION_NAME}_$RAILS_ENVIRONMENT;"
	sudo su - postgres bash -c "psql -c \"DROP USER IF EXISTS $APPLICATION_USER;\""

  # create the database user
	sudo su - postgres bash -c "psql -c \"CREATE USER $APPLICATION_USER WITH CREATEDB PASSWORD '$APPLICATION_USER_PASSWORD';\""

	# create the database for the configured environment
	sudo su - postgres bash -c "createdb -O $APPLICATION_USER ${APPLICATION_NAME}_$RAILS_ENVIRONMENT;"

	var_file="$APPLICATION_INSTALL_LOCATION/config/application.yml"
	if [ ! -f "$var_file" ]; then
	  sudo su - $APPLICATION_USER bash -c "touch $var_file"
	  echo "--> Environment variables file created in $var_file"
	else
	  echo "--> Environment variables file exists in $var_file"
	fi
	password_var="SUFIA-DEMO_DATABASE_PASSWORD"
	grep -q "$password_var" "$var_file" &&
	{
		sudo su - $APPLICATION_USER bash -c "sed -i 's/$password_var.*/$password_var: $APPLICATION_USER_PASSWORD/' $var_file"
		echo "--> Database password updated in environment variables file"
	} ||
	{
		sudo su - $APPLICATION_USER bash -c "echo $password_var: $APPLICATION_USER_PASSWORD >> $var_file"
		echo "--> Database password added to environment variables file"
	}
	sudo su - $APPLICATION_USER bash -c "sed -i 's/username:.*/username: $APPLICATION_USER/' $APPLICATION_INSTALL_LOCATION/config/database.yml"

	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_INSTALL_LOCATION && bundle exec rake db:migrate RAILS_ENV=$RAILS_ENVIRONMENT"

  echo +database >> $ADMIN_HOME/.provisioning-progress
  echo "--> Database now configured."
fi
