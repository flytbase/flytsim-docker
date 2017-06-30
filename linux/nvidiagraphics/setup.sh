#!/bin/bash

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${GRN}\nThis script is going to install docker-ce, docker-compose, nvidia-docker, nvidia-docker-compose and their dependencies on your machine\n${NC}"
#check if script run with sudo permission
if [[ "$EUID" -ne 0 ]]; then
	echo -e "\n${RED}ERROR${NC}: This script must be run as root, ${YLW}run with sudo ./setup.sh, ${NC}exiting ...${NC}" 
	exit 1
fi

# <detect architecture, exit if not amd64>
echo -e "${YLW}Verifying if this machine's architecture complies to this setup requirement or not${NC}"
if [ "$(uname -m)" != "amd64" ] && [ "$(uname -m)" != "x86_64" ]
	then
	cat >&2 <<-EOF

	Error: This install script does not support $(uname -m).

	EOF
	exit 1
fi

# <detect ubuntu, exit if false>
echo -e "${YLW}Verifying if this machine runs a flavor of Ubuntu or not${NC}"
if [ ! $(command -v lsb_release) > /dev/null ] || [ ! $(command -v pip) > /dev/null ]
	then
	apt-get update
	apt-get install lsb-release python-pip
fi

if [ "$(lsb_release -si)" != "Ubuntu" ]
	then
	echo -e "${RED}ERROR${NC}: This script would only work on Ubuntu, but $(lsb_release -si) detected, exiting...${NC}"
fi

echo -e "${YLW}Un-installing older docker versions, if installed.${NC}"
apt-get remove -y docker docker-engine
if sudo -H pip show docker; then sudo -H pip uninstall -y docker; fi
if sudo -H pip show docker-py; then sudo -H pip uninstall -y docker-py; fi

if [ "$(lsb_release --codename --short)" = "trusty" ]
	then
	echo -e "${YLW}Installing extra dependencies for Ubuntu 14.04${NC}"
	apt-get update
	apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
fi

#install docker dependencies
echo -e "\n\n${YLW}Installing docker installation dependencies${NC}"
apt-get install -y apt-transport-https ca-certificates curl software-properties-common || ( echo -e "\n${RED}ERROR${NC}: Are You Connected to the Internet?${NC}" ; exit 1 )
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - || ( echo -e "\n${RED}ERROR${NC}: Are You Connected to the Internet?${NC}" ; exit 1 )
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" || ( echo -e "\n${RED}ERROR${NC}: Are You Connected to the Internet?${NC}" ; exit 1 )
apt-get update || ( echo -e "\n${RED}ERROR${NC}: Are You Connected to the Internet?${NC}" ; exit 1 )

echo -e "\n\n${YLW}Installing docker-ce${NC}"
# install docker compose
apt-get install -y docker-ce || ( echo -e "\n${RED}ERROR${NC}: Error installing docker-ce, try again ...${NC}" ; exit 1 )

echo -e "${GRN}Congratulations! docker-ce installation is successful${NC}"

# groupadd docker
if ! su -c 'groups' $SUDO_USER | grep -q docker
	then
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

echo -e "\n\n${YLW}Installing docker-compose${NC}"
sudo -H pip install --upgrade docker-compose
echo -e "${GRN}Congratulations! docker-compose installation is successful${NC}"

#installing nvidia-docker
echo -e "\n\n${YLW}Installing nvidia-docker plugin. Check pre-requisite at: https://github.com/NVIDIA/nvidia-docker/wiki/Installation${NC}"
apt install nvidia-modprobe
if dpkg -l | grep nvidia-docker -q
	then 	
	echo -e "${GRN}nvidia-docker already installed${NC}"
else 
	wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
	dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb
	echo -e "${GRN}Congratulations! nvidia-docker installation is successful${NC}"
fi

#installing nvidia-docker-compose
echo -e "\n\n${YLW}Installing nvidia-docker-compose plugin${NC}"
if sudo -H pip show nvidia-docker-compose > /dev/null
	then
	echo -e "${GRN}nvidia-docker-compose already installed${NC}"
else
	sudo -H pip install nvidia-docker-compose
	echo -e "${GRN}Congratulations! nvidia-docker-compose installation is successful${NC}"
fi

#creating nvidia-docker volume if not available
driver_version=$(curl -s http://localhost:3476/docker/cli | awk -F ' ' '{print $2}' | awk -F ':' '{print $1}' | sed s/--volume=//g)
if docker volume ls | grep $driver_version > /dev/null
	then
	if [ "$(docker volume ls | grep nvidia-docker | tr -d ' ')" != "nvidia-docker"$driver_version ]
		then
		docker volume rm -f $driver_version > /dev/null
		docker volume create -d nvidia-docker --name $driver_version > /dev/null
	fi
else
	docker volume create -d nvidia-docker --name $driver_version > /dev/null
fi

echo -e "\n\n${GRN}Setup is now complete. Run sudo ./start.sh to start your FlytSim container${NC}"

