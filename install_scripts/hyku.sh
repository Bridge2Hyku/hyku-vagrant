############
# Hyku
############

echo "Installing Hyku"

SHARED_DIR=$1
CDM_HOST=$2
CDM_PORT=$3
CDM_SSL=$4

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

sudo mkdir -p /var/www/hyku
sudo chown -R vagrant:vagrant /var/www/hyku

cd $HOME_DIR
git clone https://github.com/samvera-labs/hyku.git
mv $HOME_DIR/hyku/* /var/www/hyku
rm -Rf $HOME_DIR/hyku

sudo mkdir -p /var/cdm/dir1
sudo mkdir -p /var/cdm/dir2
sudo chown -R vagrant: /var/cdm

sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'vagrant' CREATEDB;"

. /etc/default/hyku

cd /var/www/hyku

echo "gem 'cdm_migrator', git: 'https://github.com/Bridge2Hyku/cdm_migrator'" >> /var/www/hyku/Gemfile

gem install bundler -q
bundle install

bundle exec rake assets:precompile
bundle exec rake db:setup
rails g cdm_migrator:install

CDM_SSL=$(echo "$CDM_SSL" | awk '{print tolower($0)}')
if [ "$CDM_SSL" == "y" ] || [ "$CDM_SSL" == "yes" ] || [ "$CMD_SSL" == "true" ]; then
  CDM_PROTOCOL="https"
else
  CDM_PROTOCOL="http"
fi
CDM_URL="$CDM_PROTOCOL://$CDM_HOST"

sed -i -e "s|http:\/\/your-content-dm-host|${CDM_URL}|g" /var/www/hyku/config/cdm_migrator.yml
sed -i -e "s|8080|${CDM_PORT}|g" /var/www/hyku/config/cdm_migrator.yml
sed -i -e "s|/dir1/path/goes/here|/var/cdm/dir1|g" /var/www/hyku/config/cdm_migrator.yml
sed -i -e "s|/dir2/path/goes/here|/var/cdm/dir2|g" /var/www/hyku/config/cdm_migrator.yml
sed -i -e 's/front/server/g' /var/www/hyku/config/cdm_migrator.yml

echo -en "\nactive_job:\n  queue_adapter: :sidekiq\n" >> /var/www/hyku/config/settings/production.yml

sudo service apache2 restart

sudo cp $SHARED_DIR/config/sidekiq.init /etc/init.d/sidekiq
sudo chmod 755 /etc/init.d/sidekiq
sudo update-rc.d sidekiq defaults
sudo update-rc.d sidekiq enable
sudo /etc/init.d/sidekiq start

echo "Done"
