#!/bin/bash 

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${GRN}\nThis script is going to start FlytSim session for you\n${NC}"

if [[ "$EUID" -ne 0 ]]; then
	echo -e "${RED}ERROR${NC}: This script must be run as root, ${YLW}run with sudo ./start.sh, ${NC}exiting ...${NC}" 
	exit 1
fi

is_installed_and_running() {
	echo -e "${YLW}Detecting if docker and docker-compose are already installed in this machine${NC}"
	if [ ! $(command -v docker) > /dev/null ]; then echo -e "${RED}ERROR${NC}: docker does not seem to be installed. ${YLW}Please install Docker for Mac, ${NC}before running this script${NC}";exit 1;fi
	if [ ! $(command -v docker-compose) > /dev/null ]; then echo -e "${RED}ERROR${NC}: docker-compose does not seem to be installed. ${YLW}Please run ./setup.sh, ${NC}before running this script${NC}";exit 1;fi
	if ! pgrep com.docker.slirp > /dev/null; then echo -e "${RED}ERROR${NC}: docker does not seem to be running, has it been installed correctly? ${YLW}Try rebooting your machine or start docker from GUI${NC} before running this script${NC}";exit 1;fi
}

close_ports() {
	echo -e "${YLW}Closing processes binded to ports (80,8080,5760,9000)${NC}"
	pids=`echo $(lsof -t -iTCP:80 -sTCP:LISTEN)`
	[ "$pids" != "" ] && [ "$(ps -p "$pids" -o comm=)" != "com.docker.slirp" ] && kill -9 $pids
	pids=`echo $(lsof -t -iTCP:8080 -sTCP:LISTEN)`
	[ "$pids" != "" ] && [ "$(ps -p "$pids" -o comm=)" != "com.docker.slirp" ] && kill -9 $pids
	pids=`echo $(lsof -t -iTCP:5760 -sTCP:LISTEN)`
	[ "$pids" != "" ] && [ "$(ps -p "$pids" -o comm=)" != "com.docker.slirp" ] && kill -9 $pids
	pids=`echo $(lsof -t -iTCP:9000 -sTCP:LISTEN)`
	[ "$pids" != "" ] && [ "$(ps -p "$pids" -o comm=)" != "com.docker.slirp" ] && kill -9 $pids
}

do_image_pull() {
	cd $root_loc
	echo -e "${YLW}Downloading new container image from server, if available${NC}"
	img_sha=$(docker images --format "{{.ID}}" $image_name)
	docker pull $image_name

	img_new_sha=$(docker images --format "{{.ID}}" $image_name)
	if [ ! -z "$img_sha" ] && [ "$img_sha" != "$img_new_sha" ]
		then
		if docker ps -a | grep $container_name > /dev/null
			then
			echo -e "${YLW}\nContainer image updated, backing up user container in $(echo $image_name | awk -F ':' '{print $1}'):backup${NC}"
			docker-compose stop
			docker commit -m "backing up user data on $(date)" $container_name $(echo $image_name | awk -F ':' '{print $1}'):backup
			docker rm $container_name
		fi
	fi
}

open_browser() {
	#sleep as system takes up time to start up
	sleep 10
	while true
	do
		if docker ps | grep $container_name > /dev/null
		then
			sleep 30
			#starting up flytconsole in browser
			{ open -a Google\ Chrome.app "http://localhost/flytconsole" && break; } || { open -a Safari.app "http://localhost/flytconsole" && break; }
			echo -e "${RED}ERROR${NC}: Could not open any browser. Please open 'http://localhost/flytconsole' in your favorite browser"
			break
		fi
		sleep 1
	done
}

docker_start() {
	cd $root_loc
	UUID=`system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }'`
	docker ps | grep $container_name > /dev/null

	if [ $? -eq 0 ]
	then
		docker exec --user root $container_name bash -c "echo $UUID > /flyt/flytos/flytcore/share/core_api/scripts/hwid"
		docker-compose stop
	else
		close_ports
		docker-compose up -d
		docker exec --user root $container_name bash -c "echo $UUID > /flyt/flytos/flytcore/share/core_api/scripts/hwid"
		docker-compose stop -t 3
	fi
	
	docker-compose up
	
	if [ $? -ne 0 ]
		then
		echo -e "${RED}ERROR${NC}: Problem encountered. Could not start Flytsim session. Exiting ...${NC}"
		exit 1
	fi
}

launch_flytsim() {
	# is_installed_and_running
	do_image_pull
	open_browser > /dev/null 2>&1 &
	docker_start
}

root_loc=$(cd $(dirname $BASH_SOURCE) ; pwd -P)
cd $root_loc

image_name=`grep image docker-compose.yml | awk -F ' ' '{print $2}'`
container_name=`grep container_name docker-compose.yml | awk -F ' ' '{print $2}' | tr -d "\r"`

launch_flytsim
