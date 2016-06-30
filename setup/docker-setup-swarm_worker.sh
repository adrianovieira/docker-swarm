#!/bin/sh

echo "INFO: [docker-setup-swarm_worker.sh] setting up swarm worker"
docker swarm join $1:$2
