#!/bin/bash
# bing your app to port 3000
docker run -it -p 3000:3000 how_we_deploy:1.0 $1
# bind this to port 80 for fun
#docker run -it -p 127.0.0.1:80:3000 how_we_deploy:1.0 $1
