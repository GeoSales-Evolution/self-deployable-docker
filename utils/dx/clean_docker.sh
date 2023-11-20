#!/bin/bash

# Stop and remove all containers if there are any
local_container_ids=$(docker ps -aq)

if [ -n "$local_container_ids" ]; then
    echo "Stopping and removing containers..."
    docker stop $local_container_ids
    docker rm $local_container_ids
else
    echo "No containers to stop or remove."
fi

# Remove all images
local_image_ids=$(docker images -aq)

if [ -n "$local_image_ids" ]; then
    echo "Removing docker images..."
    docker rmi -f $local_image_ids
else
    echo "No Docker images to remove."
fi