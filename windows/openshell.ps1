$host.ui.RawUI.WindowTitle = “Openshell FlytSim”
write-host ("`nThis script is going to open a bash shell into the docker container in which FlytSim is running") -ForegroundColor Green

if (-Not (Get-Command "docker" -errorAction SilentlyContinue))
{
    Write-Host("`nError: Docker NOT found. Please install docker in your machine. Exiting ...") -ForegroundColor Red
    pause
    exit
}

$container_name = $((get-content $PSScriptRoot\docker-compose.yml) | where {$_ -match 'container_name.+$' }).Trim().Split(" ")[1]

docker exec -it $container_name bash

if ($LASTEXITCODE -eq "1")
{
    write-host ("`n`nERROR: Shell inside Flytsim's container could not be accessed. Is flytsim running? Try executing start.ps1 first.") -ForegroundColor Red
    pause
    exit
}
