#!/usr/bin/env bash

# provisioning-progress as seen here: https://gist.github.com/luciancancescu/57025d19da727cfdc18f
# adapted from https://gist.github.com/jpfuentes2/2002954

function usage
{
  echo "usage: ruby_and_rails [[[-a ADMIN ] | [-h]]"
}

# set defaults:
ADMIN="vagrant"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    shift
                      ADMIN=$1
                      ADMIN_HOME="/home/$ADMIN"
                      ;;
    -h | --help )     usage
                      exit
                      ;;
    * )               usage
                      exit 1
  esac
  shift
done

# set remaining vars
ADMIN_HOME="/home/$ADMIN"
RUBY_VERSION="2.2.5"
RUBY_URL="https://cache.ruby-lang.org/pub/ruby/2.2/ruby-$RUBY_VERSION.tar.gz"

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
  # TODO: consider "ruby -v | grep $RUBY_VERSION" or the like
else
  echo "--> Installing ruby..."
	cd $ADMIN_HOME
	# TODO: review:
  # Install dependent packages
	sudo yum install -y gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

  # download ruby
  wget -q $RUBY_URL

  # unzip
  tar -xzvf ruby-$RUBY_VERSION.tar.gz

  # configure, make, & install
  pushd ruby-$RUBY_VERSION
    ./configure --enable-shared --disable-install-doc --quiet
    make --quiet
    sudo make install --quiet
  popd

  # symlink ruby for root
  sudo ln -s /usr/local/bin/ruby /usr/bin/ruby

  #symlink gem for root
  sudo ln -s /usr/local/bin/gem /usr/bin/gem

  # TODO: test
  # attempting to make sure subsequent steps use our newly installed ruby
  # i'm looking at you, passenger
  source $ADMIN_HOME/.bash_profile

  # report version and install location
	ruby -v
  which ruby

  # don't install unnecessary docs
	touch ~/.gemrc
	echo 'gem: --no-document'  >> ~/.gemrc

  # update rubygems
	gem update --system

  # install bundler
	gem install bundler

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
  echo +rails >> $ADMIN_HOME/.provisioning-progress
  echo "--> rails now installed."
fi
