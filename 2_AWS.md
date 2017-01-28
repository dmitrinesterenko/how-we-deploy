### AWS

## Why?
* To create a pet EC2 instance and prepare it for deployment
* To deploy a Rails application
* To understand what DNS settings need to happen
* Understanding SSH and git@
* Get your code there with git
* To get into some gritty details of what the freedom tradeoff of using AWS
means (it means that things will be more complicated. But there's freedom!)

## How?
* Log in to xo.okta.com
* Search for Development and click on the tile to login to the AWS Development account
* You can do anything you want here.
* Make sure you are logged into this account instead of your team's regular AWS account.

## Create a pet EC2
* https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:
* Choose the Amazon Linux AMI with Hardware Virtual Machine virtualization
    * This image includes some of the "tools" we need to start: ruby, git, sshd
    * Hardware Virtual Machines are able to communicate directly with the hardware.
* Go through the steps asking the questions and finding the answers to:
    * What is a VPC?
        * Choose the XO Development VPC
    * What is a subnet? Which one do I choose?
        * Choose the only option we have here.
    * What are [CIDR blocks](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#IPv4_CIDR_blocks)?
    * What is a [route table](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Route_Tables.html)?
    * What is a security group and what settings are right?
        * Choose the `web` security group
    * Why do we care?
* Tag your instance so you can find it later and others know what it's for (and
  so we don't delete it instantly)
* Create a new secret PEM SSH key and download it, move it to the default folder
  and secure it so that no other user on your computer can access it. This is
your password for future access to your pet EC2.
    * ```
       mv ~/Downloads/my_key.pem ~/.ssh
       chmod 500 ~/.ssh/my_key.pem
      ```
* Take note of the Public DNS of your newly created EC2. Lets say it's
* `ec2-12-34-567-890.compute-1.amazonaws.com`

## Connect to your pet EC2
* Let's log into it: `ssh -v -i ~/.ssh/my_key.pem ec2-user@ec2-12-34-567-890.compute-1.amazonaws.com`
    * Get any warnings?
    * Should we ignore those?
        * No! The idea in preventing man in the middle attacks is to verify
           through an independent channel that the information you are receiving
           is correct
        * [Part of the answer is
          here](https://forums.aws.amazon.com/thread.jspa?messageID=628520) and
[here](http://stackoverflow.com/questions/13791219/ssh-fingerprint-verification-for-amazon-aws-ec2-server-with-ecdsa)
and
[here](http://superuser.com/questions/929566/sha256-ssh-fingerprint-given-by-the-client-but-only-md5-fingerprint-known-for-se)
        * The gist is that it's always possible to independently verify the
        correct fingerprint of a new host you create in EC2.
* Setup your connection so it's easy to get back in by editing your local
  ~/.ssh/config file, name this host after your favorite pet
  ```
  Host nuff
    HostName ec2-12-345-67-89.compute-1.amazonaws.com
    IdentityFile ~/.ssh/mykey.pem
    User: ec2-user
    Port 22
  ```
* Look around:
    * `ls /etc` common configurations are kept here
    * `ls /var/log` all the logs files should be here. Mmmmm yum.log
    * gist is that you have full access to do ANYTHING you want without any
    restrictions placed by a platform like Heroku.

## Setup Helpers
Add these environment variables to your shell configuration to allow the quick
access scripts.

These  add ons will allow you to use the ./aws/scripts/connect.sh and
./aws/scripts/copy.sh scripts to connect and copy files to your EC2.

vim your ~/.bashrc file and add _your_ values for the EC2 public DNS name and
the path to your key:

```sh
export AWS_INSTANCE_DNS="ec2-12-34-567-890.compute-1.amazonaws.com"
export AWS_INSTANCE_KEY_PATH="~/.ssh/key.pem"
```

## Deploy to your pet EC2
Let's deploy some code by using git. There are other alternatives in the homework:
    * scp - secure copy
    * Downloading the code from any other location using `curl`
* `sudo mkdir -p /webapp/current && sudo chown -R ec2-user /webapp && cd /webapp/current`
* Find your favorite rails project and perform `git clone git@github.com:dmitrinesterenko/how-much-brooklyn-can-you-buy.git .`
    * Errrr, fix errors, install git: ```yum install git```
        * Did you get an authenticity warning? Why?
    * Note the below steps are only needed if you are cloning a private project in git or from enterprise git. Open source and public projects do not need these steps.
        * Now you need to make a [trusted key SSH
        * key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) which we will place in git.xogrp.com for your account to allow you to clone here:
            `cd ~/.ssh && ssh-keygen`
            * `eval $(ssh-agent -s)` start the SSH agent who will be able to serve up keys when asked
            * `ssh-add ~/.ssh/id_rsa` and add our new key to it.
        * Upload the public key into github > account > settings > ssh and gpg keys.
        * *Only* upload the public key.
        * `cd /webapp/current` and git clone again

* Let's build and launch our app!
    *  `gem install bundle`
    * `bundle install`
    *  OOOPS, now we are going to [pre-install a few
    *  things](http://stackoverflow.com/questions/23184819/rails-new-app-or-rails-h-craps-out-with-cannot-load-such-file-io-console) that will allow us to bundle and build those gems
    * `sudo yum -y install gcc postgres-devel ruby-devel ImageMagick-devel postgresql95-devel.x86_64 postgresql95-server.x86_64 libxml* libxslt*`
    * `gem install io-console`
    * `bundle config build.nokogiri --use-system-libraries`
    * Install a ruby version manager
      ```
        curl -sSL https://rvm.io/mpapis.asc | gpg --import -
        curl -L get.rvm.io | bash -s stable
        source ~/.profile
        rvm reload
        rvm requirements run
        # Setup Ruby 2.2.6 as the default Ruby
        rvm install 2.2.6
        rvm use 2.2.6 --default
      ```
    * `rails s`
    * OOOPS, we need a [Node JS](https://nodejs.org/en/download/package-manager/) environment ...because it's a Rails app. Cue the
      jokes about dependency between languages: it's like needing a helicopter to drive
      your Ford Focus.
    * `sudo curl --silent --location https://rpm.nodesource.com/setup_7.x | sudo bash -`
    * `sudo yum install -y nodejs`
    * `bundle exec rails start`

## Now let's get to our app!
    * Remember the Public DNS entry from the first step?
    * Let's use it to access your very own pet.
    * http://ec2-12-34-567-890.compute-1.amazonaws.com:3000
        * Why are we going to port 3000?
        * Why is it not working?
        * Let's fix it
    * Let's update our security group to allow access to port 3000
## Pricing
http://www.ec2instances.info

## Quiz
* Contrast this with Heroku, what are some differences?
* Why would you _not_ use Heroku?
* Which one is faster?
    * In performance?
    * In deployment speed?
* How will you scale Gifer to deal with the insane customer demand?
* How can we make our instance more secure from outside access?
* What if you picked a "private" subnet? I.e. one that doesn't route the
traffic through the internet gateways for the IPs that we are deployed to.

## Homework
* How would an AMI snapshot help you along?
* What would a load balancer accomplish? (Hint think about multiple instances,
  think about port 80 or 443.)
* How to make a "private" subnet have a routing table that is "public"?
* What would the following do:
     `sudo iptables -I INPUT 1 -p tcp -m state --state NEW -m tcp --dport 3000
-j REJECT`


