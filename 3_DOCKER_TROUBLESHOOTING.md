### Tricks
Get the news on the docker service that's running in your host:
`sudo journalctl -u docker.service`

Be wary of the AMI that is used to provision your host, some of the advertised
AMIs on the Docker [website](https://docs.docker.com/machine/drivers/aws/) are out of date.
Issues like [this](https://github.com/docker/machine/issues/3930) help you solve the problem.


