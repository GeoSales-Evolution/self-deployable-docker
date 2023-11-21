#!/bin/bash

source ./.env

docker run -v /var/run/docker.sock:/var/run/docker.sock -v "$(pwd)/gitlab_registry_login.sh:/gitlab_registry_login.sh" -v "$(pwd)/.env:/app/.env" -it --entrypoint sh hestia:latest -c "/gitlab_registry_login.sh $LOGIN $PASSWORD && sh"
