### Why?

Build an "image" that contains all of the dependencies you need once.

Inherit from other images just how you would inherit functionality from another
class in a programming language.

Infrastructure as code, manage the dependencies and binaries of your
applications together with you source code.

### How?
Install [docker-toolbox](https://www.docker.com/products/docker-toolbox)

Remember how we had to install a bunch of prequisites in the prior excercises?

Well we were doing pretty much what we would do when making a Docker image.

Let's look at the two files side by side `aws/scripts/build.sh` and
`docker/dockerfile`

Dockerhub == Github but for complete "image" that include all required
dependencies to run a project.

Github - 20-30 lines of "README" instructions to install a project
Dockerhub - 2 lines of build a docker image and run the resulting container.

Now let's look at Dockerfile-rails which inherits from the rails:5.0.1 image.
It's much simpler and only needs to import our code, open the port 3000 and
launch our application.

### Build
```
docker build -t how-we-deploy:1.0 -f Dockerfile-rails .
```
### Run
```
docker run -it how-we-deploy:1.0
```

### Deploy
* Find the VCP ID and SUBNET_ID that you used to deploy your EC2 in the previous
exercise.
* Pick a number that's not used by anyone else this will be your MACHINE_ID.
* Find the credentials for the deployment AWS user, this user is the one we will use to
deploy a new EC2 with a Docker container.
* Make a folder called ~/.aws/ if you do not have the AWS command line interface
tools installed alread.
* Add these credentials to a local file in ~/.aws/credentials like this:
```sh
[xo-development]
aws_access_key_id = id
aws_secret_access_key = secrets
```
* Run this command to use these credentials for the rest of the session:
`export AWS_DEFAULT_PROFILE=xo-development`
* Run
```sh
docker-machine create --driver amazonec2 \
  --amazonec2-subnet-id $SUBNET_ID \
  --amazonec2-vpc-id $VPC_ID \
  --amazonec2-region us-east-1 \
  --amazonec2-zone c \
  --amazonec2-instance-type "t2.small" \
  --amazonec2-ami ami-4ae1fb5d \
  --amazonec2-tags Name,DockerNode-$1,Team,XOIT,Environment,Development,Role,WebHost
  $1
```
The above script is located in ./scripts/docker/create.sh where it is easier to
modify the values. Update the values for the subnet and vpc to match your own
and then execute the shell script: `./scripts/docker/create.sh awsXY` where XY
is your own unique number. Details of the options are [here](https://docs.docker.com/machine/drivers/aws/)

This will create a new EC2 instance using the docker-machine commands. Remember
the number you have chosen for your instance.

After your instance is created you can:
  * `docker-machine ssh awsXY` SSH into it.
  * `eval $(docker-machine env awsXY --shell bash)` set it to be the current  machine that executes docker commands
  * `ls -la ~/.docker/machine/machines/` these are all of your known
instances. Share this folder with a collegue and they will have access to
your instances. Share this with a nefarios Count Olaf and he will have
access to your instances.
        * `rm -rf` any of those machines you do not want to have a connection
to. Remember you also need to delete them from AWS! After you delete the folder
you can no longer connect to them.
  * `./scripts/docker/build.sh` to build your image directly on the remote
  machine.
  * `./scripts/docker/start.sh` to start your application on the remote machine
  (known as starting the container)
  * Alter the docker-machine AWS security group that was created to allow access
to port 3000 from anywhere in the world: 0.0.0.0/0
  * Browse to the public DNS for your docker-machine. You can get this from
either the AWS console or from `docker-machine ls`

### Homework
* What does `eval $(docker-machine env awsXY)` command really do?
* What else can you do with docker-machine?
* How can you make a collection of docker-machines?
* How would you launch new versions of your application?



