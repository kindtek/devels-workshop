$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
# powershell version compatibility for PSScriptRoot
if (!$PSScriptRoot) { $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
$temp_repo_scripts_path = $PSScriptRoot
$repo_src_owner = 'kindtek'
$repo_src_name = 'devels-workshop'
$repo_src_branch = 'windows'
$git_path = $temp_repo_scripts_path.Replace("\scripts", "")
$git_path = $git_path.Replace("/scripts", "")
$parent_path = $git_path.Replace("\$repo_src_name-temp", "")
$parent_path = $parent_path.Replace("/$repo_src_name-temp", "")
# Write-Host "parent path: $parent_path"
# Write-Host "git dir: $git_path"
# Write-Host "scripts dir: $temp_repo_scripts_path"


# jump to bottom line without clearing scrollback
Write-Output "$([char]27)[2J"

function restart_prompt {
    Write-Host "`r`nA restart is required for the changes to fully take effect. " -ForegroundColor Magenta -BackgroundColor "Black"
    $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n ..or hit ENTER to skip" 
    if ($confirmation -ieq 'reboot now') {
        Restart-Computer -Force
    }
    else {
        Write-Host "`r`n"
    }
}

function install_all {
    param ($temp_repo_scripts_path, $git_path)

    # use windows-features-wsl-add to handle windows features install 
    # installing first to make sure environment has powershell 2
    # @ TODO: add WORKING cancel button - for not CTRL + C and closing window will have to do if you cancel windows features install
    $winconfig = "$temp_repo_scripts_path/devels-advocate/add-windows-features.ps1"
    &$winconfig = Invoke-Expression -command "$temp_repo_scripts_path/devels-advocate/add-windows-features.ps1"


    Write-Host "`r`nThese programs will be installed or updated:" -ForegroundColor Magenta
    Write-Host "`t- WinGet`r`n`t- Chocolatey`r`n`t- Github CLI`r`n`t- Visual Studio Code`r`n`t- Docker Desktopr`r`n`t- Windows Terminal`r`n`tPython`r`n`tcdir" -ForegroundColor Magenta
    Write-Host "`r`nClose window to quit at any time"

    $software_name = "WinGet"
    if (!(Test-Path -Path "$git_path/.winget-installed" -PathType Leaf)) {
        Push-Location $temp_repo_scripts_path
        # install winget and use winget to install everything else
        $host.UI.RawUI.BackgroundColor = "Black"
        $winget = "devels-advocate/get-latest-winget.ps1"
        Write-Host "`n`r`n`rInstalling $software_name ..."  -BackgroundColor "Black"
        &$winget = Invoke-Expression -command "devels-advocate/get-latest-winget.ps1" 
        Write-Host "$software_name installed"  | Out-File -FilePath "$git_path/.winget-installed"
        Pop-Location
    }
    else {
        Write-Host "$software_name already installed"  -ForegroundColor "Blue"
    }

    # @TODO: since this gave so many errors, use git to install from source - the current way does like it may be better to stay up to date (rather than using a fork or origin choco repo)
    $software_name = "Chocolatey"
    if (!(Test-Path -Path "$git_path/.choco-installed" -PathType Leaf)) {
        # getting error-0x80010135 path too long error when unzipping.. unzip operation at the shortest path
        Push-Location $temp_repo_scripts_path
        # install choco 
        $host.UI.RawUI.BackgroundColor = "Black"
        $choco = "devels-advocate/get-latest-choco.ps1"
        Write-Host "`n`r`n`rInstalling $software_name ..."  -BackgroundColor "Black"
        $env:path += ";C:\ProgramData\chocoportable"
        &$choco = Invoke-Expression -command "devels-advocate/get-latest-choco.ps1" 
        # cmd /c start powershell.exe "$git_path/scripts/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle Hidden
        Write-Host "$software_name installed"  | Out-File -FilePath "$git_path/.choco-installed"
        Pop-Location
    }
    else {
        Write-Host "$software_name already installed"  -ForegroundColor "Blue"
    }

    $software_name = "Github CLI"
    if (!(Test-Path -Path "$git_path/.github-installed" -PathType Leaf)) {
        $host.UI.RawUI.BackgroundColor = "Black"
        Write-Host "`n`rInstalling $software_name ..." -BackgroundColor "Black"
        Invoke-Expression -Command "winget install -e --id GitHub.cli"
        $host.UI.RawUI.BackgroundColor = "Black"
        Invoke-Expression -Command "winget install --id Git.Git -e --source winget"
        Write-Host "`n`r" -BackgroundColor "Black"
        Write-Host "$software_name installed" | Out-File -FilePath "$git_path/.github-installed"
    }
    else {
        Write-Host "$software_name already installed"  -ForegroundColor "Blue"
    }

    $software_name = "Visual Studio Code (VSCode)"
    if (!(Test-Path -Path "$git_path/.vscode-installed" -PathType Leaf)) {
        $host.UI.RawUI.BackgroundColor = "Black"
        Write-Host "`r`nInstalling $software_name`r`n" -BackgroundColor "Black"
        Invoke-Expression -Command "winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'" 
        Write-Host "$software_name installed" | Out-File -FilePath "$git_path/.vscode-installed"
    }
    else {
        Write-Host "$software_name already installed"  -ForegroundColor "Blue"
    }

    $software_name = "Docker Desktop"
    if (!(Test-Path -Path "$git_path/.docker-installed" -PathType Leaf)) {
        $host.UI.RawUI.BackgroundColor = "Black"
        Write-Host "`r`nInstalling $software_name`r`n" -BackgroundColor "Black"
        Invoke-Expression -Command "winget install --id=Docker.DockerDesktop -e" 
        Write-Host "$software_name installed"  | Out-File -FilePath "$git_path/.docker-installed"
    }
    else {
        Write-Host "$software_name already installed"  -ForegroundColor "Blue"
    }

    $software_name = "Windows Terminal"
    if (!(Test-Path -Path "$git_path/.wterminal-installed" -PathType Leaf)) {
        # $windows_terminal_install = Read-Host "`r`nInstall Windows Terminal? ([y]/n)"
        # if ($windows_terminal_install -ine 'n' -And $windows_terminal_install -ine 'no') { 
        $host.UI.RawUI.BackgroundColor = "Black"
        Write-Host "`r`nInstalling $software_name`r`n" -BackgroundColor "Black"
        Invoke-Expression -Command "winget install Microsoft.WindowsTerminal" 
        # }
        Write-Host "$software_name installed"  | Out-File -FilePath "$git_path/.wterminal-installed"
    }
    else {
        Write-Host "$software_name already installed"  -ForegroundColor "Blue"
    }

    # this is used for x11 / gui stuff .. @TODO: add the option one day maybe
    # choco install vcxsrv microsoft-windows-terminal wsl -y

    Write-Host "`r`nA restart may be required for the changes to take effect. " -ForegroundColor Magenta -BackgroundColor "Black"
    $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n ..or hit ENTER to skip" 
    if ($confirmation -ieq 'reboot now') {
        Restart-Computer -Force
    }
}

# source of the below self-elevating script: https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html#:~:text=If%20User%20Account%20Control%20(UAC,select%20%22Run%20with%20PowerShell%22.
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle "Maximized" -ArgumentList $CommandLine
        Exit
    }
}
# source of the above self-elevating script: https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html#:~:text=If%20User%20Account%20Control%20(UAC,select%20%22Run%20with%20PowerShell%22.


try {
    # refresh environment variables
    # cmd /c start powershell.exe "$git_path/scripts/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle Hidden
    if (Test-Path -Path "$parent_path/$repo_src_name") {
        Set-Location "$parent_path/$repo_src_name"
        # if git status works and finds devels-workshop repo, assume the install has been successfull and this script was ran once before
        $git_status = git remote show origin 
        # determine if git status works by checking output for LICENSE - see typical output of git status here: https://amitd.co/code/shell/git-status-porcelain
        if ($git_status.NotContains("github.com/kindtek/devels-workshop")) {
            # Write-Host "Git status not showing repository"
            install_all $temp_repo_scripts_path $git_path
        }
    }
    else {
        # Write-Host "Git directory not found"
        install_all $temp_repo_scripts_path $git_path
    }
}
catch {
    # Write-Host "Git error caught"
    install_all $temp_repo_scripts_path $git_path
}

try {
    # refresh environment variables
    # cmd /c start powershell.exe "$git_path/scripts/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle Hidden
    RefreshEnv
    # Write-Host "parent path: $parent_path"
    Set-Location $parent_path

    # test git
    $git_version = git --version 

    $host.UI.RawUI.BackgroundColor = "Black"
    # .. and then clone the repo
    if (!(Test-Path -Path "$parent_path/$repo_src_name")) {
        git clone "https://github.com/$repo_src_owner/$repo_src_name.git" --branch $repo_src_branch
    }
    
    Set-Location "$repo_src_name"
    $host.UI.RawUI.BackgroundColor = "Black"
    git submodule update --force --recursive --init --remote
    $host.UI.RawUI.BackgroundColor = "Black"

    # @TODO: add cdir and python to install lists
    # last but not least
    winget install --id=Python.Python.3.10  -e

    $cmd_command = pip install cdir
    Start-Process -FilePath PowerShell.exe -NoNewWindow -ArgumentList $cmd_command

    RefreshEnv

}
# if git is not recognized try to limp along with the manually downloaded files
catch {}

# refresh env again
# cmd /c start powershell.exe "$git_path/scripts/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle Hidden

# $user_input = (Read-Host "`r`nopen Docker Dev environment? [y]/n")
# if ( $user_input -ine "n" ) {
#     Start-Process "https://open.docker.com/dashboard/dev-envs?url=https://github.com/kindtek/devels-workshop@main" -WindowStyle "Hidden"
# } 

Write-Host "`r`nSetup complete!`r`n" -ForegroundColor Green -BackgroundColor "Black"

try {
    # @TODO: maybe start in new window
    $start_devs_playground = Read-Host "`r`nStart Devel's Playground ([y]/n)"
    $software_name = "Docker Desktop"
    if ($start_devs_playground -ine 'n' -And $start_devs_playground -ine 'no') { 
        # launch docker desktop and keep it open 
        Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle "Hidden"
        Write-Host "`r`n`r`nWaiting for $software_name to come online ..." -BackgroundColor "Black" -ForegroundColor "Yellow"
        Write-Host "`r`nNOTE: $software_name is required to be running for the Devel's Playground to work. Do NOT quit $software_name until you are done running it.`r`nYou can minimize $software_name by pressing WIN + Down arrow" -BackgroundColor "Black" -ForegroundColor "Yellow"

        # $docker_attempt1 = $false
        # $docker_attempt2 = $false
        $docker_tries = 0
        $docker_online = $false
        do {
            $check_again = 'x'
            $docker_tries++
            Start-Sleep -seconds 1
            if ($docker_online -eq $false -And ($docker_tries % 10) -eq 0) {
                # start count over
                # $docker_attempt1 = $docker_attempt2 = $false
                # prompt to continue
                write-host "$docker_status_now`r`n"
                $check_again = Read-Host "Waited for $docker_tries seconds. keep waiting for docker to come online? ([y]n)"
                $docker_tries = 0      
            }
            try {
                Get-Process 'com.docker.proxy'
                $docker_online = $true
            }
            catch {}
            # if ($docker_attempt1 -eq $true -And $docker_attempt2 -eq $true){

            # if (!($docker_status_now.Contains("error"))) {
            #     if ($docker_attempt1 -eq $true) {
            #         $docker_attempt2 = $true
            #     }
            #     else {
            #         $docker_attempt1 = $true
            #     }
            # }
        }
        # @TODO: ask user every x number of tries if they would like to keep pinging docker. ie:
        # while ((!($docker_attempt2)) -Or $docker_tries -lt 100 -Or $check_again -ieq '')
        while (-Not $docker_online -Or $check_again -ieq 'n')
        # debug
        # while ((!($docker_attempt2)) -Or $check_again -ieq 'y')

        if ($docker_online -eq $true) {
            # // commenting out background building process because this is NOT quite ready.
            # // would like to run in separate window and then use these new images in devel's playground 
            # // if they are more up to date than the hub - which could be a difficult process
            # $cmd_command = "$git_path/devels_playground/scripts/docker-images-build-in-background.ps1"
            # &$cmd_command = cmd /c start powershell.exe -Command "$git_path/devels_playground/scripts/docker-images-build-in-background.ps1" -WindowStyle "Maximized"
            # Write-Host "`r`n" -BackgroundColor "Black"
            $host.UI.RawUI.BackgroundColor = "Black"
            $devs_playground = "$git_path/devels-playground/scripts/wsl-docker-import.cmd"
            &$devs_playground = cmd /c start powershell.exe -Command "$git_path/devels-playground/scripts/wsl-docker-import.cmd"
        }
        else {
            Write-Host "Failed to launch docker. Not able to start Devel's Playground. Please restart and run the script again:" -ForegroundColor "Red"
            Write-Host "cmd kindtek/devels-workshop/devels-playground/scripts/wsl-docker-import"
            Write-Host "powershell.exe ./kindtek/devels-workshop/devels-playground/scripts/wsl-docker-import.ps1"

        }

    }
}
catch {}

try {
    Remove-Item "$git_path".replace($repo_src_name, "install-$repo_src_owner-$repo_src_name.ps1") -Force -ErrorAction SilentlyContinue
    Write-Host "`r`nCleaning up..  `r`n"
    # make extra sure this is not a folder that is not important (ie: system32 - which is a default location)
    if ($git_path.Contains($repo_src_name) -And $git_path.NotContains("System32") ) {
        Remove-Item $git_path -Recurse -Confirm -Force -ErrorAction SilentlyContinue
    }
}
catch {
    Write-Host "Run the following command to delete the setup files:`r`nRemove-Item $git_path -Recurse -Confirm -Force`r`n"
}


