#!/usr/bin/env bash

# sets up a database for a sufia instance
function usage
{
  echo "usage: sufia_db [[[-a ADMIN ] [-u APPLICATION_USER]] [-p APPLICATION_USER_PASSWORD]] [-n APPLICATION_NAME]] [-e RAILS_ENVIRONMENT]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"

APPLICATION_USER="sufia"
APPLICATION_USER_PASSWORD="vagrant"
APPLICATION_NAME="newsletter-demo"
APPLICATION_INSTALL_LOCATION="/opt/$APPLICATION_NAME"
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

# database setup
if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

# ruby
if grep -q +database $ADMIN_HOME/.provisioning-progress; then
  echo "--> Database already configured, moving on."
else
  echo "--> Configuring database..."

	# drop the databases and user in case they already exist. i damn potent.
	sudo su - postgres bash -c "dropdb ${APPLICATION_NAME}_$RAILS_ENVIRONMENT;"
	# sudo su - postgres bash -c "dropdb ${APPLICATION_NAME}_test;"
	# sudo su - postgres bash -c "dropdb ${APPLICATION_NAME}_production;"
	sudo su - postgres bash -c "psql -c \"DROP USER IF EXISTS $APPLICATION_USER;\""

	sudo su - postgres bash -c "psql -c \"CREATE USER $APPLICATION_USER WITH CREATEDB PASSWORD '$APPLICATION_USER_PASSWORD';\""

	# surely, we don't really need all three...
	sudo su - postgres bash -c "createdb -O $APPLICATION_USER ${APPLICATION_NAME}_$RAILS_ENVIRONMENT;"
	# sudo su - postgres bash -c "createdb -O $APPLICATION_USER ${APPLICATION_NAME}_test;"
	# sudo su - postgres bash -c "createdb -O $APPLICATION_USER ${APPLICATION_NAME}_production;"

	# echo -e "*:*:${APPLICATION_NAME}_production:$APPLICATION_USER:$APPLICATION_USER_PASSWORD" | sudo tee -a /home/$APPLICATION_USER/.pgpass
	# sudo chmod 0600 /home/$APPLICATION_USER/.pgpass
	# # TODO: review this:
	# sudo su - $APPLICATION_USER bash -c "sed -i 's/password:/#password:/g' /opt/$APPLICATION_NAME/config/database.yml"

	var_file="$APPLICATION_INSTALL_LOCATION/.rbenv-vars"
	if [ ! -f "$var_file" ]; then
	  sudo su - $APPLICATION_USER bash -c "touch $var_file"
	  echo "--> Environment variables file created in $var_file"
	else
	  echo "--> Environment variables file exists in $var_file"
	fi
	password_var="NEWSLETTER-DEMO_DATABASE_PASSWORD"
	grep -q "$password_var" "$var_file" &&
	{
		sudo su - $APPLICATION_USER bash -c "sed -i 's/$password_var.*/$password_var=$APPLICATION_USER_PASSWORD/' $var_file"
		echo "--> Database password updated in environment variables file"
	} ||
	{
		sudo su - $APPLICATION_USER bash -c "echo $password_var=$APPLICATION_USER_PASSWORD >> $var_file"
		echo "--> Database password added to environment variables file"
	}
	sudo su - $APPLICATION_USER bash -c "sed -i 's/username:.*/username: $APPLICATION_USER/' $APPLICATION_INSTALL_LOCATION/config/database.yml"

	# for stage and test:
	# TODO: this one really needs work...
	# TODO: look at this as an alternative: rake scholarsphere:generate_secret (https://github.com/psu-stewardship/scholarsphere/blob/146522c609c2f22d5ea274f1c791edbc109a9055/lib/tasks/scholarsphere.rake)
	#sed "s/secret_key_base: 993763a6cb3b9fc264065d2fae1910b8d54a8ccdc0bd0d886fdc46996a79e8f2c4567798a8e2548d59bb4756e78ba3385338073095b9a83531dd0e74670d816b/secret_key_base: `bundle exec rake secret`/" < /opt/$APPLICATION_NAME/config/secrets.yml
	# for production:
	#export "SECRET_KEY_BASE=`bundle exec rake secret`"

	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_INSTALL_LOCATION && bundle exec rake db:migrate RAILS_ENV=$RAILS_ENVIRONMENT"

  echo +database >> $ADMIN_HOME/.provisioning-progress
  echo "--> Database now configured."
fi
