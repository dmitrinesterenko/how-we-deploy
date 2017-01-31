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
* After logging into our AWS account [create](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:) and EC2 instance that will be our pet.
* Choose the Amazon Linux AMI with Hardware Virtual Machine virtualization
	* This image includes some of the "tools" we need to start: sshd and yum for installing more software.
	* Hardware Virtual Machines are able to communicate directly with the hardware.
* Go through the steps asking the questions and finding the answers to:
	* What is a VPC?
	    * Choose the XO Development VPC
	* What is a subnet? Which one do I choose?
	    * What are the choices about?
	    * What are the regions about?
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
	 ```
	   mv ~/Downloads/my_key.pem ~/.ssh
	   chmod 500 ~/.ssh/my_key.pem
	 ```
* Take note of the Public DNS of your newly created EC2. Lets say it is `ec2-12-34-567-890.compute-1.amazonaws.com`

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
	* gist is that you have full access to do ANYTHING you want without and
	restrictions placed by a platform like Heroku.
	* Think about running a video game server, math algorithms.


## Deploy to your pet EC2
Let's deploy some code by using git. There are other alternatives in the
homework.
* Install git `sudo yum install -y git`
* Clone our project onto the EC2 using git
  `git clone git@github.com:dmitrinesterenko/how-we-deploy.git /tmp/how-we-deploy`
	* Did you get an authenticity warning? Why?
	* Now you need to make a [trusted key SSH
	* key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) which we will place in git.xogrp.com for your account to allow you to clone here:
	```
	ssh-keygen
	eval $(ssh-agent -s) #start the SSH agent who will be able to serve up keys when asked
	ssh-add ~/.ssh/id_rsa # and add our new key to it.
	```
	* Upload the public key into git.xogrp.com > account > settings > ssh and gpg keys.
	* *Only* upload the public key.
	* run the git clone command again
    * It worked because you are already members of a team allowed access to the
    repository that you are cloning.

* Let's build and launch our app!
	```
	mkdir -p /webapp/current
	cp -R /tmp/how-we-deploy /webapp/current
	gem install bundle
	bundle install
	```
	*  OOOPS, now we are going to [pre-install a few
	   things](http://stackoverflow.com/questions/23184819/rails-new-app-or-rails-h-craps-out-with-cannot-load-such-file-io-console) that will allow us to bundle and build those gems
	   ```
       sudo yum -y install gcc postgres-devel ImageMagick-devel postgresql95-devel.x86_64 postgresql95-server.x86_64 libxml* libxslt*
	   gem install io-console
	   bundle config build.nokogiri --use-system-libraries
       ```
	* Install a ruby version manager here we will use RVM
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
    * Now `bundle install`
	* `bundle exec rails s`
	* OOOPS, we need a [Node JS](https://nodejs.org/en/download/package-manager/) environment ...because it's a Rails app. Cue the
	  jokes about dependency between languages: it's like needing a helicopter to drive
	  your Ford Focus.
	* `sudo curl --silent --location https://rpm.nodesource.com/setup_7.x | sudo bash -`
	* `sudo yum install -y nodejs`
	* `bundle exec rails start`
    * This will not work but a variation on using -p and -b in rails will get us
      there, for more details on troubleshooting why you're not able to connect
      look [here](/2_AWS_TROUBLESHOOTING.md)

* For a quickstart run the build script `/tmp/how-we-deploy/scripts/aws/build.sh` it contains all of the above requirements.

## Now let's get to our app!

Remember the Public DNS entry from the first step?
Let's use it to access your very own pet browse to your Public DNS hostname http://ec2-12-34-567-890.compute-1.amazonaws.com:3000
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
* Deploy your code using the `scp` command (check out Setup Helpers at the bottom)
* How would an AMI snapshot help?
* What would a load balancer accomplish? (Hint think about multiple instances,
  think about port 80 or 443.)
* How to make a "public" subnet have a routing table that is "private"? (stop
sending requests to public IPs)
    * What happens when you take away the 0.0.0.0/0 -> igw rule from a route table?
* How to make a "private" subnet have a routing table that is "public"?
	* Hint for both of the above get familiar with the route table and it's
	features.
* What would the following do:
	 `sudo iptables -I INPUT 1 -p tcp -m state --state NEW -m tcp --dport 3000
-j REJECT`
* What is the role of an elastic IP?
* What is a VPC?
* What is a subnet?
	* Which one do I choose?
	* What are the choices about?
	* What are the regions about?
* What are [CIDR blocks](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#IPv4_CIDR_blocks)?
* What is a [route table](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Route_Tables.html)?
	* Why are there two route tables
	* [this](https://console.aws.amazon.com/vpc/home?region=us-east-1#routetables:filter=rtb-bb5d47d9)
	  and [this](https://console.aws.amazon.com/vpc/home?region=us-east-1#routetables:filter=rtb-ba5d47d8)?
* What is a security group and what settings are right?

## Setup Helpers
Add these environment variables to your shell configuration to allow the quick
access scripts.

edit your ~/.bashrc file and add _your_ values for the EC2 public DNS name and
the path to your key:

```sh
export AWS_INSTANCE_DNS="ec2-12-34-567-890.compute-1.amazonaws.com"
export AWS_INSTANCE_KEY_PATH="~/.ssh/key.pem"
```
These additions will allow you to use the scripts in `./aws/scripts/connect.sh` and
`./aws/scripts/copy.sh` scripts to connect and copy files to your EC2.
