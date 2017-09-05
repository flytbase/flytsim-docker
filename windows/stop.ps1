$host.ui.RawUI.WindowTitle = “Stop FlytSim”
write-host ("`nThis script is going to stop FlytSim session for you.") -ForegroundColor Green

cd $PSScriptRoot

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

$container_name=$((get-content $PSScriptRoot\docker-compose.yml) | where {$_ -match 'container_name.+$' }).Trim().Split(" ")[1]

if ( docker ps | where {$_ -match $container_name} )
{
    docker-compose stop -t 30
    if ($? -ne "True"){
        Write-Host("`nError: Problem encountered. Could not stop Flytsim container. Exiting ...") -ForegroundColor Red
        pause
        exit
    }
}
elseif ( docker ps -a | where {$_ -match $container_name} )
{
    Write-Host("`nWARNING: $container_name was already stopped. Exiting...") -ForegroundColor Cyan
    pause
    exit
}
else
{
    write-host ("`nERROR: It seems there is no container named $container_name to stop. Trigger start.ps1 script to start FlytSim...Exiting...`n") -ForegroundColor Red
    pause
    exit
}

if ($? -ne "True")
{
    write-host ("`n`nERROR: FlytSim session could not be stopped.") -ForegroundColor Red
    pause
    exit
}
