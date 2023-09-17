$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
$env:WSL_UTF8 = 1
# WSLENV="$WSLENV":WSL_UTF8

$global:devel_tools = 'sourced'
function include_devel_spawn {
    try {
        set_kindtek_envs $env:KINDTEK_DEBUG_MODE
        if ($global:devel_spawn -ne 'sourced') {
            throw
        }
    }
    catch {
        if ((Test-Path -Path "${USERPROFILE}/dvlp.ps1" -PathType Leaf)) {
            # write-output "dvltls 11: dot sourcing dvlp"
            . ${USERPROFILE}/dvlp.ps1
            $global:devel_spawn = 'sourced'
            echo 'devel_spawn sourced'
        }
        elseif ((!([string]::IsNullOrEmpty($env:KINDTEK_DEVEL_SPAWN))) -And (Test-Path -Path "$env:KINDTEK_DEVEL_SPAWN" -PathType Leaf)) {
            # write-output "dvltls 8: dot sourcing devel-spawn"
            . $env:KINDTEK_DEVEL_SPAWN
            $global:devel_spawn = 'sourced'
            # echo 'devel_spawn sourced'
        }  
    }
}

. include_devel_spawn

function reboot_prompt_embedded {
    # use to allow cancelling reboot without cancelling script that called reboot_prompt
    param (
        $skip_prompt
    )
    if ($skip_prompt -ieq "reboot now" -or $skip_prompt -ieq "reboot continue" -or $skip_prompt -ieq "reboot" ) {
        $confirmation = $skip_prompt
    }
    start_kindtek_process_embed "reboot_prompt $($confirmation)"
}
function reboot_prompt {
    param (
        $skip_prompt
    )
    if ($skip_prompt -ieq "reboot now" -or $skip_prompt -ieq "reboot continue" -or $skip_prompt -ieq "reboot" ) {
        $confirmation = $skip_prompt
    }
    else {
        $confirmation = Read-Host "`r`nType 'reboot'`r`n`t ..or hit ENTER to skip" 
    }

    if ($confirmation -ieq 'reboot') {
        $confirmation = Read-Host "`r`nType 'continue' to automatically continue after next boot`r`n`t ..or hit ENTER to reboot normally" 
        if ($confirmation -eq 'continue') {
            $confirmation = 'reboot continue'
        }
        else {
            $confirmation = 'reboot now'
        }
    } 
    if ($confirmation -ieq 'reboot now' -or $confirmation -ieq 'reboot continue') {
        if ($confirmation -ieq 'reboot now') {
            Write-Host "`r`nrestarting computer ... `r`n"
        }
        elseif ($confirmation -ieq 'reboot continue') {
            Write-Host "please confirm admin access when prompted following restart" -ForegroundColor Magenta -BackgroundColor Yellow
            Start-Sleep 2
            Write-Host "`t... otherwise use [WIN + x], [a] and hit the up arrow key"
            Start-Sleep 5
            Write-Host "`r`n`r`n       --- USE CTRL + C TO CANCEL --- `r`n`r`n" -ForegroundColor Magenta -BackgroundColor Yellow
            start-sleep 1
            Write-Host "`r`nrestarting computer and continuing after restart... `r`n`r`n" -ForegroundColor Magenta -BackgroundColor Yellow
            start_countdown_3210_liftoff "restarting " "in 3" "in 2" "in 1" "now"
            if (!(Test-Path "$env:TEMP\spawnlogs.txt" -PathType Leaf)) {
                New-Item "$env:TEMP\spawnlogs.txt" -Value ''
            }
            Invoke-RestMethod 'https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1' -OutFile "$env:USERPROFILE/dvlp.ps1";
            set_kindtek_auto_boot $true
        }

        # Restart-Computer
        Restart-Computer
        exit
    } 
    
    # else {
    #     # powershell.exe -Command "$env:KINDTEK_WIN_DVLW_PATH\choco\src\chocolatey.resources\redirects\RefreshEnv.cmd"
    #     Write-Host "`r`n"
    # }
}

function install_windows_features {
    param (
        $skipreboot
    )
    if (!([string]::IsNullOrEmpty($skipreboot))) {
        $skipreboot = 'skip'
    }
    if ((!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.windows-installed" -PathType Leaf)) -Or $install_anyways -eq 'true') {
        ."$env:KINDTEK_WIN_DVLADV_PATH/add-windows-features.ps1" "$skipreboot"
    }
    return
}

function uninstall_windows_features {
    param (
        $skipreboot
    )
    if ([string]::IsNullOrEmpty($skipreboot)) {
        Start-Process powershell.exe -Wait -ArgumentList "-File $env:KINDTEK_WIN_DVLADV_PATH/del-windows-features.ps1"
    }
    else {
        Start-Process powershell.exe -Wait -ArgumentList "-File $env:KINDTEK_WIN_DVLADV_PATH/del-windows-features.ps1", "skip"
    }

    Remove-Item "$env:KINDTEK_WIN_GIT_PATH/.windowsfeatures-installed" -Force -ErrorAction SilentlyContinue
    return
}

function install_docker {
    param (
        $install_anyways
    )
    $software_name = "Docker Desktop"
    $new_install = $false

    try {
        if ((!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.docker-installed" -PathType Leaf)) -or $install_anyways) {
            # Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
            # winget uninstall --id=Docker.DockerDesktop
            # winget install --id=Docker.DockerDesktop --source winget --location="c:\docker" --silent --locale en-US --accept-package-agreements --accept-source-agreements
            # winget upgrade --id=Docker.DockerDesktop --source winget --location="c:\docker" --silent --locale en-US --accept-package-agreements --accept-source-agreements
            # update using rolling stable url
            # Write-Host "Downloading/installing basic version of $software_name ..." -ForegroundColor DarkCyan
            # start_kindtek_process_pop "write-host 'Downloading/installing basic version of $software_name ...';winget install --id=Docker.DockerDesktop --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --id=Docker.DockerDesktop --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements" '' 'noexit'
            Write-Host "Downloading/installing updated version of $software_name ..." -ForegroundColor DarkCyan
            write-host -NoNewLine "confirm docker desktop installer actions" -ForegroundColor Yellow
            start_kindtek_process_pop "
            write-host 'downloading/installing $software_name ...';
            write-host '';
            write-host '';
            write-host '';
            write-host '';
            write-host '';
            write-host '';
            write-host -NoNewLine 'confirm docker desktop installer actions';
            write-host '';
            write-host -NoNewLine 'once docker is installed hit the ' -ForegroundColor Yellow;
            write-host -NoNewline 'blue' -ForegroundColor Blue;
            write-host -NoNewline ' close button to continue' -ForegroundColor Yellow;
            write-host '';

            try {
                .`$env:USERPROFILE\DockerDesktopInstaller.exe | Out-Null;
                Write-Host '$software_name installed' -ForegroundColor DarkCyan | Out-File -FilePath '$env:KINDTEK_WIN_GIT_PATH/.docker-installed';
            } catch {
                try {
                    Invoke-RestMethod -Uri https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe -OutFile `"`$env:USERPROFILE\DockerDesktopInstaller.exe`" | Out-Null;
                    .`$env:USERPROFILE\DockerDesktopInstaller.exe | Out-Null;
                    Write-Host '$software_name installed' -ForegroundColor DarkCyan | Out-File -FilePath '$env:KINDTEK_WIN_GIT_PATH/.docker-installed';
                } catch {}
            }
            exit;" 'wait'

            # & 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
            # "Docker Desktop Installer.exe" install --accept-license --backend=wsl-2 --installation-dir=c:\docker 
            $new_install = $true
        }
        else {
            Write-Host "$software_name already installed"  -ForegroundColor DarkCyan 
        }
    }
    catch {
        Write-Host "error installing $software_name" -ForegroundColor DarkCyan
    }
    
    return $new_install

}

function uninstall_docker {
    Write-Host "please wait while docker is uninstalled"
    start-sleep 2
    # docker builder prune -af 
    # docker system prune -af --volumes 
    Start-Process powershell.exe -Wait -Argumentlist '-Command', 'write-host "uninstalling docker... ";winget uninstall --id=Docker.DockerDesktop;' | Out-Null 
    Remove-Item "$env:APPDATA\Docker*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Docker*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE\.docker" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
    Remove-Item "$env:PROGRAMDATA\Docker*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE/repos/kindtek/.docker-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
    wsl.exe --unregister docker-desktop | Out-Null
    wsl.exe --unregister docker-desktop-data | Out-Null
}

function reinstall_docker {
    uninstall_docker
    install_docker
}

function dependencies_installed {
    param (
        $verbose_output
    )
    if ((!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.docker-installed" -PathType Leaf)) -Or (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.github-installed" -PathType Leaf)) -Or (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.winget-installed" -PathType Leaf)) -Or (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.windowsfeatures-installed" -PathType Leaf))) {
        if ($verbose_output) {
            if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.windowsfeatures-installed" -PathType Leaf)) {
                Write-Host "windows features not installed"
            }
            if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.winget-installed" -PathType Leaf)) {
                Write-Host "winget not installed"
            }
            if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.github-installed" -PathType Leaf)) {
                Write-Host "git not installed"
            }
            if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.docker-installed" -PathType Leaf)) {
                Write-Host "docker not installed"
            }
        }
        return $false
    }
    else {
        return $true
    }
}
function install_dependencies {
    param (
        $install_anyways
    )
    # if dependencies not makred installed return true only if a dependency was actually newly installed
    if ($(dependencies_installed) -eq $true) {
        return
    }
    
    Write-Host "`r`nThe following program will be installed or updated`r`n`t- Docker Desktop`r`n`t" -ForegroundColor Magenta
    Start-Sleep 3
    if ((!(Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH")) -or $install_anyways) {
        New-Item -ItemType Directory -Force -Path "$env:KINDTEK_WIN_DVLW_PATH" | Out-Null
    }
    else {
        New-Item -ItemType Directory -Force -Path "$env:USERPROFILE/repos/kindtek" | Out-Null
    }

    # save docker for last then wait for docker to be installed
    return $(install_docker $install_anyways)
    # this is used for x11 / gui stuff .. @TODO: add the option one day maybe
    # choco install vcxsrv microsoft-windows-terminal wsl.exe -y
    
}

function install_vscode {
    param (
        $install_anyways
    )
    $software_name = "Visual Studio Code (VSCode)"
    $new_install = $false

    try {        
        if ((!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.vscode-installed" -PathType Leaf)) -or $install_anyways) {
            Write-Host "Installing $software_name - close window to cancel install" -ForegroundColor DarkCyan
            # Invoke-Expression [string]$env:KINDTEK_NEW_PROC_NOEXIT -command "winget install Microsoft.VisualStudioCode --silent --locale en-US --accept-package-agreements --accept-source-agreements --override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'" 
            start_kindtek_process_pop "
            try {
                write-host 'Installing $software_name ...';
                winget install Microsoft.VisualStudioCode --source winget --override '/SILENT /mergetasks=`"!runcode, addcontextmenufiles, addcontextmenufolders`"';
                winget upgrade Microsoft.VisualStudioCode --source winget --override '/SILENT /mergetasks=`"!runcode, addcontextmenufiles, addcontextmenufolders`"';
                Write-Host '$software_name installed' -ForegroundColor DarkCyan | Out-File -FilePath '$env:KINDTEK_WIN_GIT_PATH/.vscode-installed'
                exit;
            } catch {}"
            $new_install = $true
        }
        else {
            Write-Host "$software_name already installed" -ForegroundColor DarkCyan
        }
    }
    catch {
        Write-Host "error installing $software_name" -ForegroundColor DarkCyan
    }

    return $new_install
}
function install_python {
    param (
        $install_anyways
    )
    $software_name = "Python"
    $new_install = $false

    try {
        if ((!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.python-installed" -PathType Leaf)) -or $install_anyways) {
            $new_install = $true
            Write-Host "Installing $software_name - close window to cancel install" -ForegroundColor DarkCyan
            # @TODO: add cdir and python to install with same behavior as other installs above
            # not eloquent at all but good for now
            winget install --id=Python.Python.3.10 --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;
            winget upgrade --id=Python.Python.3.10 --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;
            Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$env:KINDTEK_WIN_GIT_PATH/.python-installed"
            # ... even tho cdir does not appear to be working on windows
            # $cmd_command = pip install cdir
            # Start-Process -FilePath PowerShell.exe -NoNewWindow -ArgumentList $cmd_command
        }
        else {
            Write-Host "$software_name already installed" -ForegroundColor DarkCyan
        }
        reload_envs
        pip install cdir
    }
    catch {}

    return $new_install
}
function install_wterminal {
    param (
        $install_anyways
    )
    $software_name = "Windows Terminal"
    $new_install = $false
    try {
        if ((!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.wterminal-installed" -PathType Leaf)) -or $install_anyways) {
            Write-Host "Installing $software_name - close window to cancel install" -ForegroundColor DarkCyan
            try {
                winget install Microsoft.PowerShell;
                winget install Microsoft.WindowsTerminal --silent --locale en-US --accept-package-agreements --accept-source-agreements;
                winget upgrade Microsoft.WindowsTerminal --silent --locale en-US --accept-package-agreements --accept-source-agreements;
                Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$env:KINDTEK_WIN_GIT_PATH/.wterminal-installed"
            }
            catch {}
            $new_install = $true
        }
        else {
            Write-Host "$software_name already installed" -ForegroundColor DarkCyan
        }  
    }
    catch {}

    return $new_install
}
function install_recommends {
    param (
        $install_anyways
    )
    Write-Host "`r`nThe following recommended (optional) programs will be installed or updated`r`n`t- Windows Terminal`r`n`t- Visual Studio Code`r`n`t- Python 3.10`r`n`t" -ForegroundColor Magenta
    if ((!(Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH"))) {
        New-Item -ItemType Directory -Force -Path "$env:KINDTEK_WIN_DVLW_PATH" | Out-Null
    }
    else {
        New-Item -ItemType Directory -Force -Path "$env:USERPROFILE/repos/kindtek" | Out-Null
    }
    if ((!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.wterminal-installed" -PathType Leaf)) -or (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.vscode-installed" -PathType Leaf)) -or (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.python-installed" -PathType Leaf))) {
        $confirm_install = Read-Host "hit ENTER to install`r`n  ... or enter any character to skip"
        if ($confirm_install -eq '') {
            if ((!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.wterminal-installed" -PathType Leaf))) {
                start_kindtek_process_pop "
                    try {
                        write-host 'installing windows terminal ...';
                        install_wterminal $install_anyways;
                    } catch {}" 
            }
            if ((!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.vscode-installed" -PathType Leaf))) {
                install_vscode $install_anyways
                start_kindtek_process_pop "
                try {
                    write-host 'installing vs code ...';
                    install_vscode $install_anyways;
                } catch {}" 
            }
            if ((!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.python-installed" -PathType Leaf))) {
                install_python $install_anyways
                start_kindtek_process_pop "
                try {
                    write-host 'installing python ...';
                    install_python $install_anyways;
                } catch {}" 
            }
        }
    }

    return

}
function ini_docker_config {
    param ( $new_integrated_distro )
    $config_file = "$env:APPDATA\Docker\settings.json"
    $config_json = (Get-Content -Raw "$config_file") -join "`n" | ConvertFrom-JSON 
    # $config_json = ConvertFrom-JSON (Get-Content "$config_file")
    $config_json.disableTips = $true
    $config_json.disableUpdate = $false
    $config_json.autoDownloadUpdates = $true
    $config_json.displayedOnboarding = $true
    $config_json.enableIntegrationWithDefaultWslDistro = $true
    # $config_json.kubernetesEnabled = $true
    $config_json.autoStart = $true
    $config_json.useWindowsContainers = $false
    $config_json.wslEngineEnabled = $true
    $config_json.openUIOnStartupDisabled = $true
    $config_json.skipUpdateToWSLPrompt = $true
    $config_json.skipWSLMountPerfWarning = $true
    $config_json.activeOrganizationName = "kindtek"
    if ("$new_integrated_distro" -ne "") {
        $jcurrent = $config_json.integratedWsldistro_list
        $new_distro = @"
[
    {
        "integratedWsldistro_list":"kalilinux-kali-rolling-latest"
    }
]
"@
        $jnew = $new_distro -join "`n" |  ConvertFrom-Json 
        $config_json.integratedWsldistro_list = $jcurrent + $jnew
    }
    ConvertTo-JSON $config_json -Depth 2 -Compress | Out-File $config_file -Encoding utf8 -Force
    (Get-Content $config_file) | Set-Content -Encoding utf8 $config_file
}

function set_docker_config {
    param ( $new_integrated_distro )
    $config_file = "$env:APPDATA\Docker\settings.json"
    $config_json = (Get-Content -Raw "$config_file") -join "`n" | ConvertFrom-JSON
    # $config_json = ConvertFrom-JSON (Get-Content "$config_file")
    $config_json.enableIntegrationWithDefaultWslDistro = $true
    # $config_json.kubernetesEnabled = $true
    $config_json.autoStart = $true
    $config_json.useWindowsContainers = $false
    $config_json.wslEngineEnabled = $true
    $config_json.openUIOnStartupDisabled = $true
    $config_json.skipUpdateToWSLPrompt = $true
    $config_json.skipWSLMountPerfWarning = $true
    $config_json.activeOrganizationName = "kindtek"
    if ("$new_integrated_distro" -ne "") {
        $jcurrent = $config_json.integratedWsldistro_list
        $new_distro = @"
[
    {
        "integratedWsldistro_list":"$new_integrated_distro"
    }
]
"@
        $jnew = $new_distro -join "`n" | ConvertFrom-Json 
        $config_json.integratedWsldistro_list = $jcurrent + $jnew
    }

    ConvertTo-JSON $config_json -Depth 2 -Compress | Out-File $config_file -Encoding utf8 -Force
    (Get-Content $config_file) | Set-Content -Encoding utf8 $config_file


}

function reset_docker_settings {
    # clear settings 
    cmd.exe /c net stop LxssManager
    cmd.exe /c net start LxssManager
    Write-Host "clearing docker settings"
    Push-Location $env:APPDATA\Docker
    Remove-Item "settings.json.old" | Out-Null
    Move-Item -Path "settings.json" "settings.json.old" -Force | Out-Null
    Pop-Location
    &$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchLinuxEngine;
}

function reset_docker_settings_hard {
    reset_docker_settings
    &$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchLinuxEngine -ResetToDefault;

}

function reset_wsl_settings {
    cmd.exe /c net stop LxssManager
    cmd.exe /c net start LxssManager
    # clear settings 
    Write-Host "reverting wsl default distro to $env:KINDTEK_FAILSAFE_WSL_DISTRO"
    if ($env:KINDTEK_FAILSAFE_WSL_DISTRO -ne "") {
        wsl.exe -s $env:KINDTEK_FAILSAFE_WSL_DISTRO
    }
    cmd.exe /c net stop LxssManager
    cmd.exe /c net start LxssManager
}

function hard_restart_wsl_docker_new_win {
    start_kindtek_process_popmin "hard_restart_wsl_docker"
}

function hard_restart_wsl_docker_new_win_wait {
    start_kindtek_process_popmin "hard_restart_wsl_docker 2> `$null;exit;" 'wait' ''
}
function hard_restart_wsl_docker {
    
    Write-Host "resetting Docker engine and data ..."
    try {
        docker update --restart=always docker-desktop
    }
    catch {}
    try {
        docker update --restart=always docker-desktop-data
    }
    catch {}
    try {
        &$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchLinuxEngine;
    }
    catch {}
    Write-Output "restarting docker ..."
    try {
        cmd.exe /c net stop docker
    }
    catch {}
    try {
        cmd.exe /c net stop com.docker.service
    }
    catch {}
    try {
        cmd.exe /c taskkill /IM "dockerd.exe" /F
    }
    catch {}
    try {
        cmd.exe /c taskkill /IM "Docker Desktop.exe" /F
    }
    catch {}
    try {
        cmd.exe /c net start docker
    }
    catch {}
    try {
        cmd.exe /c net start com.docker.service
        
    }
    catch {}
    require_docker_desktop_online
}

function restart_wsl_docker_new_win {
    start_kindtek_process_popmin "restart_wsl_docker"
}

function restart_wsl_docker_new_win_wait {
    start_kindtek_process_popmin "restart_wsl_docker 2> `$null;exit;" 'wait' ''
}


function restart_wsl_docker {
    
    Write-Output "stopping docker ..."
    try {
        powershell.exe -Command cmd.exe /c net stop com.docker.service
    }
    catch {}
    try {
        powershell.exe -Command cmd.exe /c taskkill /IM "'Docker Desktop.exe'" /F
    }
    catch {}
    Write-Output "stopping wsl ..."
    try {
        powershell.exe -Command wsl.exe --shutdown; 
    }
    catch {}
    Write-Output "starting wsl ..."
    try {
        powershell.exe -Command wsl.exe --exec echo 'wsl restarted';
    }
    catch {}
    Write-Output "starting docker ..."
    try {
        powershell.exe -Command cmd.exe /c net start com.docker.service
    }
    catch {}
    try {
        require_docker_desktop_online
        powershell.exe -Command wsl.exe --exec echo 'docker restarted';
    }
    catch {}
}


function is_docker_backend_online {
    try {
        $docker_process = $(Get-Process -ErrorAction SilentlyContinue 'com.docker.proxy')
    }
    catch {
        $docker_process = 'error'
        return $false
    }
    if ( $docker_process -ne 'error' ) {
        return $true
    }
    else {
        return $false
    }
}
function is_docker_desktop_online {
    try {
        $(docker search scratch --limit 1 --format helloworld) 2> $null | Out-Null
        if ($?) {
            $docker_daemon_online = docker search scratch --limit 1 --format helloworld 2> $null
            if (($docker_daemon_online -eq 'helloworld') -And ($(is_docker_backend_online) -eq $true)) {
                return $true
            }
            else {
                return $false
            }
        }
        else {
            return $false
        }
        
    }
    catch {
        return $false
    }
}

function start_docker_desktop_new_win {
    start_kindtek_process_popmin 'start_docker_desktop;exit;'
    # require_docker_desktop_online
}

function start_docker_desktop {
    try {
        reload_envs 
    }
    catch {}
    try {
        Write-Host "`r`n`r`nconnecting to docker desktop ..."
        Start-Process -Filepath "Docker Desktop.exe" 2> $null | Out-Null
        if ($global:bg_process -eq $false) {
            # bring window to front
            reload_envs
        }
    }
    catch {
        try {
            ([void]( New-Item -path alias:'docker' -Value 'C:\Program Files\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
            ([void]( New-Item -path alias:'Docker Desktop' -Value 'C:\Program Files\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
            ([void]( New-Item -path alias:'Docker Desktop.exe' -Value 'C:\Program Files\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))             
            Start-Process "C:\Program Files\docker\docker\Docker Desktop.exe" 2> $null | Out-Null
            if ($global:bg_process -eq $false) {
                # bring window to front
                reload_envs
            }
        }
        catch {
            try {
                ([void]( New-Item -path alias:'docker' -Value 'c:\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                ([void]( New-Item -path alias:'Docker Desktop' -Value 'c:\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                ([void]( New-Item -path alias:'Docker Desktop.exe' -Value 'c:\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null )) 
                Start-Process "c:\docker\docker\Docker Desktop.exe" 2> $null | Out-Null
                if ($global:bg_process -eq $false) {
                    # bring window to front
                    reload_envs
                }
            }
            catch {
                try {
                    ([void]( New-Item -path alias:'docker' -Value ':\docker\docker desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                    ([void]( New-Item -path alias:'Docker Desktop' -Value ':\docker\docker desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                    ([void]( New-Item -path alias:'Docker Desktop.exe' -Value 'c:\docker\docker desktop.exe' -ErrorAction SilentlyContinue | Out-Null )) 
                    Start-Process "c:\docker\docker desktop.exe" 2> $null | Out-Null
                    if ($global:bg_process -eq $false) {
                        # bring window to front
                        reload_envs
                    }
                }
                catch {
                    if ($global:bg_process -eq $false) {
                        # bring window to front
                        reload_envs
                    }
                    # eventually add call to install_dependencies here
                } 
            }
        }
    }
    if ($global:bg_process -eq $false) {
        # bring window to front
        reload_envs
    }
}
function keep_docker_desktop_online_new_win {
    start_kindtek_process_popmin 'keep_docker_desktop_online 2> `$null;exit;' 'wait' '' 
    # require_docker_desktop_online
}

function keep_docker_desktop_online {
    while (!($(is_docker_desktop_online))) {
        require_docker_desktop_online_new_win
        start-sleep 5
    }
}

function require_docker_desktop_online_new_win {
    start_kindtek_process_popmin 'require_docker_desktop_online 2> `$null;exit;' 'wait' '' 
    # require_docker_desktop_online
}

function require_docker_desktop_online_new_win_no_wait {
    start_kindtek_process_popmin 'require_docker_desktop_online 2> `$null;exit;' '' '' 
    # require_docker_desktop_online
}
function require_docker_desktop_online {
    # Set-PSDebug -Trace 2

    [int]$docker_tries = 0
    [int]$docker_cycles = 0
    $docker_settings_reset = $true
    [int]$sleep_time = 5

    # keep trying to start docker and go through four troubleshooting steps
    # the position in the loop is coded into the output using decimals
    do {   
        try {
            $docker_tries += 1
            if ($(is_docker_desktop_online) -eq $false) {
                start_docker_desktop 2> $null | Out-Null
            }
            # Write-Host "${docker_cycles}.${docker_tries}"
            if ($(is_docker_desktop_online) -eq $false) {
                if ($docker_tries -eq 1 -And $docker_cycles -eq 0 -And $(is_docker_backend_online) -eq $false) {
                    Write-Host "error messages and restarts are expected when first starting docker. please wait "
                    # give extra time first time through
                    Start-Sleep -s 15
                }
                if ($docker_tries % 2 -eq 0) {
                    $sleep_time += 1
                    Start-Sleep -s $sleep_time
                    Write-Host -NoNewline " .."
                }
                elseif ($docker_tries % 3 -eq 0) {
                    # start distro_list_num over
                    # automatically restart docker on try 3 then prompt for restart after that
                    if ($docker_tries -gt 8) {
                        # $restart = Read-Host "Restart docker? ([y]n)"
                        $restart = 'y'
                        Write-Host -NoNewline " ........   "

                    }
                    else {
                        $restart = 'n'
                        Write-Host -NoNewline " ........"

                    }
                    if (($restart -ine 'n') -And ($restart -ine 'no') -And ($docker_tries % 9 -eq 0)) {
                        Write-Host -NoNewline " ......... restarting wsl "
                        # allowed to restart on cycle 9
                        restart_wsl_docker 2> $null | Out-Null
                    }
                    elseif ($docker_tries % 15 -eq 0) {
                        # next cycle 
                        Write-Host -NoNewline " ..............."
                        Write-Host ""
                        $docker_tries = 0
                        $docker_cycles++
                    }
                }
                elseif ($docker_tries % 13 -eq 0) {
                    hard_restart_wsl_docker_new_win
                    Write-Host -NoNewline " ............."
                }
            
                if ($docker_tries % 7 -eq 0) {
                    $restart_wsl_docker = $false    
                    Write-Host -NoNewline " ............."             
                    if (($(is_docker_backend_online) -eq $true) -And ($(is_docker_desktop_online) -eq $false)) {
                        # backend is online but desktop isn't
                        if ($docker_cycles -gt 1) {
                            Write-Host "resetting docker settings "
                            reset_wsl_settings
                        }
                        $restart_wsl_docker = $true
                    }
                    if ( $docker_settings_reset -eq $true -And $docker_cycles -gt 1 ) {
                        # only reset settings once and after going thru 2 cycles with exactly 7 tries
                        Write-Host "resetting docker settings "
                        reset_docker_settings
                        $docker_settings_reset = $false
                        $restart_wsl_docker = $true
                        Write-Host -NoNewline " .......................................
                        "          
                    }
                    if ($docker_cycles -gt 3) {
                        Write-Host -NoNewline " ......................................."       
                        Write-Host -NoNewline " ......................................."             
                        Write-Host -NoNewline " ......................................."    
                        Write-Host "hard resetting docker engine and settings "
                        try {
                            reset_docker_settings_hard
                        }
                        catch {}
                    }
                    if ($restart_wsl_docker -eq $true) {
                        restart_wsl_docker
                        Write-Host "restarting wsl "
                        $restart_wsl_docker = $false
                    }
                }
                elseif ($docker_cycles -eq 4 ) {
                    # give up
                             
                    Write-Host -NoNewline " ......................................."                   
                    $check_again = 'n'
                }
                Write-Host ""
                Start-Sleep 1
                Write-Host ""
            }
            else {
                # if service was already up continue right away otherwise sleep a bit
                if ( $docker_tries -gt 1 ) {
                    Write-Host "..................................................................."
                    Start-Sleep -s $sleep_time
                }
                # Write-Host "docker desktop is now online"
                $check_again = 'n'
            }
        }
        catch {
            Write-Host "oops ... there was a problem starting docker"
        }
    } while ( ($(is_docker_desktop_online 2> $null) -eq $false) -And ($check_again -ine 'n') -And ($check_again -ine 'no')) 
    if ($(is_docker_desktop_online)) {
        Write-Host "connected to docker"
    }
    else {
        Write-Host "could not connect to docker"
    }
    return $(is_docker_desktop_online 2> $null)
}

function keep_devel_online {
    start_kindtek_process_popmin "
      while (`$true){
        if (`$(dependencies_installed) -eq `$false){
            # try setting envs first then do bare minimum
            pull_kindtek_envs $env:KINDTEK_DEBUG_MODE;
            safe_boot_devel;
        }
        keep_docker_desktop_online
      start-sleep 5;
      }" 'wait' 'noexit'
}

function remove_installation {
    $git_owner = $env:KINDTEK_WIN_GIT_OWNER
    # powershell -File $("$(get_kindtek_env 'KINDTEK_WIN_DVLP_PATH')/scripts/wsl-remove-distros.ps1")
    wsl.exe --unregister $env:KINDTEK_FAILSAFE_WSL_DISTRO | Out-Null
    wsl.exe --unregister Ubuntu | Out-Null
    wsl.exe --unregister kali-linux | Out-Null
    Remove-Item "$env:USERPROFILE/dvlp.ps1" -Force -ErrorAction SilentlyContinue
    # Remove-Item "$env:USERPROFILE/DockerDesktopInstaller.exe" -Force -ErrorAction SilentlyContinue
    # make extra sure this is not a folder that is not important (ie: system32 - which is a default location)
    # if ($env:KINDTEK_WIN_DVLW_PATH.Contains('kindtek') -And $env:KINDTEK_WIN_DVLW_PATH.NotContains("System32") ) {
    $uninstall_docker = read-host "uninstall docker? (Y/n)"
    if ($uninstall_docker -eq "" -or $uninstall_docker -ieq "y" -or $uninstall_docker -ieq "yes" ) {
        write-output "" | uninstall_docker | out-string
    }
    $uninstall_git = read-host "uninstall git? (Y/n)"
    if ($uninstall_git -eq "" -or $uninstall_git -ieq "y" -or $uninstall_git -ieq "yes" ) {
        uninstall_git | out-string
    }
    if ((Test-Path "$env:USERPROFILE/DockerDesktopInstaller.exe" -PathType Leaf) -or (Test-Path "$env:USERPROFILE/kali-linux.AppxBundle" -PathType Leaf)) {
        try {
            if (Test-Path "$env:USERPROFILE/DockerDesktopInstaller.exe") {
                Write-Host "`r`n`r`n"
                write-host -nonewline "remove DockerDesktopInstaller.exe? (Y/n)"
                Remove-Item -Path "$env:USERPROFILE/DockerDesktopInstaller.exe" -Confirm:$true -ErrorAction SilentlyContinue
            }

        }
        catch {}
        try {
            if (Test-Path "$env:USERPROFILE/kali-linux.AppxBundle") {
                Write-Host "`r`n`r`n"
                write-host -nonewline  "remove kali-linux.AppxBundle? (Y/n)"
                Remove-Item -Path "$env:USERPROFILE/kali-linux.AppxBundle" -Confirm:$true -ErrorAction SilentlyContinue
            }
        }
        catch {}
    }
    write-output "" | uninstall_windows_features 'skip reboot' | out-string
    write-host "choose 'ignore' if prompted to close an application" -ForegroundColor Yellow
    Start-Process powershell.exe -LoadUserProfile -WindowStyle Hidden -Wait -ArgumentList  "-command", "Remove-AppxPackage -package 'MicrosoftCorporationII.WindowsSubsystemForLinux' | Out-Null" -ErrorAction SilentlyContinue
    Start-Process powershell.exe -LoadUserProfile -WindowStyle Hidden -Wait -ArgumentList  "-command", "Remove-AppxPackage -package 'kali-linux' | Out-Null" -ErrorAction SilentlyContinue
    Start-Process powershell.exe -LoadUserProfile -WindowStyle Hidden -Wait -ArgumentList  "-command", "winget uninstall --id kalilinux.kalilinux | Out-Null" -ErrorAction SilentlyContinue
    Start-Process powershell.exe -LoadUserProfile -WindowStyle Hidden -Wait -ArgumentList  "-command", "winget uninstall --name Ubuntu | Out-Null" -ErrorAction SilentlyContinue
    Start-Process powershell.exe -LoadUserProfile -WindowStyle Hidden -Wait -ArgumentList  "-command", "winget uninstall --name 'Windows Subsystem For Linux Update' | Out-Null" -ErrorAction SilentlyContinue
    Start-Process powershell.exe -LoadUserProfile -WindowStyle Hidden -Wait -ArgumentList  "-command", "winget uninstall --name 'Windows Subsystem For Linux WSLg Preview' | Out-Null" -ErrorAction SilentlyContinue
    unset_kindtek_envs
    unset_kindtek_envs 'machine'
    if (Test-Path "$env:USERPROFILE/repos/$($git_owner)") {
        Write-Host "`r`n`r`n"
        Write-Host -nonewline "delete directory $env:USERPROFILE/repos/$($git_owner) ?"
        Remove-Item "$env:USERPROFILE/repos/$($git_owner)" -Recurse -Confirm:$true -Force -ErrorAction SilentlyContinue
    }
    Remove-Item "$env:USERPROFILE/repos/$($git_owner)/.dvlp-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE/repos/$($git_owner)/.docker-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE/repos/$($git_owner)/.vscode-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE/repos/$($git_owner)/.winget-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE/repos/$($git_owner)/.windows-features-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE/repos/$($git_owner)/.wterminal-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE/repos/$($git_owner)/.hypervm-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE/repos/$($git_owner)/.python-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE/repos/$($git_owner)/.github-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
    if (Test-Path "$env:USERPROFILE/kache") {
        Write-Host "`r`n`r`n"
        Write-Host -nonewline "delete directory $env:USERPROFILE/kache ?"
        Remove-Item "$env:USERPROFILE/kache" -Recurse -Confirm:$true -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path "$env:USERPROFILE/.wslconfig" -PathType Leaf) {
        Write-Host "`r`n`r`n"
        Write-Host -nonewline "delete $env:USERPROFILE/.wslconfig ?"
        Remove-Item "$env:USERPROFILE/.wslconfig" -Confirm:$true -Force -ErrorAction SilentlyContinue
    }

    # }

}

function get_wsl_distro_list {
    $env:WSL_UTF8 = 1
    wsl.exe --list | Out-Null
    if (($?)) {
        $wsl_distro_list = wsl.exe --list | Where-Object { (!([string]::isNullOrEmpty($_))) -And ($_ -ne 'Windows Subsystem for Linux Distributions:') -and ($_ -ne "docker-desktop") -and ($_ -ne "docker-desktop-data") -and ($_ -ne "$env:KINDTEK_FAILSAFE_WSL_DISTRO") -and ($_ -ne "$env:KINDTEK_FAILSAFE_WSL_DISTRO (Default)") -and ($_ -ne '') }
        $wsl_distro_list = $wsl_distro_list -replace '^(.*)\s.*$', '$1'
        $wsl_distro_list = $wsl_distro_list -replace "[^a-zA-Z0-9_-]", ''
        return $wsl_distro_list
    }
    else {
        return @()
    }
}

function display_wsl_distro_list {
    param (
        $wsl_distro_list
    )
    if ($wsl_distro_list.length -eq 0) {
        $wsl_distro_list = get_wsl_distro_list
    }
    $default_wsl_distro = get_default_wsl_distro
    if ($wsl_distro_list.length -gt 0) {    
        $wsl_distro_name_single = ''
        for ($i = 0; $i -le $wsl_distro_list.length - 1; $i++) {
            $wsl_distro_name = "$($wsl_distro_list[$i])"
            if ($wsl_distro_list[$i].length -eq 1 ) {
                $wsl_distro_name_single += "$($wsl_distro_list[$i])"
                if ($i -eq $wsl_distro_list.length - 1) {
                    if ($wsl_distro_name_single -eq "$default_wsl_distro") {
                        $default_tag = '(default)'
                    }
                    else {
                        $default_tag = ''
                    }
                    write-host "`t1)`t$("$($wsl_distro_name_single)".trim()) $default_tag"
                }
            }
            else {
                if ($wsl_distro_name -eq "$default_wsl_distro") {
                    $default_tag = '(default)'
                }
                else {
                    $default_tag = ''
                }
                write-host "`t$($i+1))`t$("$($wsl_distro_name)".trim()) $default_tag"
            }
        }
    }
    else {
        # try {
        $wsl_distro_name = $wsl_distro_list[0]
        if ($wsl_distro_name -eq $default_wsl_distro) {
            $default_tag = '(default)'

        }
        else {
            $default_tag = ''
        }
        write-host "`t$($i+1))`t$wsl_distro_name $default_tag"
        # } catch {
        #     # empty
        # }
    }
}

function select_wsl_distro_list_name {
    param (
        [array]$wsl_distro_list,
        [string]$wsl_distro_name
    )
    try {    
        if ($wsl_distro_list.contains($wsl_distro_name)) {
            for ($i = 0; $i -le $wsl_distro_list.length - 1; $i++) {
                if ($wsl_distro_name -eq $wsl_distro_list[$i]) {
                    return "$($i + 1)"
                }
            }
            return $false
        }
    }
    catch {
        return $false
    }
}
function select_wsl_distro_list_num {
    param (
        [array]$wsl_distro_list,
        [int]$wsl_distro_num
    )
    if (($wsl_distro_list.length -eq 0)) {
        $wsl_distro_list = get_wsl_distro_list
    }
    if ([string]::IsNullOrEmpty($wsl_distro_num)) {
        return $null
    }  
    for ($i = 0; $i -le $wsl_distro_list.length - 1; $i++) {
        if ($i -eq $($wsl_distro_num - 1)) {
            if ($wsl_distro_list[$i].length -gt 1) {
                return "$("$($wsl_distro_list[$i])".trim())"
            }
            else {
                return "$("$($wsl_distro_list)".trim())"
            }
        }
    }
    return $null
}

function get_wsl_distro_menu {
    param (
        $wsl_distro_list,
        $wsl_distro_num
    )
    $env:WSL_UTF8 = 1
    $wsl_distro_list_num = 0

    # Loop through each distro and prompt to remove
    foreach ($distro in $wsl_distro_list) {
    
        if ($distro.IndexOf("docker-desktop") -lt 0) {
            $wsl_distro_name = $wsl_distro_list -replace '^(.*)\s.*$', '$1'
            $wsl_distro_list_num += 1
            # $wsl_distro_name = $wsl_distro_name.Split('', [System.StringSplitOptions]::RemoveEmptyEntries) -join ''
            # $wsl_distro_name -replace '\s', ''
            return "$wsl_distro_name"
        }
    }
}

function wsl_distro_batch_delete {
    param (
        $wsl_distro_list
    )
    $env:WSL_UTF8 = 1
    $wsl_distro_list_num = 0

    # Loop through each distro and prompt to remove
    foreach ($distro in $wsl_distro_list) {
    
        if ($distro.IndexOf("docker-desktop") -lt 0) {
            $wsl_distro_name = $wsl_distro_list -replace '^(.*)\s.*$', '$1'
            $wsl_distro_list_num += 1
            # $wsl_distro_name = $wsl_distro_name.Split('', [System.StringSplitOptions]::RemoveEmptyEntries) -join ''
            # $wsl_distro_name -replace '\s', ''
            write-host "wsl.exe --unregister $wsl_distro_name"
            $(wsl.exe --unregister $wsl_distro_name)
        }
    }
    $(wsl.exe --unregister $KINDTEK_FAILSAFE_WSL_DISTRO)
}

