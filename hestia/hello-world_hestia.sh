#!/bin/bash

./build_hestia.sh

docker run -v /var/run/docker.sock:/var/run/docker.sock hestia -- run -v /var/run/docker.sock:/var/run/docker.sock hello-world