#!/usr/bin/env bash

# copy built sufia to synced_folder for upload to repo
# and then move it to install location
function usage
{
  echo "usage: move_sufia [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] [-r APPLICATION_REPO_LOCATION]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"

APPLICATION_USER="sufia"
APPLICATION_USER_HOME="/home/$APPLICATION_USER"
APPLICATION_NAME="newsletter-demo"
APPLICATION_BUILD_LOCATION="$APPLICATION_USER_HOME/$APPLICATION_NAME"
APPLICATION_INSTALL_LOCATION="/opt/$APPLICATION_NAME"
APPLICATION_REPO_LOCATION="/vagrant"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    shift
                      ADMIN=$1
                      ;;
    -u | --user )     APPLICATION_USER=$1
                      ;;
    -n | --name )     APPLICATION_NAME=$1
                      ;;
    -r | --repo )     APPLICATION_REPO_LOCATION=$1
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
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +move_sufia $ADMIN_HOME/.provisioning-progress; then
  echo "--> $APPLICATION_NAME already moved, moving on."
else
  echo "--> moving $APPLICATION_NAME"

  # copy build to synced_folder for checkin to repo
	sudo cp -R $APPLICATION_BUILD_LOCATION $APPLICATION_REPO_LOCATION

  # copy build to install location
  sudo mv $APPLICATION_BUILD_LOCATION $APPLICATION_INSTALL_LOCATION
  sudo chown -R $APPLICATION_USER: $APPLICATION_INSTALL_LOCATION

  # avoid SELinux issues:
  sudo yum -y install policycoreutils-python
  sudo semanage fcontext -a -t httpd_sys_content_t "$APPLICATION_INSTALL_LOCATION(/.*)?"
  sudo restorecon -R -v $APPLICATION_INSTALL_LOCATION

	echo +move_sufia >> $ADMIN_HOME/.provisioning-progress
	echo "--> $APPLICATION_NAME moved"
fi
