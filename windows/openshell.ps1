$host.ui.RawUI.WindowTitle = “Openshell FlytSim”
write-host ("`nThis script is going to open a bash shell into the docker container in which FlytSim is running") -ForegroundColor Green

if (-Not (Get-Command "docker" -errorAction SilentlyContinue))
{
    Write-Host("`nError: Docker NOT found. Please install docker in your machine. Exiting ...") -ForegroundColor Red
    pause
    exit
}

Get-Process "docker for windows" -ErrorAction SilentlyContinue | Out-Null
if ($? -ne "True"){
    Write-Host("`nError: Docker daemon does not seem to be running. Please restart docker in your machine. Exiting ...") -ForegroundColor Red
    pause
    exit
}

$container_name = $((get-content $PSScriptRoot\docker-compose.yml) | where {$_ -match 'container_name.+$' }).Trim().Split(" ")[1]

if ( docker ps | where {$_ -match $container_name} )
{
	docker exec -it $container_name bash
	if ( $LASTEXITCODE -eq "1" ){
		Write-Host("`nERROR: Problem encountered. Shell inside Flytsim's container could not be accessed. Try executing ./start.ps1 again.") -ForegroundColor Red
		pause
        exit
	}
}
else
{
	if ( docker ps -a | where {$_ -match $container_name} ){
		Write-Host("`nERROR: $container_name was found to be in 'stopped' state. Please execute ./start.ps1 again.") -ForegroundColor Red
		pause
        exit
    }
	else{
		Write-Host("`nERROR: It seems there is no container named $container_name to get into. Trigger ./start.ps1 script to start FlytSim. Exiting ...") -ForegroundColor Red
		pause
        exit
	}
}
