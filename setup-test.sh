#!/bin/bash

docker pull mbentley/teamspeak
docker run -d --name teamspeak -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 mbentley/teamspeak serveradmin_password=password
