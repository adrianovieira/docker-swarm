#!/bin/sh

echo "INFO: [docker-setup-swarm_worker.sh] setting up swarm worker"
docker swarm join --secret 1qasw23edfr45tghy6 $1:$2
