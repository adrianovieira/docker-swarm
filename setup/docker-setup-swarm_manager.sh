#!/bin/sh

echo "INFO: [docker-setup-swarm_manager.sh] setting up swarm manager"
docker swarm init --listen-addr $1:$2
