# flytsim-docker
[WIP] dockerization of FlytSIM, for easy deployment to linux, windows and mac

1. Install docker on your machine by following [docker's installation guide](https://docs.docker.com/engine/installation/)
2. Once installed, docker daemon would start automatically.
3. Clone this repository, and go inside the relevant folder according to your local machine.
4. Run this command ``docker-compose up -d``
5. FlytSIM would launch itself inside a docker container named 'flytsim'.
6. To view logs, run this command ``docker-compose logs``. But make sure you are in the same directory from which you had run command 4.
7. Visit http://localhost in your browser, and check if you can connect to FlytSIM or not.
8. To get the Gazebo 3D GUI follow these steps:
    * Linux 
      1. run this command in terminal ``xhost +local:root``. 
      2. Once done restart Flytsim by running this command: ``docker-compose restart``
    
    * Windows 
      1. install xming xserver for windows, and launch it using GUI or via powershell : ``xming :0 -ac -clipboard -multiwindow``
      2. Once done restart Flytsim by running this command: ``docker-compose restart``
              
    * Mac [untested] 
      1. Run the following commands:
      ```shell
      brew install socat
      brew cask install xquartz
      open -a XQuartz
      socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
      ```
      2. Once done restart Flytsim by running this command: ``docker-compose restart``
