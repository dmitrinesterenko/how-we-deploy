#!/bin/bash
#Short cut to copy to our pet instance
scp -v -r -i $AWS_INSTANCE_KEY_PATH $1 ec2-user@$AWS_INSTANCE_DNS:$2

