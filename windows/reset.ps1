$host.ui.RawUI.WindowTitle = “Reset FlytSim”
write-host ("`nCAUTION: This script is going to reset FlytSim's container to factory default. This would delete all of your files present inside the container.") -ForegroundColor Cyan

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

$continue = Read-Host -Prompt 'Do you still want to continue? [y/N]'

if (($continue -eq 'y') -or ($continue -eq 'Y')) 
{
    cd $PSScriptRoot
    $container_name=$((get-content $PSScriptRoot\docker-compose.yml) | where {$_ -match 'container_name.+$' }).Trim().Split(" ")[1]

    if ( docker ps | where {$_ -match $container_name} )
    {
        docker-compose stop 
        docker rm -f $container_name
        if ($? -ne "True"){
            Write-Host("`nError: Problem encountered. Could not remove Flytsim container. Exiting ...") -ForegroundColor Red
            pause
            exit
        }
    }
    elseif ( docker ps -a | where {$_ -match $container_name} )
    {
        docker rm $container_name
        if ($? -ne "True"){
            Write-Host("`nError: Problem encountered. Could not remove Flytsim container. Exiting ...") -ForegroundColor Red
            pause
            exit
        }
    }
    else
    {
        write-host ("`nERROR: It seems there is no container named $container_name to remove. Trigger start.ps1 script to start FlytSim...Exiting...`n") -ForegroundColor Red
        pause
        exit
    }
    Write-Host ("`nFlytSim container successfully deleted, trigger start.ps1 to start FlytSim...`n") -ForegroundColor Green
    pause
}
else
{
    write-host ("`n`nERROR: Script aborted by user. Exiting...") -ForegroundColor Red
    pause
    exit
}
