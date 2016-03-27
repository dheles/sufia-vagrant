# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8081
  config.vm.network "forwarded_port", guest: 3000, host: 3001

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  #config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # config.vm.synced_folder ".", "/vagrant"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  config.vm.provider "virtualbox" do |vb|
      vb.name = "archives-demo"
  end

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # provision files
  # config.vm.provision "file", source: "rbenv.sh", destination: "rbenv.sh"

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
  config.vm.provision "install", type: "shell", path: "script/bootstrap.sh"
  config.vm.provision "ruby_and_rails", type: "shell", path: "script/ruby_and_rails.sh"
  config.vm.provision "confirmation", type: "shell", path: "script/bootstrap_confirm.sh"


  # provision authorized ssh key for deployment
  config.vm.provision "file", source: "public_ssh_key/authorized_key.pub", destination: ".ssh/authorized_key.pub"
  config.vm.provision "authorized key", type: "shell", path: "script/authorized_key.sh"

  # NOTE: putting this down here does not affect the order in which it happens.
  # see: https://github.com/mitchellh/vagrant/issues/936
  # Map our local user to the vagrant user in the box
  # config.nfs.map_uid=1000
  # config.nfs.map_gid=1000
  #config.vm.synced_folder "newsletter-demo", "/opt/newsletter-demo" #, type: "nfs"

  # run the following series only to setup a new sufia instance
  # begin: new sufia series
  config.vm.provision "new project", type: "shell", path: "script/new_project.sh"
  config.vm.provision "new sufia", type: "shell", path: "script/new_sufia.sh"
  # NOTE: no, no, no. this just killed the contents of my folder i had worked so hard to create...
  # NOTE: user does not exist until all previous steps have completed.
  #   comment out, provision to this point, comment back in and 'vagrant reload'
  config.vm.synced_folder "project-code", "/vagrant" #, owner:"sufia", group:"sufia"
  # end: new sufia series

  # TODO: provision setup of a sufia instance from a git(hub) repo
  #config.vm.provision "sufia repo", type: "shell", path: "script/sufia_repo.sh"

  # unfinished. run to setup config files.
  #config.vm.provision "config files", type: "shell", path: "script/config_files.sh"

  # unfininished. run to setup db. presumably for new project or one from git
  #config.vm.provision "database setup", type: "shell", path: "script/sufia_db.sh"

  # unfininished. run to setup solr and fedora. not likely to be run in final production
  #config.vm.provision "hydra jetty", type: "shell", path: "script/hydra-jetty.sh"

  # unfinished. run to configure email
  #config.vm.provision "configure email", type: "shell", path: "script/mail_config.sh"

  # unfinished. run to start background workers
  #config.vm.provision "background workers", type: "shell", path: "script/background_workers.sh"

  # unfinished. run to configure firewall
  #config.vm.provision "firewall", type: "shell", path: "script/firewall.sh"

  # unfinished. run to install & configure passenger + apache
  #config.vm.provision "passenger + apache", type: "shell", path: "script/passenger_apache.sh"

  # unfinished. run to precompile and finalize deployment
  #config.vm.provision "precompile", type: "shell", path: "script/precompile.sh"

  # TODO: hey, look at this guy: https://gist.github.com/rrosiek/8190550
end
