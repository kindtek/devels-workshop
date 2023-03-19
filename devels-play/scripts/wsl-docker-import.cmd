@echo off
@REM this file is solid but will be deprecated once wsl-import.ps1 is fixed
color 0F
SETLOCAL EnableDelayedExpansion
:redo

SET default=default
SET wsl_version=1
SET save_directory=docker2wsl
SET mount_drive=C

@REM SET image_repo=_
@REM SET image_repo_mask=official
@REM SET image_name=ubuntu:latest
SET image_repo=kindtek
SET image_repo_mask=kindtek
SET "image_tag=ubuntu-dind"
SET image_name=dplay:%image_tag%

SET "install_directory=%image_repo_mask%-%image_name::=-%"
SET "save_location=%mount_drive%:\%save_directory%"
SET "install_location=%save_location%\%install_directory%"
@REM distro - meaning local distro
SET "distro=%install_directory%"
@REM :header
SET "image_save_path=%save_location%\%distro%.tar"
SET "install_location=%save_location%\%install_directory%"
SET "image_repo_image_name=%image_repo%/%image_name%"
@REM special rule for official distros on docker hub
@REM replaces '_' with 'official' for printing
IF %image_repo%==_ (
    @REM official repo has no repo name in address/url
    SET "image_repo_image_name=%image_name%"
) 
SET "docker_image_id_path=%install_location%\.image_id"
SET "docker_container_id_path=%install_location%\.container_id"

@REM CLS

ECHO:
ECHO  _____________________________________________________________________ 
ECHO /                          DEVEL'S PLAYGROUND                         \
ECHO \______________  WSL import tool for Docker Hub images  ______________/
ECHO   -------------------------------------------------------------------
ECHO   .............    Image settings                       .............
ECHO   .............-----------------------------------------.............
ECHO   .............    source:                              .............
ECHO   .............      !image_repo_mask!                            .............
ECHO   .............                                         .............
ECHO   .............    name:                                .............
ECHO   .............      !image_name!                   .........
ECHO   .............                                         .............
ECHO   .............    download to:                         .............
ECHO   .............       !image_save_path! 
ECHO   .............                                         .............
ECHO   .............    WSL alias:                           .............
ECHO   .............       !distro!          .........
ECHO   -------------------------------------------------------------------

ECHO:
ECHO:
ECHO Press ENTER to use settings above and import %distro% as default WSL distro 
ECHO:
ECHO   ..or type 'config' for custom install.
ECHO   ..or type 'x' to exit
@REM @TODO: add options ie: 
@REM ECHO   ..or type:
@REM ECHO           - 'registry' to specify distro from a registry on the Docker Hub
@REM ECHO           - 'image' to import a local Docker image
@REM ECHO           - 'container' to import a running Docker container
@REM @TODO: (and eventually add numbered menu)
ECHO:
ECHO:
SET /p "default=$ "

:custom_config

@REM prompt user to type input or hit enter for default shown in parentheses
if %default%==config (

    color 0B

    @REM @TODO: filter/safeguard user input
    ECHO:
    SET /p "image_repo=image repository: (!image_repo_mask!) $ "

    SET /p "image_name=image name in !image_repo_mask!: (!image_name!) $ "

    @REM special rule for official distros on docker hub
    @REM replaces '_' with 'official' for printing
    IF "!image_repo!"=="_" (
        SET "image_repo_image_name=!image_name!"
    ) ELSE (
        SET "image_repo_mask=!image_repo!"
        SET "image_repo_image_name=!image_repo_mask!/!image_name!"
    )

    SET /p "save_directory=download folder: !mount_drive!:\(!save_directory!) $ "
    SET install_directory=!image_repo_image_name:/=-!
    SET install_directory=!install_directory::=-!

    SET /p "install_directory=install folder: !mount_drive!:\!save_directory!\(!install_directory!) $ "
    SET install_directory=!install_directory:/=-!
    SET install_directory=!install_directory::=-!
    @REM not possible to set this above bc it will overlap with the default initializing so set it here
    SET save_location=!mount_drive!:\!save_directory!
    SET install_location=!save_location!\!install_directory!
    @REM special rule for official distro
    if "!image_repo!"=="_" (
        SET "distro=official-!install_directory!"
    ) ELSE (
        SET "distro=!install_directory!" 
    )

    SET /p "distro=distro name in WSL: (!distro!) $ "
    SET "distro=!distro::=-!"
    SET "distro=!distro:/=-!"

    SET /p "wsl_version=WSL version: (1) $ "
    if "!wsl_version!"=="2" (
        SET "wsl_version=2"
    ) ELSE (
        SET "wsl_version=1" 
    )

    color 0F
) ELSE (
    IF %default%==x (
        goto quit
    )
)


SET docker_image_id_path=%install_location%\.image_id
SET docker_container_id_path=%install_location%\.container_id
SET image_save_path=%save_location%\%distro%.tar

@REM directory structure: 
@REM %mount_drive%:\%install_directory%\%save_directory%
@REM ie: C:\wsl-distros\docker
mkdir !save_location! > nul 2> nul
mkdir !install_location! > nul 2> nul

:docker_image_container_start

ECHO ========================================================================
ECHO:
ECHO pulling image (!image_repo_image_name!)...
ECHO docker pull !image_repo_image_name!
@REM pull the image
docker pull !image_repo_image_name!
ECHO:
ECHO initializing the image container...
@REM @TODO: handle WSL_DOCKER_IMG_ID case of multiple ids returned from docker images query
ECHO "docker images -aq !image_repo_image_name! > !docker_image_id_path!"
docker images -aq !image_repo_image_name! > !docker_image_id_path!
SET /P WSL_DOCKER_IMG_ID_RAW=< !docker_image_id_path!
@REM ECHO WSL_DOCKER_IMG_ID_RAW: %WSL_DOCKER_IMG_ID_RAW%
SET WSL_DOCKER_IMG_ID=%WSL_DOCKER_IMG_ID_RAW%
del !docker_container_id_path! > nul 2> nul

IF %default%==config (
    ECHO: 
    ECHO ========================================================================
    ECHO:
    ECHO opening container preview...
    ECHO:
    ECHO:
    ECHO:
    ECHO this container is running as a local copy of the image !image_repo_image_name!
    ECHO:
    ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
    ECHO ^^!^^!^^!^^!^^!^^! IMPORTANT: type 'exit' then ENTER to exit container preview ^^!^^!^^!^^!^^!^^!
    ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
    ECHO:
    ECHO:
    color 02
    ECHO docker run -it --cidfile !docker_container_id_path! !WSL_DOCKER_IMG_ID!
    docker run -it --cidfile !docker_container_id_path! !WSL_DOCKER_IMG_ID!
    color 0F
    ECHO:
    ECHO closing preview container...
    ECHO:
    ECHO ========================================================================
) ELSE (
    ECHO docker run -dit --cidfile !docker_container_id_path! !WSL_DOCKER_IMG_ID!
    docker run -dit --cidfile !docker_container_id_path! !WSL_DOCKER_IMG_ID! 
)

SET /P WSL_DOCKER_CONTAINER_ID=<!docker_container_id_path! > nul
if "!WSL_DOCKER_CONTAINER_ID!"=="" (
    ECHO An error occurred. Missing container ID. Please restart and try again
    goto exit
)
ECHO:
ECHO exporting image (!WSL_DOCKER_IMG_ID!) as container (!WSL_DOCKER_CONTAINER_ID!)...
ECHO docker export !WSL_DOCKER_CONTAINER_ID! ^> !image_save_path!
docker export !WSL_DOCKER_CONTAINER_ID! > !image_save_path!
ECHO DONE

:wsl_list
ECHO ---------------------------------------------------------------------
ECHO Windows Subsystem for Linux Distributions:
wsl -l -v
ECHO ---------------------------------------------------------------------
ECHO Check the list of current WSL distros installed on your system above. 
ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!                   WARNING:                ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
ECHO If !distro! is already listed above it will be REPLACED.  
ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
ECHO _____________________________________________________________________

:install_prompt
ECHO:
ECHO Would you still like to continue (y/n/redo)?
SET /p "continue="

@REM if blank -> yes 
IF "%continue%"=="" ( 
    SET continue=y
)

@REM if y -> yes 
IF %continue%==y ( 
    SET continue=install
)

@REM if n -> no
IF %continue%==n ( 
    SET continue=no
)

@REM if label exists goto it
goto %continue%

@REM otherwise... use the built in error message and repeat install prompt
goto install_prompt

@REM EASTER EGG1: typing yes at first prompt bypasses cofirm and restart the default distro
@REM EASTER EGG2: typing yes at second prompt (instead of 'y' ) makes distro default

:yes
:install
ECHO:
ECHO killing the !distro! WSL process if it is running...
ECHO wsl --terminate !distro!
wsl --terminate !distro!
ECHO DONE
@REM ECHO:
@REM ECHO killing all WSL processes...
@REM wsl --shutdown
@REM ECHO DONE
if default==yes (
    ECHO:
    ECHO deleting WSL distro !distro! if it exists...
    ECHO wsl --unregister !distro!
    wsl --unregister !distro!
    ECHO DONE
)

ECHO:
ECHO importing !distro!.tar to !install_location! as !distro!...
ECHO wsl --import !distro! !install_location! !image_save_path! --version !wsl_version!
wsl --import !distro! !install_location! !image_save_path! --version !wsl_version!
ECHO DONE

if default==yes (
    goto set_default
) ELSE (
    ECHO: 
    ECHO press ENTER to set !distro! as default WSL distro
    ECHO  ..or enter any character to skip
    SET /p "setdefault=$ "
    IF "!setdefault!"=="" (

:set_default
        ECHO:
        ECHO setting default WSL distro as !distro!...
        ECHO  wsl --set-default !distro! 
        wsl --set-default !distro! 
        ECHO DONE!
        ECHO:
        ECHO  ..if starting WSL results in an error, try converting the distro version to WSL1 by running:
        ECHO wsl --set-version !distro! 1
        ECHO:
        goto wsl_or_exit
    )

)

:wsl_or_exit
@REM make sure windows paths transfer
SET WSLENV=USERPROFILE/p
ECHO Windows Subsystem for Linux Distributions:
wsl -l -v
ECHO:
wsl --status
ECHO:
ECHO press ENTER to open !distro! in WSL
ECHO  ..or enter any character to skip 
@REM make sure windows paths transfer
SET WSLENV=USERPROFILE/p 
SET /p "exit=$ "
IF "%exit%"=="" (
    ECHO:
    ECHO launching WSL with !distro! distro...
    ECHO wsl -d !distro!
    ECHO:
    wsl -d !distro!
        
    ECHO if WSL fails to start try converting the distro version to WSL1:
    ECHO wsl --set-version !distro! 1
)
:quit
:no
:exit
ECHO:
ECHO exiting Devel's Playground ...
ECHO:
