$host.ui.RawUI.WindowTitle = “Stop FlytSim”
write-host ("`nThis script is going to stop FlytSim session for you.") -ForegroundColor Green

cd $PSScriptRoot
docker-compose stop

if ($? -ne "True")
{
    write-host ("`n`nERROR: FlytSim session could not be stopped.") -ForegroundColor Red
    pause
    exit
}
