#!/usr/bin/env bash

# sets up environment variables for a sufia instance
function usage
{
  echo "usage: passenger_apache [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME] [-e RAILS_ENVIRONMENT] [-s SERVER_NAME]] [-a SERVER_ALIAS] [-r RUBY] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
APPLICATION_USER="sufia"
APPLICATION_NAME="sufia-demo"
RAILS_ENVIRONMENT="development"
SERVER_NAME="sufia-demo" # TODO: get from Vagrantfile or master script
SERVER_ALIAS=""
RUBY="/usr/local/bin/ruby"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    		shift
                      		ADMIN=$1
                      		;;
    -u | --user )     		shift
                          APPLICATION_USER=$1
                      		;;
    -n | --name )     		shift
                          APPLICATION_NAME=$1
                      		;;
		-e | --environment )  shift
                          RAILS_ENVIRONMENT=$1
													;;
		-s | --server )  			shift
                          SERVER_NAME=$1
													;;
		-l | --alias )  			shift
                          SERVER_ALIAS=$1
													;;
		-r | --ruby )  				shift
                          RUBY=$1
													;;
    -h | --help )     		usage
                      		exit
                      		;;
    * )               		usage
                      		exit 1
  esac
  shift
done

# set remaining vars
ADMIN_HOME="/home/$ADMIN"
APPLICATION_INSTALL_LOCATION="/opt/$APPLICATION_NAME"

if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +passenger_apache $ADMIN_HOME/.provisioning-progress; then
  echo "--> Passenger & apache already configured, moving on."
else
  echo "--> Configuring passenger & apache..."

	# install and enable apache
	sudo yum install -y httpd
	sudo systemctl enable httpd.service

	# Install EPEL and other prereqs
	sudo yum install -y epel-release yum-utils pygpgme curl
  sudo yum-config-manager --enable epel

	# Add phusion's el7 YUM repository
	sudo curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo

	# Install Passenger + Apache module
	sudo yum install -y mod_passenger

	# OPTIONAL: install httpd-devel
	# so we can test apache install
	sudo yum install -y httpd-devel

  # OPTIONAL: install passenger-devel-5.0.28
  # so passenger can build native extensions
  # not currently available pre-built for current version of passenger / ruby-2.2.4 or 2.2.5
  # TODO: review - fragile
  sudo yum install -y passenger-devel-5.0.28

	# restart apache
	sudo systemctl restart httpd

	# NOTE: this won't work in automation, but manually, one could test the installation thus:
	#sudo /usr/bin/passenger-config validate-install

	# TODO: make sure this automates ok:
	sudo /usr/sbin/passenger-memory-stats

	# TODO: this should probably be run as the application user:
	passenger-config about ruby-command

	app_conf=$(cat <<-EOF
	<VirtualHost *:80>
	    ServerName $SERVER_NAME
	    ServerAlias $SERVER_ALIAS

	    # Tell Apache and Passenger where your app's 'public' directory is
	    DocumentRoot $APPLICATION_INSTALL_LOCATION/public

	    PassengerRuby $RUBY
	    PassengerAppEnv $RAILS_ENVIRONMENT
	    PassengerDefaultUser $APPLICATION_USER
	    PassengerDefaultGroup $APPLICATION_USER
	    PassengerFriendlyErrorPages on

	    # Relax Apache security settings
	    <Directory $APPLICATION_INSTALL_LOCATION/public>
	      Allow from all
	      Options -MultiViews
	      #Uncomment this if you're on Apache >= 2.4:
	      Require all granted
	    </Directory>
	</VirtualHost>
EOF
	)

	# TODO: test
	echo "$app_conf" | sudo tee /etc/httpd/conf.d/$APPLICATION_NAME.conf

	sudo systemctl restart httpd

	echo +passenger_apache >> $ADMIN_HOME/.provisioning-progress
	echo "--> Passenger & apache now configured."
fi
