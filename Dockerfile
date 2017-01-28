# Header with common metadata to indicate who this image is maintained by
# AND more importantly the code image we are using as a base
# #ubuntu:16.04
FROM centos:latest
MAINTAINER "XOIT<xoit.group@xogrp.com"
# Metadata for user and directories
USER root
# Build your prerequisites so that you can re-do this again and again.
# Remove old version of Ruby
RUN yum -y remove ruby
# Let's install our pre-requisites for git, building native Ruby extensions,
# Ruby, Postgres and libXML and libXSLT for Nokogiri
RUN yum -y install \
    gcc git \
    libxml* libxslt* \
    make \
    postgres-devel postgresql95-devel.x86_64 postgresql95-server.x86_64 \
    ruby-devel
# We will need a NodeJS environment to support Rail
RUN curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
RUN yum install -y nodejs
# Now specifics to our applications
RUN mkdir -p /webapp/current
# Need to make sure ec2-user has full control
# to write to this directory
RUN chown -R root /webapp
WORKDIR /webapp/current
#Install 2 gems which are prerequisites for installing other gems.
RUN gem install bundle io-console
# ... How can we get the code into this image?
#RUN bundle install
##Start the app
#RUN bundle exec rails start
