$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
$env:WSL_UTF8 = 1
$global:FAILSAFE_WSL_DISTRO = 'kalilinux-kali-rolling-latest'

function reboot_prompt {
    # Write-Host "`r`nA restart may be required for the changes to fully take effect. "
    $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n`t ..or hit ENTER to skip" 

    if ($confirmation -ieq 'reboot now') {
        Write-Host "`r`nRestarting computer ... r`n"
        Restart-Computer
    }
    # else {
    #     # powershell.exe -Command "$git_path\choco\src\chocolatey.resources\redirects\RefreshEnv.cmd"
    #     Write-Host "`r`n"
    # }
}

function install_windows_features {
    param ( $git_path )
    $new_install = $false
    $winconfig = "$git_path/dvl-adv/add-windows-features.ps1"
    &$winconfig = Invoke-Expression -command "$git_path/dvl-adv/add-windows-features.ps1"
    return $new_install
}

function install_dependencies {
    param ( $git_path )
    Write-Host "`r`nThe following programs will be installed or updated`r`n`t- Windows Terminal`r`n`t- Visual Studio Code`r`n`t- Docker Desktop`r`n`t- Python 3.10`r`n`t" -ForegroundColor Magenta
    
    $software_name = "Windows Terminal"
    if (!(Test-Path -Path "$git_path/.wterminal-installed" -PathType Leaf)) {
        # $windows_terminal_install = Read-Host "`r`nInstall Windows Terminal? ([y]/n)"
        # if ($windows_terminal_install -ine 'n' -And $windows_terminal_install -ine 'no') { 
        Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
        Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{winget install Microsoft.PowerShell;winget install Microsoft.WindowsTerminal --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade Microsoft.WindowsTerminal --silent --locale en-US --accept-package-agreements --accept-source-agreements;exit;}" -Wait

        
        # }
        Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$git_path/.wterminal-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed" -ForegroundColor DarkCyan
    }    

    $software_name = "Visual Studio Code (VSCode)"
    if (!(Test-Path -Path "$git_path/.vscode-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
        # Invoke-Expression -Command "winget install Microsoft.VisualStudioCode --silent --locale en-US --accept-package-agreements --accept-source-agreements --override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'" 
        Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks=`"!runcode, addcontextmenufiles, addcontextmenufolders`"';winget upgrade Microsoft.VisualStudioCode --override '/SILENT /mergetasks=`"!runcode, addcontextmenufiles, addcontextmenufolders`"';exit;}" -Wait
        Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$git_path/.vscode-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed" -ForegroundColor DarkCyan
    }

    $software_name = "Docker Desktop"
    if (!(Test-Path -Path "$git_path/.docker-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
        # winget uninstall --id=Docker.DockerDesktop
        # winget install --id=Docker.DockerDesktop --location="c:\docker" --silent --locale en-US --accept-package-agreements --accept-source-agreements
        # winget upgrade --id=Docker.DockerDesktop --location="c:\docker" --silent --locale en-US --accept-package-agreements --accept-source-agreements
        Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{winget install --id=Docker.DockerDesktop --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --id=Docker.DockerDesktop --silent --locale en-US --accept-package-agreements --accept-source-agreements;exit;}" -Wait
        # update using rolling stable url
        Write-Host "Downloading $software_name update/installation file ..." -ForegroundColor DarkCyan
        Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Invoke-WebRequest -Uri https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe -OutFile DockerDesktopInstaller.exe;.\DockerDesktopInstaller.exe;Remove-Item DockerDesktopInstaller.exe -Force -ErrorAction SilentlyContinue;exit;}" -Wait
        # & 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
        # "Docker Desktop Installer.exe" install --accept-license --backend=wsl-2 --installation-dir=c:\docker 
        Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$git_path/.docker-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed"  -ForegroundColor DarkCyan 
    }

    $software_name = "Python"
    if (!(Test-Path -Path "$git_path/.python-installed" -PathType Leaf)) {
        $new_install = $true
        Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
        # @TODO: add cdir and python to install with same behavior as other installs above
        # not eloquent at all but good for now
        Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{winget install --id=Python.Python.3.10  --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --id=Python.Python.3.10  --silent --locale en-US --accept-package-agreements --accept-source-agreements;exit;}" -Wait
        # ... even tho cdir does not appear to be working on windows
        # $cmd_command = pip install cdir
        # Start-Process -FilePath PowerShell.exe -NoNewWindow -ArgumentList $cmd_command
    
        Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$git_path/.python-installed"
    }
    else {
        Write-Host "$software_name already installed" -ForegroundColor DarkCyan
    }

    return $new_install
    # this is used for x11 / gui stuff .. @TODO: add the option one day maybe
    # choco install vcxsrv microsoft-windows-terminal wsl -y
    
}

function ini_docker_config {
    param ( $new_integrated_distro )
    $config_file = "$env:APPDATA\Docker\settings.json"
    $config_json = (Get-Content -Raw "$config_file") | ConvertFrom-JSON 
    # $config_json = ConvertFrom-JSON (Get-Content "$config_file")
    $config_json.disableTips = $true
    $config_json.disableUpdate = $false
    $config_json.autoDownloadUpdates = $true
    $config_json.displayedTutorial = $true
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
        $jnew = ConvertFrom-Json -InputObject $new_distro
        $config_json.integratedWsldistro_list = $jcurrent + $jnew
    }
    ConvertTo-JSON $config_json -Depth 2 -Compress | Out-File $config_file -Encoding utf8 -Force
    (Get-Content $config_file) | Set-Content -Encoding utf8 $config_file
}

function set_docker_config {
    param ( $new_integrated_distro )
    $config_file = "$env:APPDATA\Docker\settings.json"
    $config_json = (Get-Content -Raw "$config_file") | ConvertFrom-JSON
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
        $jnew = ConvertFrom-Json -InputObject $new_distro
        $config_json.integratedWsldistro_list = $jcurrent + $jnew
    }

    ConvertTo-JSON $config_json -Depth 2 -Compress | Out-File $config_file -Encoding utf8 -Force
    (Get-Content $config_file) | Set-Content -Encoding utf8 $config_file


}

function reset_docker_settings {
    # clear settings 
    Write-Host "clearing docker settings"
    Push-Location $env:APPDATA\Docker
    Delete-Item "settings.json.old" | Out-Null
    Move-Item -Path "settings.json" "settings.json.old" -Force | Out-Null
    Pop-Location
    &$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchLinuxEngine -ResetToDefault;
}

function reset_wsl_settings {
    # clear settings 
    Write-Host "reverting wsl default distro to $FAILSAFE_WSL_DISTRO"
    if ($FAILSAFE_WSL_DISTRO -ne "") {
        wsl -s $FAILSAFE_WSL_DISTRO
    }
}

function wsl_docker_full_restart_new_win {
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{. $env:USERPROFILE/repos/kindtek/dvlw/scripts/devel-tools.ps1;wsl_docker_full_restart;exit;}" -Wait
}

function wsl_docker_full_restart {
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
}

function wsl_docker_restart_new_win {
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{. $env:USERPROFILE/repos/kindtek/dvlw/scripts/devel-tools.ps1;wsl_docker_restart;exit;}" -Wait
}

function wsl_docker_restart {
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
        Write-Output "starting docker ..."
    }
    catch {}
    try {
        powershell.exe -Command cmd.exe /c net start com.docker.service
    }
    catch {}
    try {
        powershell.exe -Command wsl.exe --exec echo 'docker restarted';
    }
    catch {}
}
function is_docker_backend_online {
    try {
        $docker_process = (Get-Process 'com.docker.proxy' )
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
        $docker_daemon_online = docker search scratch --limit 1 --format helloworld 
        if (($docker_daemon_online -eq 'helloworld') -And (is_docker_backend_online -eq $true)) {
            return $true
        }
        else {
            return $false
        }
    }
    catch {
        return $false
    }
}


function start_docker_desktop {
    $refresh_envs = "$env:USERPROFILE/repos/kindtek/RefreshEnv.cmd"
    try {
        Start-Process "Docker Desktop.exe" -WindowStyle minimized
    }
    catch {
        try {
            ([void]( New-Item -path alias:'docker' -Value 'C:\Program Files\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
            ([void]( New-Item -path alias:'Docker Desktop' -Value 'C:\Program Files\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
            ([void]( New-Item -path alias:'Docker Desktop.exe' -Value 'C:\Program Files\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
            powershell.exe -Command $refresh_envs | Out-Null
            Start-Process "C:\Program Files\docker\docker\Docker Desktop.exe" -WindowStyle minimized
        }
        catch {
            try {
                ([void]( New-Item -path alias:'docker' -Value 'c:\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                ([void]( New-Item -path alias:'Docker Desktop' -Value 'c:\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                ([void]( New-Item -path alias:'Docker Desktop.exe' -Value 'c:\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                powershell.exe -Command $refresh_envs | Out-Null
                Start-Process "c:\docker\docker\Docker Desktop.exe" -WindowStyle minimized
            }
            catch {
                try {
                    ([void]( New-Item -path alias:'docker' -Value ':\docker\docker desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                    ([void]( New-Item -path alias:'Docker Desktop' -Value ':\docker\docker desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                    ([void]( New-Item -path alias:'Docker Desktop.exe' -Value 'c:\docker\docker desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                    powershell.exe -Command $refresh_envs | Out-Null
                    Start-Process "c:\docker\docker desktop.exe" -WindowStyle minimized
                }
                catch {} 
            }
        }
    }
}

function require_docker_online {
    # Set-PSDebug -Trace 2;
    $docker_tries = 0
    $docker_cycles = 0
    $docker_settings_reset = $true
    $orig_foreground = $host.UI.RawUI.ForegroundColor
    $orig_background = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = "DarkGray"
    $host.UI.RawUI.BackgroundColor = "Gray"
    Write-Host "`r`n`r`nloading docker desktop ..."
    Write-Host "waiting for docker backend to come online ..."  
    . $env:USERPROFILE/repos/kindtek/dvlw/scripts/devel-tools.ps1
    do {   
        try {
            if ( (is_docker_desktop_online) -eq $false ) {
                start_docker_desktop 
            }
            # launch docker desktop and keep it open 
            $docker_tries++
            Write-Host "${docker_cycles}.${docker_tries}"
            if ( (is_docker_desktop_online) -eq $false ) {
                if ( ($docker_tries -eq 1 -And $docker_cycles -eq 1) -And ((is_docker_backend_online) -eq $false)) {
                    Write-Host "error messages are expected when first starting docker. please wait ..."
                }
                if (($docker_tries % 2) -eq 0) {
                    write-host ""
                    $sleep_time += 1
                    Start-Sleep -s $sleep_time
                    Write-Host ""
                }
                elseif (($docker_tries % 3) -eq 0) {
                    # start distro_list_num over
                    # $docker_attempt1 = $docker_attempt2 = $false
                    # automatically restart docker on try 3 then prompt for restart after that
                    if ( $docker_tries -gt 8 ) {
                        # $restart = Read-Host "Restart docker? ([y]n)"
                        $restart = 'y'
                    }
                    else {
                        $restart = 'n'
                    }
                    if ( $restart -ine 'n' -And $restart -ine 'no' -And (($docker_tries % 9) -eq 0)) {
                        wsl_docker_restart
                    }
                    elseif ( ($docker_tries % 6) -eq 0) {
                        # $check_again = Read-Host "Keep trying to connect to docker? ([y]n)"

                        Write-Host "resetting docker engine ....."
                        try {
                            &$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchLinuxEngine;
                        }
                        catch {}
                        Write-Host "trying again to start docker desktop ..."
                    }
                    elseif (($docker_tries % 15) -eq 0) {
                        $docker_tries = 0
                        $docker_cycles++
                    }
                }
                elseif (($docker_tries % 13) -eq 0) {
                    wsl_docker_full_restart_new_win
                }
            
                if ((($docker_tries % 7) -eq 0) ) {
                    $wsl_docker_restart = $false
                    if ((is_docker_backend_online) -eq $true -And (is_docker_desktop_online) -eq $false) {
                        # backend is online but desktop isn't
                        if ($docker_cycles -gt 1) {
                            reset_wsl_settings
                        }
                        $wsl_docker_restart = $true
                    }
                    if ( $docker_settings_reset -eq $true -And $docker_cycles -gt 1 ) {
                        # only reset settings once and after going thru 2 cycles with exactly 7 tries
                        reset_docker_settings
                        $docker_settings_reset = $false
                        $wsl_docker_restart = $true
                    }
                    if ( $wsl_docker_restart -eq $true) {
                        wsl_docker_restart
                        $wsl_docker_restart = $false
                    }
                }
                elseif ($docker_cycles -eq 4 ) {
                    # give up
                    $check_again = 'n'
                }
                Write-Host ""
                Start-Sleep 1
                Write-Host ""
            }
            else {
                # if service was already up continue right away otherwise sleep a bit
                if ( $docker_tries -gt 1 ) {
                    Start-Sleep -s $sleep_time
                    Write-Host ""
                }
                Write-Host "docker desktop is now online"
                $check_again = 'n'
            }
            
        }
        catch {
            # Write-Host "error connecting to docker"
        }
    } while ( ((is_docker_desktop_online) -eq $false) -And ( $check_again -ine 'n' -And $check_again -ine 'no') )
    if ( ((is_docker_desktop_online) -eq $false) -And ( $check_again -ine 'n' -Or $check_again -ine 'no') ) {
        Write-Host "docker failed to start."
    }
    # Set-PSDebug -Trace 0;
    $host.UI.RawUI.ForegroundColor = $orig_foreground
    $host.UI.RawUI.BackgroundColor = $orig_background
    return (is_docker_desktop_online)
}

function cleanup_installation {
    param (
        # OptionalParameters
    )
    
    try {
        Remove-Item "$git_path".replace($repo_src_name, "install-$repo_src_owner-$repo_src_name.ps1") -Force -ErrorAction SilentlyContinue
        Write-Host "`r`nCleaning up..  `r`n"
        Remove-Item "$git_path".replace($repo_src_name, "DockerDesktopInstaller.exe") -Force -ErrorAction SilentlyContinue
        # make extra sure this is not a folder that is not important (ie: system32 - which is a default location)
        if ($git_path.Contains($repo_src_name) -And $git_path.NotContains("System32") ) {
            Remove-Item $git_path -Recurse -Confirm -Force -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Host "Run the following command to delete the repo and setup files:`r`nRemove-Item $git_path -Recurse -Confirm -Force`r`n"
    }
}

function get_default_wsl_distro {
    $default_wsl_distro = wsl --list | Where-Object { $_ -and $_ -ne '' -and $_ -match '(.*)\s\(' }
    return $default_wsl_distro
}

function wsl_distro_list {
    $env:WSL_UTF8 = 1
    $distro_list = wsl --list | Where-Object { $_ -and $_ -ne 'Windows Subsystem for Linux Distributions:'  }
    return $distro_list -replace '^(.*)\s.*$', '$1'
}

function wsl_distro_menu {
    param (
        $distro_list
    )
    $env:WSL_UTF8 = 1
    $distro_list_num = 0

    # Loop through each distro and prompt to remove
    foreach ($distro in $distro_list) {
    
        if ($distro.IndexOf("docker-desktop") -lt 0) {
            $distro_name = $distro_list -replace '^(.*)\s.*$', '$1'
            $distro_list_num += 1
            # $distro_name = $distro_name.Split('', [System.StringSplitOptions]::RemoveEmptyEntries) -join ''
            # $distro_name -replace '\s', ''
            Write-Host "$distro_list_num $distro_name"
        }
    }
}

function wsl_distro_menu_get {
    param (
        $distro_list,
        $distro_num
    )
    $env:WSL_UTF8 = 1
    $distro_list_num = 0

    # Loop through each distro and prompt to remove
    foreach ($distro in $distro_list) {
    
        if ($distro.IndexOf("docker-desktop") -lt 0) {
            $distro_name = $distro_list -replace '^(.*)\s.*$', '$1'
            $distro_list_num += 1
            # $distro_name = $distro_name.Split('', [System.StringSplitOptions]::RemoveEmptyEntries) -join ''
            # $distro_name -replace '\s', ''
            return $distro_name
        }
    }
}

function run_installer {

    $repo_src_owner = 'kindtek'
    $repo_git_name = 'dvlw'
    $git_path = "$env:USERPROFILE\repos\$repo_src_owner\$repo_git_name"
    # log default distro
    $global:ORIG_DEFAULT_WSL_DISTRO = get_default_wsl_distro
    # jump to bottom line without clearing scrollback
    # Write-Host "$([char]27)[2J" 
    $new_install = install_windows_features $git_path 
    if ($new_install -eq $true) {
        Write-Host "`r`nwindows features installations complete! restart may be needed to continue. `r`n`r`n" 
        reboot_prompt
    }

    $new_install = install_dependencies $git_path
    if ($new_install -eq $true) {
        Write-Host "`r`nsoftware installations complete! restart(s) may be needed to begin WSL import phase. `r`n`r`n" 
        reboot_prompt
    }


    # Write-Host "$([char]27)[2J" 
    # if (!(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf)) {
    #     if (!(powershell ${function:require_docker_online} )) {
    #         Write-Host "`r`nnot starting docker desktop.`r`n" 
    #     }
    #     # else {
    #     #     ini_docker_config
    #     # }
    # }
}
