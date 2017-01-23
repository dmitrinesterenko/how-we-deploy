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
# Now specifics to our applications
sudo mkdir -p /webapp/current
# Need to make sure ec2-user has full control
# to write to this directory
sudo chown -R ec2-user /webapp
cd /webapp/current
#Install 2 gems which are prerequisites for installing other gems.
gem install bundle io-console
bundle install

