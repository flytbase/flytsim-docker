$host.ui.RawUI.WindowTitle = “ssh FlytSim”
write-host ("`nThis script is going to start a ssh session into the container in which FlytSim is running")  -foreground green

docker exec -it flytsim bash
