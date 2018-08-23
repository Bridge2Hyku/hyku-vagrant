# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

	config.vm.hostname = "hyku"

	config.vm.box = "ubuntu/xenial64"
	config.vm.box_version = "20180529.0.0"

	config.vm.network :forwarded_port, guest: 80, host: 8080 # Hyku
	config.vm.network :forwarded_port, guest: 8983, host: 8983 # Solr
	config.vm.network :forwarded_port, guest: 8984, host: 8984 # Fedora

	config.vm.provider "virtualbox" do |v|
		v.memory = 3072
	end

	shared_dir = "/vagrant"
	cdm_host = ""
	cdm_port = ""
	cdm_ssl = "N"

	if !File.exists?(".vagrant/machines/default/virtualbox/action_provision")
		puts "Thank you for checking out Hyku with the CdmMigrator tool"
		puts ""
		puts "CdmMigrator Setup"
		print "ContentDM API Hostname: "
		cdm_host = STDIN.gets.chomp

		print "ContentDM API Port: "
		cdm_port = STDIN.gets.chomp

		print "ContentDM API over SSL? [y/N]: "
		cdm_ssl = STDIN.gets.chomp
	end

	config.vm.provision "shell", path: "./install_scripts/bootstrap.sh", args: shared_dir
	config.vm.provision "shell", path: "./install_scripts/dnsmasq.sh", args: shared_dir
	config.vm.provision "shell", path: "./install_scripts/env-vars.sh", args: shared_dir
	config.vm.provision "shell", path: "./install_scripts/fedora4.sh", args: shared_dir
	config.vm.provision "shell", path: "./install_scripts/solr.sh", args: shared_dir
	config.vm.provision "shell", path: "./install_scripts/ruby.sh", privileged: false, args: shared_dir
	config.vm.provision "shell", path: "./install_scripts/passenger.sh", privileged: false, args: shared_dir
	config.vm.provision "shell", path: "./install_scripts/fits.sh", args: shared_dir
	config.vm.provision "shell", path: "./install_scripts/imagemagick.sh", args: shared_dir
	config.vm.provision "shell", path: "./install_scripts/hyku.sh", privileged: false, args: [shared_dir, cdm_host, cdm_port, cdm_ssl]
	config.vm.provision "shell", inline: "echo Finished, enjoy migrating"

end
