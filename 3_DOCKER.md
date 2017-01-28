### Why?

Build an "image" that contains all of the dependencies you need once.

Inherit from other images just how you would inherit functionality from another
class in a programming language.

Infrastructure as code, manage the dependencies and binaries of your
applications together with you source code.

### How?
Remember how we had to install a bunch of prequisites in the prior excercises?

Well we were doing pretty much what we would when making a Docker image.

Let's look at the two files side by side `aws/scripts/build.sh` and
`docker/dockerfile`

Dockerhub == Github but for complete "image" that include all required
dependencies to run a project.

Github - 20-30 lines of "README" instructions to install a project
Dockerhub - 2 lines of build a docker image and run the resulting container
