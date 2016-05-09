#!/usr/bin/env bash

# provisioning-progress as seen here: https://gist.github.com/luciancancescu/57025d19da727cfdc18f
# adapted from https://gist.github.com/jpfuentes2/2002954

function usage
{
  echo "usage: ruby_and_rails [[[-a ADMIN ] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"
APPLICATION_USER="sufia"
RBENV_HOME="/home/$APPLICATION_USER/rbenv" #previously: /usr/local/rbenv

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    shift
                      ADMIN=$1
                      ;;
    -h | --help )     usage
                      exit
                      ;;
    * )               usage
                      exit 1
  esac
  shift
done

# ruby
if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

# ruby
if grep -q +ruby $ADMIN_HOME/.provisioning-progress; then
  echo "--> ruby already installed, moving on."
else
  echo "--> Installing ruby..."
	cd $ADMIN_HOME
	# Install dependent packages
	sudo yum install -y gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

	# Check if $RBENV_HOME already exists
	if [[ -d "$RBENV_HOME" ]]; then
	  echo "-->  $RBENV_HOME already exists, moving on.";
	else
	  echo "Installing rbenv"
		# Install rbenv
		git clone git://github.com/sstephenson/rbenv.git $RBENV_HOME
		git clone git://github.com/sstephenson/ruby-build.git $RBENV_HOME/plugins/ruby-build
		git clone https://github.com/rbenv/rbenv-vars.git $RBENV_HOME/plugins/rbenv-vars

		# Check if clone succesful
		if [ $? -gt 0 ]; then
		  echo >&2  "Error: Git clone error! See above.";
		  exit 1;
		fi

    # Optionally, try to compile dynamic bash extension to speed up rbenv.
    # Don't worry if it fails; rbenv will still work normally:
    cd $RBENV_HOME && src/configure && make -C src

		# Add rbenv to the application user's path
#     sudo su - $APPLICATION_USER bash -c "echo export PATH=\"$RBENV_HOME/bin:\$PATH\" >> ~/.bash_profile"
# # TODO: not working...
#     sudo su - sufia bash -c "echo PATH=$RBENV_HOME/bin:'$PATH' >> ~/.bash_profile"
    # just do this for now...
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' | sudo tee -a /home/$APPLICATION_USER/.bash_profile

    # # Add rbenv to the path
		# echo '# rbenv setup - only add RBENV PATH variables if no single user install found' > /etc/profile.d/rbenv.sh
		# echo 'if [[ ! -d "${HOME}/.rbenv" ]]; then' >> /etc/profile.d/rbenv.sh
		# echo "  export RBENV_ROOT=$RBENV_HOME" >> /etc/profile.d/rbenv.sh
		# echo '  export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
		# echo '  eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
		# echo 'fi'  >> /etc/profile.d/rbenv.sh

		chmod +x /etc/profile.d/rbenv.sh
		source /etc/profile

		# Install ruby-build:
		pushd $RBENV_HOME/plugins
		  cd ruby-build
		  ./install.sh
		popd
		source /etc/profile


		echo '---------------------------------'
		echo "    rbenv installed to $RBENV_HOME"
		echo '---------------------------------'
		rbenv -v
	fi

	if [ -d $RBENV_HOME ]; then

	  rbenv install 2.2.4
	  rbenv rehash
	  rbenv global 2.2.4

    # TODO: fragile. fix.
		sudo mkdir $RBENV_HOME/versions/2.2.4/etc/
		sudo touch $RBENV_HOME/versions/2.2.4/etc/gemrc
	  echo 'gem: --no-document'  | sudo tee -a $RBENV_HOME/versions/2.2.4/etc/gemrc

	  gem update --system
	  gem install bundler
	  rbenv rehash

	fi

	ruby -v
  echo +ruby >> $ADMIN_HOME/.provisioning-progress
  echo "--> ruby now installed."
fi

# rails
if grep -q +rails $ADMIN_HOME/.provisioning-progress; then
  echo "--> rails already installed, moving on."
else
  echo "--> Installing rails..."
	gem install rails -v 4.2
	sudo yum install -y libpqxx-devel
	gem install pg -v '0.18.4'
  rbenv rehash
	rails -v
  echo +rails >> $ADMIN_HOME/.provisioning-progress
  echo "--> rails now installed."
fi
