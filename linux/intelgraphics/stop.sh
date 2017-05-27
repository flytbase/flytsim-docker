#!/bin/bash

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${GRN}\nThis script is going to stop FlytSim session for you.\n${NC}"

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
docker-compose stop
if [ $? -ne 0 ]
	then
	echo "${RED}ERROR${NC}: FlytSim session could not be stopped${NC}"
fi
