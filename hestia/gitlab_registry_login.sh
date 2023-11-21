#!/bin/bash

LOGIN=$1
PASSWORD=$2

docker login registry.gitlab.com -u $LOGIN -p $PASSWORD
