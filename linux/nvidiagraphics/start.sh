#!/bin/bash 

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

cd `dirname "$BASH_SOURCE"`
is_new_img=0
image_name=`grep image docker-compose.yml | awk -F ' ' '{print $2}'`
container_name=`grep container_name docker-compose.yml | awk -F ' ' '{print $2}'`

echo -e "${GRN}\nThis script is going to start FlytSim session for you\n${NC}"

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

is_installed() {
	echo -e "${YLW}Detecting if docker, docker-compose, nvidia-docker, nvidia-docker-compose are already installed in this machine${NC}"
	if [ ! $(command -v docker) > /dev/null ]; then echo -e "${RED}ERROR${NC}: docker does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
	if [ ! $(command -v docker-compose) > /dev/null ]; then echo -e "${RED}ERROR${NC}: docker-compose does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
	if [ ! $(command -v nvidia-docker) > /dev/null ]; then echo -e "${RED}ERROR${NC}: nvidia-docker does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
	if [ ! $(command -v nvidia-docker-compose) > /dev/null ]; then echo -e "${RED}ERROR${NC}: nvidia-docker-compose does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
}

do_image_pull() {
	cd `dirname "$BASH_SOURCE"`
	echo -e "${YLW}Downloading new container image from server, if available${NC}"
	img_sha=$(docker images --format "{{.ID}}" $image_name)
	docker-compose pull

	img_new_sha=$(docker images --format "{{.ID}}" $image_name)
	if [ "$img_sha" != "$img_new_sha" ]
		then
		if docker ps -a | grep $container_name > /dev/null
			then
			is_new_img=1
			echo -e "${YLW}\nContainer image updated, backing up user container in $(echo $image_name | awk -F ':' '{print $1}'):backup${NC}"
			docker-compose stop
			docker commit -m "backing up user data on $(date)" $container_name $(echo $image_name | awk -F ':' '{print $1}'):backup
			rm -r backup_files
			mkdir backup_files
			docker cp $container_name:/flyt backup_files
			docker rm $container_name
		fi
	fi
}

allow_xhost() {
	#allowing xhost access to GUI
	xhost +local:flytsim > /dev/null
	if [ $? -ne 0 ]
		then
		echo -e "${YLW}WARNING: xhost returned with error. You might not be able to visualize FlytSim's GUI${NC}"
		exit 1
	fi	
}

open_browser() {
	#sleep as system takes up time to start up
	sleep 5
	while true
	do
		if pgrep flytlaunch > /dev/null
			then
			sleep 15
			#starting up flytconsole in browser 
			sensible-browser "http://localhost/flytconsole" &
			break
		fi
		sleep 1
	done
}

docker_start() {
	cd `dirname "$BASH_SOURCE"`
	docker ps -a | grep $container_name > /dev/null

	if [ $? -eq 0 ]
		then
		nvidia-docker-compose restart
	else
		nvidia-docker-compose up -d
	fi

	if [ $? -eq 0 ]
		then
		echo -e "${GRN}FlytSim docker successfully started${NC}"
		echo -e "${GRN}Opening up http://localhost/flytconsole in your browser once system gets up and running\n\n${NC}"
		if [ $is_new_img -eq 1 ]
			then
			docker cp backup_files/flyt/userapps $container_name:/flyt
			[ -f backup_files/flyt/flytos/flytcore/share/core_api/scripts/lic_data.txt ] && docker cp backup_files/flyt/flytos/flytcore/share/core_api/scripts/lic_data.txt $container_name:/flyt/flytos/flytcore/share/core_api/scripts/lic_data.txt
			[ -f backup_files/flyt/flytos/flytcore/share/core_api/scripts/hwid ] && docker cp backup_files/flyt/flytos/flytcore/share/core_api/scripts/hwid $container_name:/flyt/flytos/flytcore/share/core_api/scripts/hwid
			rm -r backup_files
		fi
	else
		echo -e "${RED}ERROR${NC}: FlytSim docker could not be started, exiting...${NC}"
		exit 1
	fi
}

launch_flytsim() {
	is_installed
	do_image_pull
	allow_xhost
	docker_start
	open_browser
}

launch_flytsim