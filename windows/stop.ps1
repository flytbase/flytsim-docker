$host.ui.RawUI.WindowTitle = “Stop FlytSim”
write-host ("`nThis script is going to stop FlytSim session for you.")  -foreground green

cd $PSScriptRoot
docker-compose stop
