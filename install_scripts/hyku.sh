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
sudo chown -R ubuntu:ubuntu /var/www/hyku

cd $HOME_DIR
git clone https://github.com/samvera-labs/hyku.git
mv $HOME_DIR/hyku/* /var/www/hyku
rm -Rf $HOME_DIR/hyku

sudo -u postgres psql -c "CREATE USER ubuntu WITH PASSWORD 'ubuntu' CREATEDB;"

. /etc/default/hyku

cd /var/www/hyku

echo "gem 'cdm_migrator'" >> /var/www/hyku/Gemfile

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

echo -en "cdm_url: '$CDM_URL'\ncdm_port: $CDM_PORT\n" > /var/www/hyku/config/cdm_migrator.yml

sudo service apache2 restart

sudo cp $SHARED_DIR/config/sidekiq.init /etc/init.d/sidekiq
sudo chmod 755 /etc/init.d/sidekiq
sudo update-rc.d sidekiq defaults
sudo update-rc.d sidekiq enable
sudo /etc/init.d/sidekiq start

echo "Done"
