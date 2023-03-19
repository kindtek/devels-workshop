@echo off
SETLOCAL EnableDelayedExpansion

@REM this is useful for when docker refuses to start due to a bad wsl distro set as default or ...
@REM ..if docker hangs when it tries to start
@REM also try deleting the .docker folder in user directory (C:\Users\xxxx)

SET prompt=prompt

:prompt
ECHO:
ECHO  running this in linux fixes 90% of Docker connection problems: 
ECHO  'unset DOCKER_HOST'
ECHO:
ECHO:
ECHO  [s]soft docker restart (admin req)
ECHO  [u]nregister docker desktop containers
ECHO  [h]ard docker service start (admin req)
ECHO  [r]eset wsl default distro
ECHO   [reboot] windows (^^!^^!)
ECHO   [q]uit

SET /p "prompt=$ "
goto !prompt!

:s
net stop docker
net stop com.docker.service
taskkill /IM "dockerd.exe" /F
taskkill /IM "Docker Desktop.exe" /F
net start docker
net start com.docker.service
"C:\Program Files\Docker\Docker\resources\dockerd.exe"
"C:\Program Files\Docker\Docker\Docker Desktop.exe"
goto prompt

:u
@REM force restart for docker containers
@REM wsl --unregister docker-desktop
@REM wsl --unregister docker-desktop-data
docker update --restart=always docker-desktop
docker update --restart=always docker-desktop-data
"C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon




















@REM -SwitchLinuxEngine
@REM -SwitchWindowsEngine
@REM -Start
@REM -Stop
@REM -SendDiagnostic
@REM -ResetToDefault
@REM -ResetCredential
@REM -DownloadMobyLogs
@REM -DownloadVpnKitLogs
@REM -MoveVhd
@REM -Mount=
@REM -Unmount=
@REM -Wait=
@REM -SetMemory=
@REM -SetCpus=
@REM -SetDNS=
@REM -SetIP=
@REM -SetDaemonJson=
@REM -SetWindowsDaemonJson=

@REM dockerd --containerd /var/run/dev/docker-containerd.sockgoto prompt
@REM file::
@REM {
@REM   "default-runtime": "runc",
@REM   "runtimes": {
@REM     "custom": {
@REM       "path": "/usr/local/bin/my-runc-replacement",
@REM       "runtimeArgs": [
@REM         "--debug"
@REM       ]
@REM     },
@REM     "runc": {
@REM       "path": "runc"
@REM     }
@REM   }
@REM }
@REM 
@REM {
@REM   "builder": {
@REM     "gc": {
@REM       "defaultKeepStorage": "20GB",
@REM       "enabled": true
@REM     }
@REM   },
@REM   "experimental": false,
@REM   "features": {
@REM     "buildkit": true
@REM   }
@REM }

@REM  dockerd --add-runtime runc=runc --add-runtime custom=/usr/local/bin/my-runc-replacement

:h
"C:\Windows\System32\net.exe" start "com.docker.service"
goto prompt

@REM reset default wsl distro
:r
wsl -s Ubuntu-20.04
goto prompt

:reboot
@REM restart windows
@REM shutdown -r -t 0

:q
:quit
:exit
:end
:x