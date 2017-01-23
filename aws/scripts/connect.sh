#!/bin/bash
#Short cut to connect to our pet instance
ssh -v -i $AWS_INSTANCE_KEY_PATH ec2-user@$AWS_INSTANCE_DNS

