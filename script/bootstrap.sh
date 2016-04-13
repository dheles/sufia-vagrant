#!/usr/bin/env bash

# provisioning-progress as seen here: https://gist.github.com/luciancancescu/57025d19da727cfdc18f
# TODO: vagrant runs all provisioning as root,
# ...so anything we want owned as vagrant, we'll have to make so (or su vagrant at beginning of script or something)

function usage
{
  echo "usage: bootstrap [[[-a ADMIN ] [-u APPLICATION_USER]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"
APPLICATION_USER="sufia"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    shift
                      ADMIN=$1
                      ;;
    -u | --user )     APPLICATION_USER=$1
                      ;;
    -h | --help )     usage
                      exit
                      ;;
    * )               usage
                      exit 1
  esac
  shift
done

if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  sudo su - $ADMIN bash -c "touch $ADMIN_HOME/.provisioning-progress"
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

sudo yum update -y

# install prereqs
if grep -q +prereqs $ADMIN_HOME/.provisioning-progress; then
  echo "--> prereqs already installed, moving on."
else
  echo "--> Installing prereqs..."
	sudo yum install -y wget
	sudo yum install -y vim-enhanced
	sudo yum install -y unzip
	sudo yum install -y git
	sudo yum install -y epel-release
  echo +prereqs >> $ADMIN_HOME/.provisioning-progress
  echo "--> prereqs are now installed."
fi

# postgres
if grep -q +postgres $ADMIN_HOME/.provisioning-progress; then
  echo "--> postgres already installed, moving on."
else
  echo "--> Installing postgres..."
	sudo yum install -y postgresql-server
	sudo postgresql-setup initdb
	sudo systemctl enable postgresql.service
	sudo systemctl start postgresql.service
  echo +postgres >> $ADMIN_HOME/.provisioning-progress
  echo "--> postgres now installed."
fi

# redis
if grep -q +redis $ADMIN_HOME/.provisioning-progress; then
  echo "--> redis already installed, moving on."
else
  echo "--> Installing redis..."
	sudo yum install -y redis
	sudo systemctl enable redis
	sudo systemctl start redis.service
  echo +redis >> $ADMIN_HOME/.provisioning-progress
  echo "--> redis now installed."
fi

# ImageMagick
if grep -q +ImageMagick $ADMIN_HOME/.provisioning-progress; then
  echo "--> ImageMagick already installed, moving on."
else
  echo "--> Installing ImageMagick..."
	sudo yum install -y ImageMagick
  echo +ImageMagick >> $ADMIN_HOME/.provisioning-progress
  echo "--> ImageMagick now installed."
fi

# java
if grep -q +java $ADMIN_HOME/.provisioning-progress; then
  echo "--> java already installed, moving on."
else
  echo "--> Installing java..."
	sudo yum install -y java-1.8.0-openjdk
  echo +java >> $ADMIN_HOME/.provisioning-progress
  echo "--> java now installed."
fi

# FITS
if grep -q +FITS $ADMIN_HOME/.provisioning-progress; then
  echo "--> FITS already installed, moving on."
else
  echo "--> Installing FITS..."
  cd $ADMIN_HOME
	wget -q http://projects.iq.harvard.edu/files/fits/files/fits-0.6.2.zip
	unzip -q fits-0.6.2.zip
	rm fits-0.6.2.zip
	sudo mv fits-0.6.2 /opt/
	cd /opt/fits-0.6.2/
	chmod a+x fits.sh
	echo -e "export PATH=\$PATH:/opt/fits-0.6.2/" | sudo tee -a /etc/profile.d/fits.sh
	source /etc/profile
  cd $ADMIN_HOME
  echo +FITS >> $ADMIN_HOME/.provisioning-progress
  echo "--> FITS now installed."
fi

# adduser
if grep -q +adduser $ADMIN_HOME/.provisioning-progress; then
  echo "--> application user already added, moving on."
else
  echo "--> adding application user..."
	sudo adduser $APPLICATION_USER
  echo +adduser >> $ADMIN_HOME/.provisioning-progress
  echo "--> application user now added."
fi

# continue with new_project or deployment provisioners or manual install

# apache
# sudo yum install -y httpd
