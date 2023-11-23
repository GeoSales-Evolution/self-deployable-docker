#!/bin/bash

# path relative to the hestia docker image, script intended to be used by the Makefile only
source ./app/.env

docker login $PRIVATE_REGISTRY -u $LOGIN -p $PASSWORD
