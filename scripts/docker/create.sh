docker-machine create --driver amazonec2 \
  --amazonec2-subnet-id $SUBNET_ID \
  --amazonec2-vpc-id $VPC_ID \
  --amazonec2-region us-east-1 \
  --amazonec2-zone c \
  --amazonec2-instance-type "t2.small" \
  --amazonec2-ami ami-4ae1fb5d \
  --amazonec2-tags Name,DockerNode-$1,Team,XOIT,Environment,Development,Role,WebHost
  $1
# We are using the us-east-1c region and zone because the subnet that I had chosen is in that region
# The image ami-26d5af4c was advertised by Docker as the latest Ubuntu 16.04 but
# it is not and this list is better for finding the right image
# https://cloud-images.ubuntu.com/locator/ec2/



