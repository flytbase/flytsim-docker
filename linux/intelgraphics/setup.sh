#!/bin/bash

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${GRN}\nThis script is going to install docker-ce and docker-compose on your machine\n${NC}"
#check if script run with sudo permission
if [[ $EUID -ne 0 ]]; then
	echo -e "\n${RED}ERROR${NC}: This script must be run as root, ${YLW}run with sudo ./setup.sh, ${NC}exiting ...${NC}" 
	exit 1
fi

#detect docker, exit if it is true
echo -e "${YLW}Detecting if docker is already installed in this machine${NC}"
if [ $(command -v docker) > /dev/null ]
	then
	cat >&2 <<-EOF

	Warning: the "docker" command appears to already exist on this system.

	If you already have Docker installed, this script can cause trouble, which is
	why we're displaying this warning and provide the opportunity to cancel the
	installation.

	If you installed the current Docker package using this script and are using it
	again to update Docker, you can safely ignore this message.

	You may press Ctrl+C now to abort this script.

	EOF
	( set -x; sleep 10 )
fi


# <detect architecture, exit if not amd64>
echo -e "${YLW}Verifying if this machine's architecture complies to this setup requirement or not${NC}"
if [ $(uname -m) != "amd64" ] && [ $(uname -m) != "x86_64" ]
	then
	cat >&2 <<-EOF

	Error: This install script does not support $(uname -m).

	EOF
	exit 1
fi

# <detect ubuntu, exit if false>
echo -e "${YLW}Verifying if this machine runs a flavor of Ubuntu or not${NC}"
if [ ! $(command -v lsb_release) > /dev/null ]
	then
	apt-get update
	apt-get install lsb-release
fi

if [ $(lsb_release -si) != "Ubuntu" ]
	then
	echo -e "${RED}ERROR${NC}: This script would only work on Ubuntu, but $(lsb_release -si) detected, exiting...${NC}"
fi

echo -e "${YLW}Un-installing older docker versions, if installed.${NC}"
apt-get remove -y docker docker-engine
if sudo -H pip show docker; then sudo -H pip uninstall -y docker; fi
if sudo -H pip show docker-py; then sudo -H pip uninstall -y docker-py; fi

if [ "$(lsb_release --codename --short)" = "trusty" ]
	then
	echo -e "${YLW}Installing extra dependencies for Ubuntu 14.04"
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

echo -e "\n\n${GRN}Setup is now complete. Run ./start.sh to start your FlytSim container${NC}"

# echo -e "${YLW}System is going to reboot in 10 seconds. You may press Ctrl+C now to prevent it, even though it is not recommended."
# ( set -x; sleep 10 )

# reboot