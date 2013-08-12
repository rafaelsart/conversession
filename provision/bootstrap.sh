#!/usr/bin/env bash

# Setup locales
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Install utilities
apt-get update
apt-get install -y build-essential curl vim

# Install Postgresql
apt-get install -y postgresql-9.1 libpq-dev

# Install RVM
if [ ! -f /usr/local/rvm/bin/rvm ]; then
  \curl -#L https://get.rvm.io | bash -s stable --autolibs=3
  source /etc/profile.d/rvm.sh
fi

cd /vagrant

# Install Ruby
RUBY_VERSION="$(ruby -v | grep '2.0.0p247')"
if [ ! "$RUBY_VERSION" ]; then
  rvm install ruby-2.0.0-p247
  rvm use ruby-2.0.0-p247 --default
fi

# Install gems
bundle install

# Edit Postrgresql configuration and restart server
cp provision/templates/Postgresql/pg_hba.conf /etc/postgresql/9.1/main/
cp provision/templates/Postgresql/postgresql.conf /etc/postgresql/9.1/main/
/etc/init.d/postgresql restart

# Change the last word of next line to the name of your project
sudo -u postgres createuser -d -R -s conversession

# Initialize databases
bundle exec rake db:create
bundle exec rake db:migrate



# Edit webrick configuration and run server
# cp provision/templates/Webrick/config.rb /usr/local/rvm/rubies/ruby-1.9.2-p320/lib/ruby/1.9.1/webrick/
rails server -d

