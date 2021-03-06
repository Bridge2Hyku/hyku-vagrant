# Hyku with CdmMigrator Vagrant Box
[Hyku](https://github.com/samvera-labs/hyku) using the [CdmMigrator](https://github.com/UVicLibrary/cdm_migrator) tool.

## Requirements

* [Vagrant 2.1.x](https://www.vagrantup.com/)
* [VirtualBox 5.2.x](https://www.virtualbox.org/)
* [Chrome](https://www.google.com/chrome/)
* CPU: Core i5/Ryzen 5 or higher
* RAM: 8GB or higher

Windows users will need Powershell version 3 or higher

The Chrome browser is required because of its support for subdomains on localhost `*.localhost` which Hyku Vagrant uses for repositories. Alternatively you can edit your `hosts` file and add  `127.0.0.1` to any `*.localhost` domain.

*Please note that the Hyrax stack can be resource-intensive and is not recommended for underpowered computers or on machines you intend to multi-task heavily with during your hyku testing.* 

## Install

1. `git clone https://github.com/Bridge2Hyku/hyku-vagrant.git`
2. `cd hyku-vagrant`
3. `vagrant up`
4. Input ContentDM information during install
5. Visit [http://localhost:8080](http://localhost:8080)

## Create super admin user

1. Visit [http://localhost:8080/users/sign_up](http://localhost:8080/users/sign_up) in your browser
2. Create a new account
3. Open a new terminal
4. `cd hyku-vagrant`, or wherever you cloned hyku-vagrant
5. `vagrant ssh`
6. `cd /var/www/hyku`
7. `bundle exec rake hyku:superadmin:grant[user@email.org]` where `user@email.org` is the email you registered
8. `exit`

## Create a repository

1. Visit [http://localhost:8080](http://localhost:8080) and log in as super admin
2. Click "Get Started"
3. Enter `example` for the "Short name"
4. Register for the new repository admin account
5. Your new repository will be at [http://example.localhost:8080](http://example.localhost:8080)

## Using CdmMigrator

### Create CSV

1. Navigate to your repository [http://example.localhost:8080/cdm_migrator/cdm/collection](http://example.localhost:8080/cdm_migrator/cdm/collection)
2. Map the ContentDM fields to the Hyku generic work
3. Click "generate CSV"

### Import CSV

1. Navigate to your repository [http://example.localhost:8080/cdm_migrator/csv/upload](http://example.localhost:8080/cdm_migrator/csv/upload)
2. Upload your CSV
3. Done

## Stopping vagrant

To stop vagrant run `vagrant halt`. To remove hyku vagrant and the virtual machine run `vagrant destroy`.

## Environment

* Ubuntu 16.04 64-bit machine with:
  * [Apache](https://httpd.apache.org/)
  * [CdmMigrator](https://github.com/Bridge2Hyku/cdm_migrator)
  * [Fedora 4.x](http://fedora.info/about) at [http://localhost:8984/fedora4/rest](http://localhost:8984/fedora4/rest)
  * [Hyku](https://github.com/samvera-labs/hyku) at
  [http://localhost:8080](http://localhost:8080)
  * [ImageMagick](https://www.imagemagick.org/script/index.php)
  * [Passenger 5.1.4](https://www.phusionpassenger.com/)
  * [Ruby 2.4.4](https://www.ruby-lang.org/)
  * [Solr 6.4.2](http://lucene.apache.org/solr/) at [http://localhost:8983/solr/](http://localhost:8983/solr/)
  * [Tomcat 7](http://tomcat.apache.org)
  * [Zookeeper](https://zookeeper.apache.org/)

## Enable Sidekiq

If you need to view the status of jobs follow these steps to enable the Sidekiq interface:

1. `cd hyku-vagrant`, or wherever your hyku-vagrant is
2. `vagrant ssh`
3. `nano /var/www/hyku/config/routes.rb`
4. Add the following lines to Line #2
```
require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'
```
It should look something like this:
```
Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
 
  if Settings.multitenancy.enabled
```
5. Hit `Ctrl-X` and then `y` to save changes and exit
6. `sudo service apache2 restart`
7. Visit [http://example.localhost:8080/sidekiq](http://example.localhost:8080/sidekiq)

## Maintainers

Current maintainers:

* [Sean Watkins](https://github.com/seanlw)

## Contributors

Coming Soon...
