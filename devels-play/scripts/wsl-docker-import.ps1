# Set-PSDebug -Trace 2
Set-PSDebug -Off
$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
# jump to first line without clearing scrollback
function main {
    dev_boilerplate
}
# from https://stackoverflow.com/questions/44703646/determine-the-os-version-linux-and-windows-from-powershell
function Get-PSPlatform {
    return [System.Environment]::OSVersion.Platform
}
function dev_boilerplate {

   
    

    # set default vars
    # $image_repo = "_"
    # mask = human readable - ie 'official' not '_'
    # $image_repo_mask = "official"
    # $image_name = "ubuntu:latest"
    $image_repo = $image_repo_mask = "kindtek"
    $image_name = "dplay:ubuntu-dind"
    $mount_drive_letter = "c"
    $unix_mount_drive = "/mnt/$mount_drive_letter"
    $windows_mount_drive = "${mount_drive_letter}:"
    $mount_drive = $unix_mount_drive # default
    $save_directory = "docker2wsl"
    $wsl_version = "1"
    Write-Host "$([char]27)[2J"

    try {
        # first check OS to get relevant C drive path
        # from https://stackoverflow.com/questions/44703646/determine-the-os-version-linux-and-windows-from-powershell
        switch (Get-PSPlatform) {
            'Win32NT' { 
                New-Variable -Option Constant -Name IsWindows -Value $True -ErrorAction SilentlyContinue
                New-Variable -Option Constant -Name IsLinux  -Value $false -ErrorAction SilentlyContinue
                New-Variable -Option Constant -Name IsMacOs  -Value $false -ErrorAction SilentlyContinue
            }
        }

        if ($IsLinux) {
            Write-Host "Linux OS detected"
            try {
                # test for being in an wsl environment
                write-host "checking if wsl.exe is recognized"
                $wsl = @(wsl.exe -l -v)
                Write-Host "WSL detected"
                $mount_drive = "${unix_mount_drive}/${unix_mount_drive}"
            }
            catch { 
                Write-Host "WSL NOT detected"
                # probably nested so deep into linux that wsl wont work anymore
                $mount_drive = $windows_mount_drive 
            }

        }
        # while we're here might as well
        elseif ($IsMacOS) {
            Write-Host "macOS OS detected"
            $mount_drive = $unix_mount_drive
        }
        elseif ($IsWindows) {
            Write-Host "Windows OS detected"
            try {
                # test for being in an wsl environment
                write-host "checking if wsl.exe is recognized"
                $wsl = @(wsl.exe -l -v)
                Write-Host "WSL detected"
                $mount_drive = "${mount_drive_letter}:${unix_mount_drive}"
            }
            catch { 
                Write-Host "WSL NOT detected"
                $mount_drive = $windows_mount_drive 
            }
        }
    }
    catch {}

    $install_directory = "$image_repo_mask-$image_name"
    $install_directory = $install_directory.replace(':', '-')
    $install_directory = $install_directory.replace('/', '-')

    $save_location = "${mount_drive}/$save_directory"
    # Write-Host "save location: $save_location"
    $install_location = "$save_location/$install_directory"
    # Write-Host "install location: $install_location"

    # distro - meaning local distro
    $distro = $install_directory
    $image_save_path = "$save_location/$distro.tar"
    $install_location = "$save_location/$install_directory"
    $image_repo_image_name = "$image_repo/$image_name"
    # special rule for official distros on docker hub
    # replaces '_' with 'official' for printing
    if ( $image_repo -eq "_") {
        # official repo has no repo name in address/url
        $image_repo_image_name = $image_name
    } 
    

    $config = greeting_prompt $image_repo_mask $image_name $image_save_path $distro

    # prompt user to type input or hit enter for default shown in parentheses
    if ($config -eq "config") {

        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "Green"
        # @TODO: filter/safeguard user input
        Write-Host `r`n
        $image_repo_prompt = Read-Host -Prompt "image repository ($image_repo_mask) $ "
        if ($image_repo_prompt -ne "") {
            $image_repo = $image_repo_prompt
            $image_repo_mask = $image_repo_prompt
        }
        else {
            $image_repo = $image_repo_mask
        }

        $image_name_prompt = Read-Host -Prompt "image name in ${image_repo_mask} ($image_name) $ "
        if ($image_name_prompt -ne "") {
            $image_name = $image_name_prompt
        }
        # special rule for official distros on docker hub
        # replaces '_' with 'official' for printing
        if ($image_repo -eq "_") {
            $image_repo_image_name = $image_name
        }
        else {
            $image_repo_image_name = "$image_repo_mask/$image_name"
        }

        # set default var before prompt
        $save_directory_prompt = Read-Host -Prompt "download folder ${mount_drive}/($save_directory) $ "
        if ($save_directory_prompt -ne "") {
            $save_directory = $save_directory_prompt
        }
        $save_directory = $save_directory.replace('/', '-')
        $save_directory = $save_directory.replace(':', '-')
        
        $install_directory = "$image_repo_mask-$image_name"
        $install_directory = $install_directory.replace('/', '-')
        $install_directory = $install_directory.replace(':', '-')

        # set default var before prompt
        $install_directory_prompt = Read-Host -Prompt "install folder ${mount_drive}/$save_directory/($install_directory) $ "
        if ($install_directory_prompt -ne "") {
            $install_directory = $install_directory_prompt
            $install_directory = $install_directory.replace('/', '-')
            $install_directory = $install_directory.replace(':', '-')

        }

        $save_location = "${mount_drive}/$save_directory"
        $install_location = "$save_location/$install_directory"
        # special rule for official distro
        if ($image_repo -eq "_") {
            $distro = "official-$install_directory"
        }
        else {
            $distro = $install_directory
        }

        $distro_prompt = Read-Host -Prompt "distro name in WSL: ($distro) $ "
        if ($distro_prompt -ne "") {
            $distro = $distro_prompt
        }
        
        $distro = $distro.Replace('/', '-')
        $distro = $distro.Replace(':', '-')
        $image_save_path = "$save_location/$distro.tar"
        $wsl_version_prompt = Read-Host  "WSL version: (2) $ "
        if ($wsl_version_prompt -ne "") {
            $wsl_version = $wsl_version_prompt
        }

        if ($wsl_version -ne "1" -And $wsl_version -ne "2") {
            # manually override default wsl version here
            $wsl_version = "2"
        }
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "White"
    }

    $null = New-Item -Path $save_location -ItemType Directory -Force -ErrorAction SilentlyContinue 
    $null = New-Item -Path $install_location -ItemType Directory -Force -ErrorAction SilentlyContinue 

  
    Write-Host "$save_location`r`n"
    Write-Host "$install_location`r`n"

    docker_image_pull $image_repo_image_name
    $WSL_DOCKER_CONTAINER_ID = (docker_container_start $config $distro $image_repo_image_name $install_location)[-1]

    Write-Host "WSL_DOCKER_CONTAINER_ID=$WSL_DOCKER_CONTAINER_ID"
    Write-Host "before-install_location=$install_location"

    # now that we have container id, append it to install location and distro
    $install_location = "$install_location-$WSL_DOCKER_CONTAINER_ID"
    Write-Host "after-install_location=$install_location"

    Write-Host "distro=$distro"
    # update image id and container id path for later ref
    $distro = "$distro-$WSL_DOCKER_CONTAINER_ID"
    Write-Host "distro=$distro"

    export_image $install_location $save_location $distro $WSL_DOCKER_CONTAINER_ID
    import_docker_tar $distro $install_location $save_location $wsl_version
    wsl_or_bust $distro
}

function greeting_prompt {
    param ($image_repo_mask, $image_name, $image_save_path, $distro) 

    $dev_boilerplate_output = @"
    
     _____________________________________________________________________
    /                          DEVEL'S PLAYGROUND                         \
    \_______________  WSL import tool for Docker Hub images  _____________/
      -------------------------------------------------------------------
      .............    Image settings                       .............
      .............-----------------------------------------.............
      .............    source:                              .............
      .............      $image_repo_mask                           
      .............                                         .............
      .............    name:                                .............
      .............      $image_name                     
      .............                                         .............
      .............    download to:                         .............
      .............      $image_save_path 
      .............                                         .............
      .............    WSL alias:                           .............
      .............      $distro-dockerID           
      -------------------------------------------------------------------
      
    
Press ENTER to use settings above and import $distro into WSL 
 ..or type 'config' for custom install.
"@



    # @TODO: add options ie: 
    # Write-Host   ..or type:
    # Write-Host           - 'registry' to specify distro from a registry on the Docker Hub
    # Write-Host           - 'image' to import a local Docker image
    # Write-Host           - 'container' to import a running Docker container
    # @TODO: (and eventually add numbered menu)
    Write-Host $dev_boilerplate_output  
    $config = Read-Host -Prompt ' $'
    return $config
}

   
function docker_image_pull {

    param($image_repo_image_name)

    Write-Host "========================================================================"
    Write-Host "`r`n"
    Write-Host "pulling image ($image_repo_image_name)..."
    Write-Host "docker pull --platform linux $image_repo_image_name"
    # pull the image
    docker pull --platform linux $image_repo_image_name
    Write-Host "`r`n"
}
function docker_container_start {
    param( [string]$config, [string]$distro, [string]$image_repo_image_name, [string]$install_path, [string]$docker_container_id_path  )
    Write-Host "initializing the image container..."
    Write-Host "docker images -aq $image_repo_image_name"
    # get single id returned from docker images command
    $WSL_DOCKER_IMG_ID = @(docker images -aq $image_repo_image_name)
    $WSL_DOCKER_IMG_ID = $WSL_DOCKER_IMG_ID[0]
    $docker_image_id_path = "$install_path/.image_id"
    $docker_container_id_path = "$install_path/.container_id"
    New-Item -ItemType File -Name ".image_id" -Value $WSL_DOCKER_IMG_ID -Path $install_path
    # Write-Host $WSL_DOCKER_IMG_ID | Out-File -FilePath $docker_image_id_path
    # ^^^^^^^ image_id saved here ^^^^^^

    Write-Host "`r`n "
    Write-Host "========================================================================"
    Write-Host "`r`n"
    Write-Host "testing container  with image id: $WSL_DOCKER_IMG_ID..."
    Write-Host "`r`n"
    Write-Host "this container is running as a local copy of the image $image_repo_image_name"
    Write-Host "`r`n"
    
    Write-Host "docker run -id --cidfile=$docker_container_id_path --name=$distro-$WSL_DOCKER_IMG_ID --sig-proxy=false $WSL_DOCKER_IMG_ID"
    docker run -id --cidfile=$docker_container_id_path --name=$distro-$WSL_DOCKER_IMG_ID --sig-proxy=false $WSL_DOCKER_IMG_ID    

    # ECHO exporting image (!WSL_DOCKER_IMG_ID!) as container (!WSL_DOCKER_CONTAINER_ID!)...
    # ECHO docker export !WSL_DOCKER_CONTAINER_ID! ^> !image_save_path!
    # docker export !WSL_DOCKER_CONTAINER_ID! > !image_save_path!

    # get first line of docker_container_id_path
    $WSL_DOCKER_CONTAINER_ID_RAW = @(Get-Content -Path $docker_container_id_path -First 1)
    [String]$WSL_DOCKER_CONTAINER_ID = $WSL_DOCKER_CONTAINER_ID_RAW[0]
    $WSL_DOCKER_CONTAINER_ID_LONG = $WSL_DOCKER_CONTAINER_ID
    $WSL_DOCKER_CONTAINER_ID = $WSL_DOCKER_CONTAINER_ID.Substring(0, 8)
    Write-Host "containerid: `"$WSL_DOCKER_CONTAINER_ID`""

    $new_install_path = "$install_path-$WSL_DOCKER_CONTAINER_ID"
    $old_install_path = $install_path

    Move-Item -LiteralPath $old_install_path -Destination $new_install_path
    $docker_image_id_path = "$new_install_path/.image_id"
    $docker_container_id_path = "$new_install_path/.container_id"

    if ($config -eq "config") {
        
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "Red"     
        Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        Write-Host "!!!!!!       IMPORTANT: type 'exit' to exit this preview           !!!!!!" -ForegroundColor Yellow -BackgroundColor Magenta
        Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!`r`n" -ForegroundColor Red -BackgroundColor Black
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "Cyan"  
        # Write-Host "`r`ndocker attach `"$WSL_DOCKER_CONTAINER_ID`"`r`n`r`n"  
        # docker attach $WSL_DOCKER_CONTAINER_ID
        Write-Host "`r`n        docker exec -it $WSL_DOCKER_CONTAINER_ID_LONG bash
"
        docker exec -it $WSL_DOCKER_CONTAINER_ID_LONG bash
    }

    $docker_img_cont_old_name = "$distro-$WSL_DOCKER_IMG_ID"
    $docker_img_cont_new_name = "$distro-$WSL_DOCKER_CONTAINER_ID"
    # Write-Host docker rename $docker_img_cont_old_name $docker_img_cont_new_name
    # docker rename $docker_img_cont_old_name $docker_img_cont_new_name

    Write-Host "`r`nclosing test container...`r`n========================================================================"

    return $WSL_DOCKER_CONTAINER_ID
}

function export_image {
    param( $install_location, $save_location, $distro, $WSL_DOCKER_CONTAINER_ID)
    # directory structure: 
    # %mount_drive%:\%install_directory%\%save_directory%
    # ie: C:\wsl-distros\docker
    # Write-Host "install_loc: $install_location"
    # Write-Host "save_loc: $save_location"
    # Write-Host "distro: $distro"
    # Write-Host "WSL_DOCKER_CONTAINER_ID: $WSL_DOCKER_CONTAINER_ID"
    # ECHO exporting image (!WSL_DOCKER_IMG_ID!) as container (!WSL_DOCKER_CONTAINER_ID!)...
    # ECHO docker export !WSL_DOCKER_CONTAINER_ID! ^> !image_save_path!
    # docker export !WSL_DOCKER_CONTAINER_ID! > !image_save_path!
    $image_save_path = "$save_location/$distro.tar"
    Write-Host "exporting image as container ($WSL_DOCKER_CONTAINER_ID) into .tar file..."
    Write-Host "docker export $WSL_DOCKER_CONTAINER_ID > $image_save_path"
    Write-Host "this may take a while..."
    docker export $WSL_DOCKER_CONTAINER_ID > $image_save_path
    Write-Host "DONE"
}

function import_docker_tar {
    param([string]$distro, [string]$install_location, [string]$save_location, [string]$wsl_version)
    
    $setdefault = "no"

    Write-Host "`r`n"
    Write-Host "killing the $distro WSL process if it is running..."
    Write-Host "wsl.exe --terminate $distro"
    wsl.exe --terminate $distro
    Write-Host "DONE"
    Write-Host "`r`ndeleting WSL distro $distro if it exists..."
    Write-Host "wsl.exe --unregister $distro"
    wsl.exe --unregister $distro
    Write-Host "DONE"

    $image_save_path = "$save_location/$distro.tar"
    Write-Host "`r`nimporting $distro.tar to $install_location as $distro..."
    Write-Host "wsl.exe --import $distro $install_location $image_save_path --version $wsl_version"
    wsl.exe --import $distro $install_location $image_save_path --version $wsl_version
    Write-Host "DONE"

    if ($install -eq "yes-install") {
        $setdefault = ""
    }
    else {
        Write-Host "`r`n"
        Write-Host "press ENTER to set $distro as default WSL distro"
        Write-Host " ..or enter any character to skip"
        $setdefault = Read-Host -Prompt " $ "
    }
    if ($setdefault -eq "") {
        Write-Host "`r`n"
        Write-Host "setting default WSL distro as $distro..."
        Write-Host  "wsl.exe --set-default $distro "
        wsl.exe --set-default $distro 
        Write-Host "DONE!"
        Write-Host "`r`n"
        Write-Host " ..if starting WSL results in an error, try converting the distro version to WSL1 by running:"
        Write-Host "wsl.exe --set-version $distro 1"
        Write-Host "`r`n"
    }
    return $True
}

function wsl_or_bust {
    param($distro)
    Write-Host "Windows Subsystem for Linux Distributions:"
    wsl.exe -l -v
    Write-Host "`r`n"
    wsl.exe --status
    Write-Host "`r`n"
    Write-Host "press ENTER to open $distro in WSL"
    Write-Host " ..or enter any character to exit "
    $prompt_in = Read-Host " $ "
    if ($prompt_in -eq "") {
        Write-Host "`r`n"
        Write-Host "launching WSL with $distro distro..."
        Write-Host "wsl.exe -d $distro"
        Write-Host "`r`n"
        wsl.exe -d $distro
            
        Write-Host "if WSL fails to start try converting the distro version to WSL1:"
        Write-Host "wsl.exe --set-version $distro 1"
    }

    Write-Host "`r`n"
    Write-Host "goodbye"
    Write-Host "`r`n"
}

$host.UI.RawUI.BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor = "White"

# run the main function
main