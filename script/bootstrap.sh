#!/usr/bin/env bash

# provisioning-progress as seen here: https://gist.github.com/luciancancescu/57025d19da727cfdc18f
# TODO: vagrant runs all provisioning as root,
# ...so anything we want owned as vagrant, we'll have to make so (or su vagrant at beginning of script or something)

USER="vagrant"
USERHOME="/home/$USER"

if [ ! -f $USERHOME/.provisioning-progress ]; then
  touch $USERHOME/.provisioning-progress
  echo "--> Progress file created in $USERHOME/.provision-progress"
else
  echo "--> Progress file exists in $USERHOME/.provisioning-progress"
fi

sudo yum update -y

# install prereqs
if grep -q +prereqs $USERHOME/.provisioning-progress; then
  echo "--> prereqs already installed, moving on."
else
  echo "--> Installing prereqs..."
	sudo yum install -y wget
	sudo yum install -y vim-enhanced
	sudo yum install -y unzip
	sudo yum install -y git
	sudo yum install -y epel-release
  echo +prereqs >> $USERHOME/.provisioning-progress
  echo "--> prereqs are now installed."
fi

# postgres
if grep -q +postgres $USERHOME/.provisioning-progress; then
  echo "--> postgres already installed, moving on."
else
  echo "--> Installing postgres..."
	sudo yum install -y postgresql-server
	sudo postgresql-setup initdb
	sudo systemctl enable postgresql.service
	sudo systemctl start postgresql.service
  echo +postgres >> $USERHOME/.provisioning-progress
  echo "--> postgres now installed."
fi

# redis
if grep -q +redis $USERHOME/.provisioning-progress; then
  echo "--> redis already installed, moving on."
else
  echo "--> Installing redis..."
	sudo yum install -y redis
	sudo systemctl enable redis
	sudo systemctl start redis.service
  echo +redis >> $USERHOME/.provisioning-progress
  echo "--> redis now installed."
fi

# ImageMagick
if grep -q +ImageMagick $USERHOME/.provisioning-progress; then
  echo "--> ImageMagick already installed, moving on."
else
  echo "--> Installing ImageMagick..."
	sudo yum install -y ImageMagick
  echo +ImageMagick >> $USERHOME/.provisioning-progress
  echo "--> ImageMagick now installed."
fi

# java
if grep -q +java $USERHOME/.provisioning-progress; then
  echo "--> java already installed, moving on."
else
  echo "--> Installing java..."
	sudo yum install -y java-1.8.0-openjdk
  echo +java >> $USERHOME/.provisioning-progress
  echo "--> java now installed."
fi

# FITS
if grep -q +FITS $USERHOME/.provisioning-progress; then
  echo "--> FITS already installed, moving on."
else
  echo "--> Installing FITS..."
  cd $USERHOME
	wget -q http://projects.iq.harvard.edu/files/fits/files/fits-0.6.2.zip
	unzip -q fits-0.6.2.zip
	rm fits-0.6.2.zip
	sudo mv fits-0.6.2 /opt/
	cd /opt/fits-0.6.2/
	chmod a+x fits.sh
	echo -e "export PATH=\$PATH:/opt/fits-0.6.2/" | sudo tee -a /etc/profile.d/fits.sh
	source /etc/profile
  cd $USERHOME
  echo +FITS >> $USERHOME/.provisioning-progress
  echo "--> FITS now installed."
fi

# adduser
if grep -q +adduser $USERHOME/.provisioning-progress; then
  echo "--> application user already added, moving on."
else
  echo "--> adding application user..."
	sudo adduser sufia
  echo +adduser >> $USERHOME/.provisioning-progress
  echo "--> application user now added."
fi

# continue with new_project or deployment provisioners or manual install

# apache
# sudo yum install -y httpd