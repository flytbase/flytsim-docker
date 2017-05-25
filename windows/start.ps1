$host.ui.RawUI.WindowTitle = “Start FlytSim”
write-host ("`nThis script is going to start FlytSim session for you.")  -foreground green
write-host ("`nVisit http://localhost/flytconsole in your browser to check connectivity with FlytSim`n`n")  -foreground cyan

$localip = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | out-null; $Matches[1])
(get-content $PSScriptRoot\docker-compose.yml) | foreach-object {$_ -replace "DISPLAY.+$", ("DISPLAY="+$localip+":1.0")} | set-content $PSScriptRoot\docker-compose.yml

cd $PSScriptRoot

if (-Not (Get-Command "docker" -errorAction SilentlyContinue))
{
    Write-Host("Docker NOT found. Please install docker in your machine. Exiting ...") -ForegroundColor Red
    pause
    exit
}

if (-Not (Get-Command "xming" -errorAction SilentlyContinue))
{
    Write-Host("Xming NOT found. Please run setup script. Xming is required to get FlytSIM GUI. Ignore this warning if you don't want GUI") -ForegroundColor Red
    $quit = Read-Host -Prompt 'Do you want to quit and execute setup script? [yN]'
    if (($quit -eq 'y') -or ($quit -eq 'Y')) {exit}
}
else
{
    xming :1 -ac -multiwindow
}

docker-compose stop
docker-compose up