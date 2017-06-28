#!/bin/bash -e
# --
# Add -ex for Debugging
# Script to install FlytSim and its dependencies.
# This script needs to be run as root.
# --

#shell color descriptions
YLW='\033[1;33m'
RED='\033[0;31m'
GRN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${GRN}This script shall install FlytSim and its dependencies. \nPlease note that your system shall reboot on successful installation.${NC}" 
echo Logging at $HOME/flytsim_installation_log.txt

exec > >(tee -i $HOME/flytsim_installation_log.txt)
exec 2>&1

if [ "$EUID" -ne 0 ]
  then echo -e "${RED}\nPlease run as root, sudo ./flytSim_installation.sh ${NC}"
  echo -e "${RED}Exiting..."
  exit 1
fi

#Query Operating System Version for Ubuntu 16.04
if [[ $(lsb_release -sc) = "xenial" ]]; then
  echo "Found Ubuntu 16.04"
else
    echo -e "${RED}Please use Ubuntu 16.04 ${NC}"    
    echo -e "${RED}Exiting..."
    exit 1
fi

if [ $(uname -m) != "amd64" ] && [ $(uname -m) != "x86_64" ]; then
    echo -e "${RED}FlytSim can only be installed on a 64-bit system ${NC}"    
    echo -e "${RED}Exiting..."
    exit 1
fi    


#Check if pre-FlytSim installed
if [[ $(sudo dpkg-query -l | grep "flytsim " | wc -l) = "0" ]]; then
  echo ""
else
    dpkg -r flytsim
    cp -r /flyt /flyt_bak
    rm -rf /flyt
fi

#Check if FlytSim installed
if [[ $(sudo dpkg-query -l | grep flytsim-pe | wc -l) = "0" ]]; then
  echo ""
else
    echo -e "${RED}FlytSim already installed ${NC}"
    echo -e "Removing FlytSim before continuing"
    dpkg -r flytsim-pe
fi

#Setup your computer to accept software from packages.ros.org and Setup Keys
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 || ( echo -e "${RED}Are You Connected to the Internet? \n Exiting ${NC}" ; exit 1 )

#ROS Kinetic Installation
apt-get update || echo -e "${RED}Please reboot your system and try again ${NC}"

apt-get install ros-kinetic-desktop-full -y || (echo -e "${RED}Error Installing ROS, Please Try Again \n Exiting ${NC}" ; exit 1)

#Check if rosdep has been initialized earlier
ros_init_file="/etc/ros/rosdep/sources.list.d/20-default.list"

if [ ! -f "$ros_init_file" ]; then
    echo "rosdep not initialized"
    rosdep init
else
    echo "rosdep already initialized"    
fi

# Running rosdep update as root is not recommended
su -c 'rosdep update' $SUDO_USER

#installing known python dependencies
apt-get install -y python-pip python-serial python-flask python-wtforms python-sqlalchemy python-concurrent.futures python-mock python-zmq python-twisted python-future
pip install flask_cors flask_reverse_proxy flask_restful tblib webargs click flask_security httplib2 simple_json pyzmp pyros-setup requests tornado

#installing known ros dependencies
apt-get install -y ros-kinetic-image-proc ros-kinetic-image-transport-plugins ros-kinetic-image-transport ros-kinetic-rosbridge-suite ros-kinetic-control-toolbox ros-kinetic-eigen-conversions ros-kinetic-camera-info-manager ros-kinetic-pyros-utils libxslt-dev libxml2-dev

#installing other dependencies
apt-get install -y v4l2loopback-utils locate lsof minicom libglib2.0-dev gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly ethtool curl
pip install certifi pyserial pymavlink


# To prevent repeated sourcing
sed -i '/source \/opt\/ros\/kinetic\/setup.bash/d' /etc/bash.bashrc
sed -i '/export PYTHONPATH=$PYTHONPATH:\/flyt\/flytapps:\/flyt\/userapps/d' /etc/bash.bashrc
sed -i '/source \/flyt\/flytos\/flytcore\/setup.bash/d' /etc/bash.bashrc
sed -i '/source \/flyt\/flytos\/flytcore\/share\/sitl_gazebo\/setup.sh/d' /etc/bash.bashrc
sed -i '/export CPATH=$CPATH:\/opt\/ros\/kinetic\/include/d' /etc/bash.bashrc
sed -i '/alias launch_flytSim="sudo $(rospack find core_api)\/scripts\/launch_flytSim.sh"/d' /etc/bash.bashrc
sed -i '/alias stop_flytSim="sudo $(rospack find core_api)\/scripts\/stop_flytSim.sh"/d' /etc/bash.bashrc

#Add Sourcing
echo "source /opt/ros/kinetic/setup.bash" >> /etc/bash.bashrc
echo 'export PYTHONPATH=$PYTHONPATH:/flyt/flytapps:/flyt/userapps' >> /etc/bash.bashrc
echo "source /flyt/flytos/flytcore/setup.bash" >> /etc/bash.bashrc
echo "source /flyt/flytos/flytcore/share/sitl_gazebo/setup.sh" >> /etc/bash.bashrc
echo 'export CPATH=$CPATH:/opt/ros/kinetic/include' >> /etc/bash.bashrc

#Alias for start and stop
echo 'alias launch_flytSim="sudo $(rospack find core_api)/scripts/launch_flytSim.sh"' >> /etc/bash.bashrc
echo 'alias stop_flytSim="sudo $(rospack find core_api)/scripts/stop_flytSim.sh"' >> /etc/bash.bashrc

#Prevent clash in sourcing with local bashrc
sed -i 's#source /opt/ros/kinetic/setup.bash##g' $HOME/.bashrc

url=$(curl -sS https://my.flytbase.com/api/downloads/latest/FlytSIM/) || (echo -e "${RED}Unable to get flytsim debian package. Are you connected to the internet? \n Exiting ${NC}" ; exit 1)
deblink=$(echo $url | python -c "import sys, json; print json.load(sys.stdin)['link']")
md5hash=$(echo $url | python -c "import sys, json; print json.load(sys.stdin)['md5hash']")

wget --tries=3 -O $HOME/flytsim.deb $deblink

# Check md5sum of downloaded file, continue if match, retry if fail, quit on another fail.
if [ $(md5sum $HOME/flytsim.deb | awk -F ' ' '{print $1}') = $md5hash ]; then
    echo "md5sum match, continuing with installation"
else
    echo -e "${RED}md5sum match: FAIL ${NC}"
    echo "Redownloading FlytOS package"
    rm $HOME/flytsim.deb
    wget --tries=3 -O $HOME/flytsim.deb $deblink
    if [ $(md5sum $HOME/flytsim.deb | awk -F ' ' '{print $1}') = $md5hash ]; then
        echo "MD5sum match, continuing"
    else
        echo -e "${RED}Problem downloading FlytOS debian package, please check internet connection and try again. ${NC}"
        echo -e "${RED}Exiting..."
        exit 1
    fi
fi

# In case there is an issue with installing flytos, second option
apt-get install -y $HOME/flytsim.deb || (apt-get -f -y install ; apt-get install -y $HOME/flytsim.deb)

echo "Your System Will Reboot in 10 seconds"
echo "Clearing Up Installation Files"
rm $HOME/flytsim.deb || echo -e "${RED}Unable to remove downloaded flytos debian package. please remove manually${NC}"

sleep 10
reboot
