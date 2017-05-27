#!/bin/bash

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${GRN}\nThis script is going to open a bash shell into the docker container in which FlytSim is running\n${NC}"

echo -e "${YLW}Detecting if docker and docker-compose are already installed in this machine${NC}"
if [ ! $(command -v docker) > /dev/null ]; then echo -e "${RED}ERROR${NC}: docker does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
if [ ! $(command -v docker-compose) > /dev/null ]; then echo -e "${RED}ERROR${NC}: docker-compose does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi

if ! 'groups' | grep -q docker
	then
	if [[ $EUID -ne 0 ]]; then
		echo -e "${RED}ERROR${NC}: This script must be run as root, ${YLW}run with sudo ./start.sh, ${NC}exiting ...${NC}" 

		cat <<-EOF

		If you would like to use Docker as a non-root user, you should now consider
		adding your user to the "docker" group with something like:

		  sudo usermod -aG docker $USER

		Remember that you will have to log out and back in for this to take effect!

		WARNING: Adding a user to the "docker" group will grant the ability to run
		         containers which can be used to obtain root privileges on the
		         docker host.
		         Refer to https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
		         for more information.

		EOF
		exit 1
	fi
fi

cd `cd $(dirname $BASH_SOURCE) ; pwd -P`
docker exec -it `grep container_name docker-compose.yml | awk -F ' ' '{print $2}'` bash
if [ $? -ne 0 ]
	then
	echo -e "${RED}ERROR${NC}: Shell inside Flytsim's container could not be accessed. Is flytsim running? Try executing ${YLW}start.sh${NC} first${NC}"
	exit 1
fi