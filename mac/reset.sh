#!/bin/bash

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "\n${RED}CAUTION: This script is going to reset FlytSim's container to factory default for you. This would delete all of your files present inside the container\n${NC}"

read -p "Do you still want to continue?[y/N] " -n 1 -r
echo ""
if [[ "$REPLY" =~ ^[Yy]$ ]]
then
	cd `cd $(dirname $BASH_SOURCE) ; pwd -P`
	container_name=`grep container_name docker-compose.yml | awk -F ' ' '{print $2}' | tr -d "\r"`
	if docker ps | grep $container_name > /dev/null
		then
		docker-compose stop
		docker rm -f $container_name
		if [ "$?" -ne 0 ]
			then
			echo -e "\n${RED}ERROR${NC}: Problem encountered. Could not remove Flytsim container. Exiting ...${NC}"
			exit 1
		fi
	else
		if docker ps -a | grep $container_name > /dev/null
			then
			docker rm $container_name
			if [ "$?" -ne 0 ]
				then
				echo -e "\n${RED}ERROR${NC}: Problem encountered. Could not remove Flytsim container. Exiting ...${NC}"
				exit 1
			fi
		else
			echo -e "\n${RED}ERROR${NC}: It seems there is no container named $container_name to remove. Trigger start.ps1 script to start FlytSim...Exiting ...${NC}"
			exit 1
		fi
	fi
	echo -e "\n{GRN}FlytSim container successfully deleted, trigger start.ps1 to start FlytSim...${NC}"
	exit 0
else
	echo -e "\n${RED}Script aborted by user. Exiting...${NC}"
	exit 1
fi