cd $PSScriptRoot


write-host ("`nWelcome to FlytSIM setup utility.")  -foreground green
write-host ("`nThis utility assumes that you already have installed ") -NoNewline
write-host ("docker-for-windows") -foreground cyan -NoNewline
write-host (" or ") -NoNewline
write-host ("docker toolbox") -foreground cyan -NoNewline
" in your machine."

$windowsversion = $((Get-WmiObject -class Win32_OperatingSystem).Caption)
if ($windowsversion -eq "Microsoft Windows 10 Home")
{
    Write-Host("`nError: Microsoft Windows 10 Home detected,") -ForegroundColor Red
    Write-Host("Sorry FlytSim is not supported for this version of Windows yet. Upgrade to Windows 10 PRO. Exiting ...`n`n") -ForegroundColor Cyan
    pause
    exit
}
elseif ($windowsversion -match "Microsoft Windows 10")
{
    "`nChecking if Docker is installed or not ..." 

    if (Get-Command "docker" -errorAction SilentlyContinue)
    {
        "Docker detected with version: $((docker version | where {$_ -match '^ Version:'}).split(`"`n`")[0] -replace ' ' -replace 'Version:'). Continuing with setup ..."
    }
    else
    {
        "Sorry! docker installation could not be detected. Are you sure it has been installed correctly?"
        $quit = Read-Host -Prompt 'Do you want to cancel this setup and install docker first? [y/N]'
        if (($quit -eq 'y') -or ($quit -eq 'Y')) {exit}
    }
}
else 
{
    Write-Host("`nError: $windowsversion detected,") -ForegroundColor Red
    Write-Host("Sorry FlytSim is not supported for this version of Windows yet. Upgrade to Windows 10 PRO. Exiting ...`n`n") -ForegroundColor Cyan
    pause
    exit
}

"`nChecking if Xming is installed or not ..." 

if (Get-Command "xming" -errorAction SilentlyContinue)
{
    "Xming is already installed. Continuing with setup ..."
}
else
{
    write-host ("`nInstalling Xming Xserver for FlytSIM GUI") -foreground cyan
    write-host ("No need to change any default installation configuration") -foreground magenta
    pause

    write-host ("`nIf you don't get back access to shell, kindly exit Xming from system tray") -foreground cyan
    $process = (Start-Process '.\Xming-6-9-0-31-setup.exe' -Wait -PassThru -ErrorAction SilentlyContinue)

    if($process.ExitCode -ne 0)
    {
        Write-Host("`n`nXming installation FAILED/CANCELLED. Rendering of FlytSim's GUI is not possible without Xming`n") -ForegroundColor Red
        $quit = Read-Host -Prompt 'Have you already installed Xming before? [Y/n]'
        if (($quit -eq 'n') -or ($quit -eq 'N')) 
        {
            Write-Host("`n`nPlease install Xming, by running this script again. exiting...`n") -ForegroundColor Red
            pause
            exit
        }
    }

    if (Test-Path "C:\Program Files (x86)\Xming\Xming.exe" -PathType Leaf)
    {
        $xmingpath = "C:\Program Files (x86)\Xming"
    }
    else
    {
        Write-Host ("`n`nSorry Xming could NOT be detected in the default installation path : C:\Program Files (x86)\Xming") -ForegroundColor Red
        $xmingpath = Read-Host -Prompt 'Please provide current installation path'
        "Trying to locate Xming in the user provided path: $xmingpath ..."
        if (-Not(Test-Path $xmingpath"\Xming.exe" -PathType Leaf))
        {
            Write-Host("Xming NOT found at: $xmingpath\Xming.exe. This setup would exit now. Try running it again.`n") -ForegroundColor Red
            pause
            exit
        }
    }

    if (-Not (Get-Command "xming" -errorAction SilentlyContinue))
    {
        "`nAdding Xming to PATH"
        $syspath = [System.Environment]::GetEnvironmentVariable("PATH","USER")
        setx PATH "$syspath;$xmingpath" | Out-Null
    }
}

Write-Host("`nCongratulations! FlytSim setup is now complete. Now trigger start.ps1 script to start FlytSim...`n") -ForegroundColor Green
pause