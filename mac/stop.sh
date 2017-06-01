#!/bin/bash

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${GRN}\nThis script is going to stop FlytSim session for you.\n${NC}"

cd `cd $(dirname $BASH_SOURCE) ; pwd -P`
container_name=`grep container_name docker-compose.yml | awk -F ' ' '{print $2}' | tr -d "\r"`
if docker ps | grep $container_name > /dev/null
	then
	docker-compose stop
	if [ $? -ne 0 ]
		then
		echo -e "\n${RED}ERROR${NC}: Problem encountered. Could not stop Flytsim container. Exiting ..."
		exit 1
	fi
else
	if docker ps -a | grep $container_name > /dev/null
		then
		echo -e "\n${YLW}WARNING: $container_name was already stopped. Exiting..."
		exit 0
	else
		echo -e "\n${RED}ERROR${NC}: It seems there is no container named $container_name to remove. Trigger start.sh script to start FlytSim...Exiting ..."
		exit 1
	fi
fi