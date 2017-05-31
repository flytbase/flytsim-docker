#!/bin/bash 

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${GRN}\nThis script is going to start FlytSim session for you\n${NC}"

if [[ $EUID -ne 0 ]]; then
	echo -e "${RED}ERROR${NC}: This script must be run as root, ${YLW}run with sudo ./start.sh, ${NC}exiting ...${NC}" 
	exit 1
fi

is_installed_and_running() {
	echo -e "${YLW}Detecting if docker, docker-compose, nvidia-docker, nvidia-docker-compose are already installed in this machine${NC}"
	if [ ! $(command -v docker) > /dev/null ]; then echo -e "${RED}ERROR${NC}: docker does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
	if [ ! $(command -v docker-compose) > /dev/null ]; then echo -e "${RED}ERROR${NC}: docker-compose does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
	if [ ! $(command -v nvidia-docker) > /dev/null ]; then echo -e "${RED}ERROR${NC}: nvidia-docker does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
	if [ ! $(command -v nvidia-docker-compose) > /dev/null ]; then echo -e "${RED}ERROR${NC}: nvidia-docker-compose does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
	if ! pgrep dockerd > /dev/null; then echo -e "${RED}ERROR${NC}: docker does not seem to be running, has it been installed correctly, try rebooting your machine? ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
}

create_volume() {
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
}

close_ports() {
	echo -e "${YLW}Closing processes binded to ports (80,8080,14550)${NC}"
	pids=`echo $(lsof -t -i tcp:80 -s tcp:listen)`
	[ "$pids" != "" ] && kill -9 $pids
	pids=`echo $(lsof -t -i tcp:8080 -s tcp:listen)`
	[ "$pids" != "" ] && kill -9 $pids
	pids=`echo $(lsof -t -i :14550)`
	[ "$pids" != "" ] && kill -9 $pids
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
	sleep 10
	while true
	do
		if pgrep flytlaunch > /dev/null
			then
			sleep 20
			#starting up flytconsole in browser 
			[ $(command -v firefox) > /dev/null ] && su -c 'firefox "http://localhost/flytconsole"' $SUDO_USER && break
			[ $(command -v google-chrome) > /dev/null ] && su -c 'google-chrome "http://localhost/flytconsole"' $SUDO_USER && break
			[ $(command -v chromium-browser) > /dev/null ] && su -c 'chromium-browser "http://localhost/flytconsole"' $SUDO_USER && break
			echo -e "${RED}ERROR${NC}: Could not open any browser. Please open 'http://localhost/flytconsole' in your favorite browser"
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
		nvidia-docker-compose stop
	fi
	
	echo -e "\n\n${GRN}Launching FlytSim now in a new window.\n\n${NC}"
	[ $(command -v gnome-terminal) > /dev/null ] && { gnome-terminal -e '/bin/bash -c "nvidia-docker-compose up || { echo -e \"\n\n\033[0;31mERROR\033[0m: Problem encountered. Could not start Flytsim session\";exec /bin/bash -i;} "'; exit 1; }
	[ $(command -v x-terminal-emulator) > /dev/null ] && { x-terminal-emulator -e '/bin/bash -c "nvidia-docker-compose up || { echo -e \"\n\n\033[0;31mERROR\033[0m: Problem encountered. Could not start Flytsim session\";exec /bin/bash -i;}"' & { exit 1; }; }
	[ $(command -v xterm) > /dev/null ] && { xterm -e '/bin/bash -c "nvidia-docker-compose up || { echo -e \"\n\n\033[0;31mERROR\033[0m: Problem encountered. Could not start Flytsim session\";exec /bin/bash -i;}"' & { exit 1; }; }
	nvidia-docker-compose up || { echo -e "\n\n${RED}ERROR${NC}: Problem encountered. Could not start Flytsim session. Exiting ..." && exit 1; }
}

launch_flytsim() {
	is_installed_and_running
	create_volume
	close_ports
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
