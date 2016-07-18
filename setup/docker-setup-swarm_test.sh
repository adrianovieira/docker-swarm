#!/bin/bash

echo "INFO: [docker-setup-swarm_test.sh] pull images"
docker pull adrianovieira/flask_kafka

echo "INFO: [docker-setup-swarm_test.sh] create app flask+kafka service"
docker service create -p 80:80 --replicas 3 --name flask_kafka adrianovieira/flask_kafka
#docker service create -p 80:80 --replicas 3 --name flask_kafka adrianovieira/flask_kafka:debian8
#docker service create -p 80:80 --replicas 1 --name flask_kafka adrianovieira/flask_kafka:python27
#docker service create -p 80:80 --replicas 1 --name flask_kafka adrianovieira/flask_kafka:ubuntu16

echo "INFO: [docker-setup-swarm_test.sh] finished successfuly"
