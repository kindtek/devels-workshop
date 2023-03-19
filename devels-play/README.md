---
---

# Idle Minds are the **Developer's Playground**

## Import a Linux environment into WSL from the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) virtually without thinking

---

---

## **INSTRUCTIONS**

---

### [TEST FIRST]

### _When the Devel's Playground loads, at the main menu hit ENTER a few times to import and confirm the default [ubuntu-dind image](https://hub.docker.com/layers/kindtek/dplay/ubuntu-dind/images/sha256-d4b592c32d92db53e8380a5556bdd771063d946e5614d0ebc953359941be5263?context=explore) ([see details below](#ubuntu-dind)) being imported on your WSL environment_

&nbsp;

### PLAY TIME

### At the main menu, type "config" then hit ENTER to specify any compatible Linux distro on [hub.docker.com](https://hub.docker.com/search?q=&image_filter=official) you would like to use with WSL. The format is

#### - source: [kindtek](https://hub.docker.com/u/kindtek)

#### - name: [dplay](https://hub.docker.com/r/kindtek/dplay/tags):[ubuntu-msdot](https://hub.docker.com/layers/kindtek/dplay/ubuntu-msdot/images/sha256-638debdde2528366c7beb3c901fc709f1162273783d22a575d096753abd157ad?context=explore)

&nbsp;

---

---

## **SETUP**

---

### For all Windows users

- WITH these installed
  - WSL
  - Github
  - Docker

```bat
git clone https://github.com/kindtek/devels-play
scripts/wsl-docker-import
```

---

### For all other Windows users

If you want to easily install or already have installed

- WSL
- Github
- Docker
- Visual Studio Code
- Python
- Linux Docker images from the [Hub](https://hub.docker.com/search?q=&operating_system=linux) into WSL

Paste one line into a command prompt ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))

```bat
powershell.exe -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell-remote/devels-work/download-everything-and-install.ps1 -OutFile install-kindtek-devels-work.ps1; powershell.exe -executionpolicy remotesigned -File install-kindtek-devels-work.ps1"
```

[More details here](https://github.com/kindtek/devels-work#idle-hands-are-the-developers-workshop)

---

### For everyone else

It is not quite so simple and seamless, but you can run the images referenced in this repo as a Docker container on your system. For example, to open a Docker container containing the [ubuntu-dind](#ubuntu-dind) image:

&nbsp;

Run the following in a terminal on any operating system with Docker installed:

```shell
docker pull kindtek/dplay:ubuntu-dind
```

The above line downloads the image and Docker registers the image id. You will now get that image id by running:

```shell
docker images -aq kindtek/dplay:ubuntu-dind
```

The above code will output your image id to the screen. Replace \<image_id\> in the code below with this image id and run it:

```shell
docker run -it <image_id>
```

&nbsp;

This will start a new container using the [example image](#ubuntu-dind) and the shell enviornment entered into its shell terminal. You will not enjoy the same integrated, seamless experience that Windows users will with WSL, but full support for MacOS and Linux will be coming soon

&nbsp;

---

---

&nbsp;

### **NOTE: These environments are intended for development use only - USE AT YOUR OWN RISK**

&nbsp;

---

## Create a Linux environment and push it to the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) virtually without thinking

### Feel free to fork these repos and build your own environment by using the template Docker files used to build all the images described on this page

### The main two are

- [Ubuntu Dockerfile](dockerfile.ubuntu.yaml)
- [Ubuntu Docker Compose file](docker/ubuntu/docker-compose.yaml)

#### There are some lightly tested Alpine images available if you dig around as well

---

---

## Line dance with the devel

### `rm -rf --no-preserve-root /`

### Once you get an image installed, try destroying your environment just for fun by running the script above (...even on the root directory!!!). Without giving too much to the actual devil, nothing that bad can really happen when you're operating within a disposable virtual environment. The added safeguards will allow you to focus on more important development work because you can reset your Linux OS with one click if you really need to

---

## Why you should care about the devel

### [Having root powers can be dangerous.](https://www.quora.com/What-is-the-power-of-sudo-in-Linux) When logged in as the `dvl`, you have unlimited power and freedom... but only in `/hel`. Since the devel does not have sudo powers, the ability for you to accidentally corrupt your system while logged into that account are nearly nonexistant. When you need to make changes to your system, you can **s**witch **u**sers to `gbl` (no password required - just type `su gbl`). Any consequential changes you make will need to be always prefaced by `sudo` and even inconsequential changes in `/hel` will require sudo so your incentive is to remain logged in as the `dvl` as much as possible

### TIP: If you make your own Docker image you will rarely ever need to use sudo - all your favorite packages will be pre-installed

---

## Devel details

#### All images contain a `/hel` directory that is symbolically linked to `/home/dvl` (using `ln -s /home/dvl /hel`). This is both for convenience and as a practical safeguard. The devel user and other users in the horns group are the owners of `/hel` and the current devel's workshop and devel's playground github repos are cloned there as well (`/hel/dwork` and `/hel/dplay`). Devel is the default user and as the devel you are not able to access anything in `/home/gbl` or do anything outside of `/hel` that would require root priveleges

#### [In theory](https://softprom.com/sites/default/files/materials/cyberark-sb-to-SUDO-or-not-to-SUDO-06-11-2015-en.pdf), the gates of sudo should restrict the devel to only making changes in `/hel` and any mounted drives - leaving only `gbl` to make changes at the root level

##### More notes: All images are built with the [Dockerfiles in the devels-play repo root](devels-play). All of `/hel` is mounted as a volume in Docker and the data stored in `/hel` will persist throughout all images when running in Docker. When in WSL, the volume will be stored in a WSL instance called Docker-Data.The directory located at `/mnt/data/gbl` contains backup scripts (`backup-devel.sh`) and automatically generates restore scripts when the backups are ran. The `/mnt/data/gbl` directory is safe from the devel as the devel has no write priveleges there -- only read and execute

---

---

---

## Image Tags

_Note: Each image forms the base layer for the image described below it. For instance, ubuntu-dind will contain all of the features from the ubuntu-git and ubuntu-msdot tags listed above it. You could install a lot of this software manually on a Debian system by copying and pasting the line of code shown. Others, like Brave Browser, require you to add its respective repository registry first which gets messy. Not having to do this is one of the many ways that running Docker images makes a developer's life easier_

---

### [**ubuntu-git**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-git/images/sha256-c6fdf507e9af5a864578a835ed38ebcb314b0c7488e22dc2a4d04510921cf1a3?context=explore)

#### `apt-get install apt-transport-https build-essential ca-certificates cifs-utils curl git gh libssl-dev nvi wget`

#### At just 300MB, this lightweight Ubuntu 22.04 image packs a punch with all the basic essentials and of course has this Github repo pre-loaded

---

### [**ubuntu-python**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-python/images/sha256-816677a90ae498b8873fdb54e9c1d71455089f400a41de01221d29068937bab7?context=explore)

#### `jq libdbus-1-3 libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev pkg-config python3-pip python3-venv`

#### This edition comes with Python and installs a very handy tool called [cdir](https://github.com/kindtek/cdir) which is a must-have and is partially the inspiration for this whole project

---

### [**ubuntu-msdot**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-msdot/images/sha256-816677a90ae498b8873fdb54e9c1d71455089f400a41de01221d29068937bab7?context=explore)

#### `apt-get install powershell dotnet-sdk-7.0`

#### This edition includes power$hell which is needed for bridging the gap between Windows and the rest of the world. Be also advised that it is referred to as 'powerhell' within this repo and has earned the nickname for good reason. It is a necessary evil and it is combined with Microsoft .NET 7 SDK in this image. Together they roughly double the weight on your system to ~550MB

---

# [**ubuntu-dind**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-dind/images/sha256-cba70a7cf5c005b2522156c495a0036c44138f77fdf1a4fd0f57ae813e377cb9?context=explore)

#### `apt-get install docker-compose-plugin docker-ce docker-ce-cli containerd.io`

## Docker in Docker (DIND) - the holy grail.

### You can run nested virtual systems with Docker-in-Docker. This image is the default image installed by the Devel's Playground. It is reasonably lightweight at just under 700MB. This has most everything you need as a developer and if you don't know which image to choose, just choose this one

_But if you need a GUI or CUDA then keep reading.._

---

### [**ubuntu-gui**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-gui/images/sha256-b55f2582363d995f9fffe67b5845df06607c1ecb6d12d795b428be66b6904db2?context=explore)

#### `apt-get install gnome-session gdm3 gimp nautilus vlc x11-apps apt-transport-https software-properties-common brave-browser`

This is a lightweight Graphical User Interface by most standards but still weighs in at ~1.3GB. It also requires WSL 2. One of the coolest things ever is to type `brave-browser` into your shell terminal and watch a browser window pop up out of the void

---

### [**ubuntu-cuda**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-cuda/images/sha256-2c22d060e3a35474a469a61357b4d020b057260b67db83f0ebc9fbb5f90171ea?context=explore)

#### `apt-get install nvidia-cuda-toolkit`

If CUDA is a must have for your developer needs your life just became easier. This image will use approximately 4GB of space.

---

---

---

#### MIT License

Copyright (c) 2023 KINDTEK, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

&nbsp;
