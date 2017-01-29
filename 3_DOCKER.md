### Why?

Build an image of your code and dependencies that your solutions needs once and reuse
it anywhere.

Inherit from other images just how you would inherit functionality from another
class in a programming language. Start from a base that includes all of
rails:5.0.1, or golang, or python.

Infrastructure as code, manage the dependencies and binaries of your
applications together with you source code.

### How?
Remember how we had to install a bunch of prequisites in the prior excercises?

Well we were doing pretty much what we would when making a Docker image.

Let's look at the two files side by side `aws/scripts/build.sh` and
`Dockerfile`

Now look at Dockerfile-rails. It's much more succinct and inherits a lot of the
required binaries and software from rails:5.0.1. This is the power that we can
leverage in our applications. They only need to define what is specific to our
own solutions.

### Do It
Build the image by running
`./scripts/docker/build.sh` this runs a command to send the current
folder to the docker-engine which builds the image. One analogy for that process is that it
takes your code along with the Dockerfile instructions and compiles them
together into an environment similar to how the Swift or C compiler takes a
function you wrote and compiles it into a binary.
Run the container with your code by running
`./scripts/docker/run.sh`

### Details
Let's look at the details of what build and run accomplish.

Remember to bind to the right interface so that your thing is accessible for the
world.

`docker run ... --bind 127.0.0.1`

### Commentary
Dockerhub == Github but for complete "image" that include all required
dependencies to run a project.

Github - 20-30 lines of "README" instructions to install a project
Dockerhub - 2 lines of build a docker image and run the resulting container

