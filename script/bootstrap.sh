#!/usr/bin/env bash

# TODO: add sudo in for use outside of vagrant
# TODO: vagrant runs all provisioning as root,
# ...so anything we want owned as vagrant, we'll have to make so (or su vagrant at beginning of script or something)
# TODO: incorporate provisioning-progress as here: https://gist.github.com/luciancancescu/57025d19da727cfdc18f

if [ ! -f /home/vagrant/.provisioning-progress ]; then
  touch /home/vagrant/.provisioning-progress
  echo "--> Progress file created in /home/vagrant/.provision-progress"
else
  echo "--> Progress file exists in /home/vagrant/.provisioning-progress"
fi

sudo yum update

# install prereqs
if grep -q +prereqs .provisioning-progress; then
  echo "--> prereqs already installed, moving on."
else
  echo "--> Installing prereqs..."
	sudo yum install -y wget
	sudo yum install -y vim-enhanced
	sudo yum install -y unzip
	sudo yum install -y git
	sudo yum install -y epel-release
  echo +prereqs >> /home/vagrant/.provisioning-progress
  echo "--> prereqs are now installed."
fi

# postgres
if grep -q +postgres .provisioning-progress; then
  echo "--> postgres already installed, moving on."
else
  echo "--> Installing postgres..."
	sudo yum install -y postgresql-server
	sudo postgresql-setup initdb
	sudo systemctl enable postgresql.service
	sudo systemctl start postgresql.service
  echo +postgres >> /home/vagrant/.provisioning-progress
  echo "--> postgres now installed."
fi

# redis
if grep -q +redis .provisioning-progress; then
  echo "--> redis already installed, moving on."
else
  echo "--> Installing redis..."
	sudo yum install -y redis
	sudo systemctl enable redis
	sudo systemctl start redis.service
  echo +redis >> /home/vagrant/.provisioning-progress
  echo "--> redis now installed."
fi

# ImageMagick
if grep -q +ImageMagick .provisioning-progress; then
  echo "--> ImageMagick already installed, moving on."
else
  echo "--> Installing ImageMagick..."
	sudo yum install -y ImageMagick
  echo +ImageMagick >> /home/vagrant/.provisioning-progress
  echo "--> ImageMagick now installed."
fi

# java
if grep -q +java .provisioning-progress; then
  echo "--> java already installed, moving on."
else
  echo "--> Installing java..."
	sudo yum install -y java-1.8.0-openjdk
  echo +java >> /home/vagrant/.provisioning-progress
  echo "--> java now installed."
fi

# FITS
if grep -q +FITS .provisioning-progress; then
  echo "--> FITS already installed, moving on."
else
  echo "--> Installing FITS..."
	wget -q http://projects.iq.harvard.edu/files/fits/files/fits-0.6.2.zip
	unzip -q fits-0.6.2.zip
	rm fits-0.6.2.zip
	sudo mv fits-0.6.2 /opt/
	cd /opt/fits-0.6.2/
	chmod a+x fits.sh
	echo -e "export PATH=\$PATH:/opt/fits-0.6.2/" | sudo tee -a /etc/profile.d/fits.sh
	source /etc/profile
  echo +FITS >> /home/vagrant/.provisioning-progress
  echo "--> FITS now installed."
fi

# ruby
if grep -q +ruby .provisioning-progress; then
  echo "--> ruby already installed, moving on."
else
  echo "--> Installing ruby..."
	cd ~
	sudo yum install -y gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
	wget -q https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.4.tar.gz
	tar -xzf ruby-2.2.4.tar.gz
	cd ruby-2.2.4
	./configure
	make
	make install
  echo +ruby >> /home/vagrant/.provisioning-progress
  echo "--> ruby now installed."
fi

# rails
# TODO: for some reason, provisioner can't find .provisioning-progress for this step
if grep -q +rails .provisioning-progress; then
  echo "--> rails already installed, moving on."
else
  echo "--> Installing rails..."
	echo -e "export PATH=\$PATH:/usr/local/bin/" | sudo tee -a /etc/profile.d/ruby-on-rails.sh
	cd ~
	source /etc/profile
	gem install bundler --no-rdoc --no-ri
	gem install rails -v 4.2 --no-rdoc --no-ri
	sudo yum install -y libpqxx-devel
	gem install pg -v '0.18.4' --no-rdoc --no-ri
  echo +rails >> /home/vagrant/.provisioning-progress
  echo "--> rails now installed."
fi

# adduser
if grep -q +adduser .provisioning-progress; then
  echo "--> application user already added, moving on."
else
  echo "--> adding application user..."
	sudo adduser sufia
  echo +adduser >> /home/vagrant/.provisioning-progress
  echo "--> application user now added."
fi

# continue with new_project or deployment provisioners or manual install

# apache
# sudo yum install -y httpd
