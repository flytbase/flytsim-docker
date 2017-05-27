#!/bin/bash 

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${GRN}\nThis script is going to start FlytSim session for you\n${NC}"

if ! 'groups' | grep -q docker
	then
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
	if [[ $EUID -ne 0 ]]; then
		echo -e "${RED}ERROR${NC}: This script must be run as root, unless you follow the above command, ${YLW}run with sudo ./start.sh, ${NC}exiting ...${NC}" 
		exit 1
	fi
fi

is_installed_and_running() {
	echo -e "${YLW}Detecting if docker and docker-compose are already installed in this machine${NC}"
	if [ ! $(command -v docker) > /dev/null ]; then echo -e "${RED}ERROR${NC}: docker does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
	if [ ! $(command -v docker-compose) > /dev/null ]; then echo -e "${RED}ERROR${NC}: docker-compose does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
	if ! pgrep dockerd > /dev/null; then echo -e "${RED}ERROR${NC}: docker does not seem to be running, has it been installed correctly, try rebooting your machine? ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
}

do_image_pull() {
	cd $root_loc
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
			docker rmi $(echo $image_name | awk -F ':' '{print $1}'):backup
			docker commit -m "backing up user data on $(date)" $container_name $(echo $image_name | awk -F ':' '{print $1}'):backup
			[ -d backup_files ] && rm -r backup_files
			mkdir backup_files
			docker cp $container_name:/flyt/userapps backup_files
			docker cp $container_name:/flyt/flytos/flytcore/share/core_api/scripts backup_files
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
			if [ $is_new_img -eq 1 ]; then sleep 30; else sleep 15; fi
			#starting up flytconsole in browser 
			sensible-browser "http://localhost/flytconsole"
			break
		fi
		sleep 1
	done
}

push_backup_files() {
	cd $root_loc
	if [ $is_new_img -eq 1 ]
		then
		while true
		do
			if docker ps | grep $container_name > /dev/null
				then
				sleep 0.5
				docker cp backup_files/userapps $container_name:/flyt
				[ -f backup_files/scripts/lic_data.txt ] && docker cp backup_files/scripts/lic_data.txt $container_name:/flyt/flytos/flytcore/share/core_api/scripts/lic_data.txt
				[ -f backup_files/scripts/hwid ] && docker cp backup_files/scripts/hwid $container_name:/flyt/flytos/flytcore/share/core_api/scripts/hwid
				rm -r backup_files
				docker-compose stop
				docker-compose up
				break
			fi
			sleep 0.5
		done
	fi
}

docker_start() {
	cd $root_loc
	docker ps | grep $container_name > /dev/null

	if [ $? -eq 0 ]
		then
		docker-compose stop
	fi
	docker-compose up

	if [ $? -ne 0 ]
		then
		echo -e "${RED}ERROR${NC}: Problem encountered. Could not start Flytsim session. Exiting ...${NC}"
		exit 1
	fi
}

launch_flytsim() {
	is_installed_and_running
	do_image_pull
	allow_xhost
	open_browser &
	push_backup_files &
	docker_start
}

root_loc=$(cd $(dirname $BASH_SOURCE) ; pwd -P)
is_new_img=0
image_name=`grep image docker-compose.yml | awk -F ' ' '{print $2}'`
container_name=`grep container_name docker-compose.yml | awk -F ' ' '{print $2}'`

launch_flytsim
