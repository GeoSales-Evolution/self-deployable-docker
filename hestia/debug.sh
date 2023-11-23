#!/bin/bash

docker run -v /var/run/docker.sock:/var/run/docker.sock -it --entrypoint sh hestia:latest 
