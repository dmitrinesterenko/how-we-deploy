#!/bin/bash
# Build your prerequisites so that you can re-do this again and again.
# Remove old version of Ruby
sudo yum -y remove ruby
# Let's install our pre-requisites for git, building native Ruby extensions,
# Ruby, Postgres and libXML and libXSLT for Nokogiri
sudo yum -y install \
    gcc git \
    libxml* libxslt* \
    postgres-devel postgresql95-devel.x86_64 postgresql95-server.x86_64 \
    ruby-devel
# Install a ruby version manager
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L get.rvm.io | bash -s stable
source ~/.profile
rvm reload
rvm requirements run
# Setup Ruby 2.2.6 as the default Ruby
rvm install 2.2.6
rvm use 2.2.6 --default
ruby --version
# We will need a NodeJS environment to support Rail
sudo curl --silent --location https://rpm.nodesource.com/setup_7.x | sudo bash -
sudo yum install -y nodejs
# Now specifics to our applications
sudo mkdir -p /webapp/current
# Need to make sure ec2-user has full control
# to write to this directory
sudo chown -R ec2-user /webapp
# Copy our app over there
cp -R /tmp/how-we-deploy/* /webapp/current
cd /webapp/current
#Install 2 gems which are prerequisites for installing other gems.
gem install bundle io-console
bundle install
#Start the app
hostname -I | xargs bundle exec rails s -p 3000 -b $1
