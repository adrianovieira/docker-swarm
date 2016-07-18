#!/bin/sh

echo "INFO: [docker-setup-swarm_manager.sh] setting up swarm manager"
docker swarm init --secret 1qasw23edfr45tghy6 --listen-addr $1:$2
