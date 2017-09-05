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
if ! pgrep dockerd > /dev/null; then echo -e "${RED}ERROR${NC}: docker does not seem to be running, has it been installed correctly, try rebooting your machine? ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi

if ! 'groups' | grep -q docker
	then
	if [[ "$EUID" -ne 0 ]]; then
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
		echo -e "${RED}ERROR${NC}: This script must be run as root, unless you follow the above command, ${YLW}run with sudo ./openshell.sh, ${NC}exiting ...${NC}" 
		exit 1
	else
		cat <<-EOF

		If you would like to use Docker as a non-root user, you should now consider
		adding your user to the "docker" group with something like:

		  sudo usermod -aG docker $SUDO_USER

		Remember that you will have to log out and back in for this to take effect!

		WARNING: Adding a user to the "docker" group will grant the ability to run
		         containers which can be used to obtain root privileges on the
		         docker host.
		         Refer to https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
		         for more information.

		EOF
	fi
fi

cd `cd $(dirname $BASH_SOURCE) ; pwd -P`
container_name=`grep container_name docker-compose.yml | awk -F ' ' '{print $2}'`
echo -e "${YLW}Launching a shell in $container_name ${NC}"

if docker ps | grep $container_name > /dev/null
	then
	docker exec -it $container_name bash
	if [ "$?" -ne 0 ]
		then
		echo -e "\n${RED}ERROR${NC}: Problem encountered. Shell inside Flytsim's container could not be accessed. Try executing ${YLW}sudo ./start.sh${NC} again."
		exit 1
	fi
else
	if docker ps -a | grep $container_name > /dev/null
		then
		echo -e "\n${RED}ERROR${NC}: $container_name was found to be in 'stopped' state. Please execute ${YLW}sudo ./start.sh${NC} again."
		exit 0
	else
		echo -e "\n${RED}ERROR${NC}: It seems there is no container named $container_name to get into. Trigger start.sh script to start FlytSim. Exiting ..."
		exit 1
	fi
fi
