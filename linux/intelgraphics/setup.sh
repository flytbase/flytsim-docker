#!/bin/bash

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${GRN}\nThis script is going to install docker-ce and docker-compose on your machine\n${NC}"
#check if script run with sudo permission
if [[ "$EUID" -ne 0 ]]; then
	echo -e "\n${RED}ERROR${NC}: This script must be run as root, ${YLW}run with sudo ./setup.sh, ${NC}exiting ...${NC}" 
	exit 1
fi

apt_lock=0
dpkg_lock=0

while fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
	echo -e "\n${RED}ERROR${NC}: Waiting for other apt process to finish${NC}"

	if [ $apt_lock -gt 10 ]
		then
		pids=`echo $(lsof -t /var/lib/apt/lists/lock)`
		if [ "$pids" != "" ]
			then
			kill -9 $pids
			echo -e "killing apt-get process"
		fi
	fi
	apt_lock=`expr $apt_lock + 1`

	sleep 1
done

while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
	echo -e "\n${RED}ERROR${NC}: Waiting for other dpkg process to finish${NC}"

	if [ $dpkg_lock -gt 10 ]
		then
		pids=`echo $(lsof -t /var/lib/dpkg/lock)`
		if [ "$pids" != "" ]
			then
			echo -e "killing dpkg process"
			kill -9 $pids
		fi
	fi
	apt_lock=`expr $dpkg_lock + 1`

	sleep 1
done

# <detect architecture, exit if not amd64>
echo -e "${YLW}Verifying if this machine's architecture complies to this setup requirement or not${NC}"
if [ "$(uname -m)" != "amd64" ] && [ "$(uname -m)" != "x86_64" ]
	then
	cat >&2 <<-EOF

	Error: This install script does not support $(uname -m).

	EOF
	exit 1
fi

apt-get update && apt-get install -y lsb-release python-pip

# <detect ubuntu, exit if false>
echo -e "${YLW}Verifying if this machine runs a flavor of Ubuntu or not${NC}"
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

root_loc=$(cd $(dirname $BASH_SOURCE) ; pwd -P)
cd $root_loc

echo -e "\n${YLW} Pulling FlytOS docker image. It will download around 1GB of data, and may take several minutes...${NC}"
image_name=`grep image docker-compose.yml | awk -F ' ' '{print $2}'`
docker image inspect $image_name > /dev/null
if [ $? -ne 0 ]
	then
	docker pull $image_name
	if [ $? -eq 0 ]
		then
		echo -e "\n${GRN} Image has been pulled.${NC}"
	else
		echo -e "\n${RED}ERROR${NC}: Image pull failed. Run this script again. Make sure you are connected to internet, otherwise please contact us at http://forums.flytbase.com${NC}"
	fi
fi

echo -e "\n\n${GRN}Setup is now complete. Run sudo ./start.sh to start your FlytSim container${NC}"
