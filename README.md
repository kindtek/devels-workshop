# Idle Hands are the **Developer's Workshop**

## Import a Linux Docker image from the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) into WSL _virtually_ without lifting a finger

---

---

## SETUP

### Easy as 1, 2, .., 4

```bat
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-cli"


```

1. copypasta the above line of code into a terminal ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))
2. follow instructions and log in to your machine between restarts
3. ??
4. profit

---

## With little more than a few key strokes and restarts, a suite of interconnected developer productivity software will be pushed to your Windows 10+ machine. The list of new capabilites added to your toolbox in this automated process is practically endless. Easily rename/backup/restore your WSL distributions, hit the ground coding in WSL with VSCode, configure the latest bleeding edge builds of Linux kernels for your system, etc, etc. You can even even put on your white hat and help Ukraine bring Russia's war to an end with [Kali Linux OS](https://www.kali.org/docs/wsl/win-kex/). Okay, perhaps achieving world peace is overselling it... but with the devels-workshop you never know what the devel may do. Should you choose to do so, uninstalling everything introduced to your system by the devel's workshop is effortless as well

# BONUS: if you have ever had problems with Windows Docker Desktop crashing (and/or WSL) you are in the right place. Included in the devels workshop is an automatic troubleshooting tool to keep you online without worrying about your productivity coming to an abrupt halt

![wsl_docker_devel](doc/devel_ui.png)

![kali_gui](doc/kali_gui.png)

### Installation is so smooth that you will likely feel like you skipped a step -- especially if you have tangled with any of the several automated procedures included _(ie : setting up your system with automated builds for your Github/Docker repository, installing WSL with systemd or Docker-in-Docker, issuing keys for SSH logins, manually adding new app registries, building a Linux kernel from scratch, installing a Linux GUI on WSL, etc, etc)_. But don't worry, as long as you keep repeating step 2, have a reliable internet connection, and a handful of spare gigabytes on your machine, you are good to go - there is no technical expertise required. You can use some of the time you're saving (and waiting for the install to complete) to make an informed choice on what shiny new toy you want to play with first. You can either try out your freshly installed WSL distribution and use Kali Linux to go straight to `/hel` in a ~~hand..~~ [sandboxed user environment](https://github.com/kindtek/devels-playground#line-dance-with-the-devel) or use the devel's playground to try out any of the thousands of Docker Linux images on the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) integrated seamlessly with your machine. Check out the summary of user environments images offered by Kindtek [here](https://github.com/kindtek/devels-playground#image-tags)

## At the end of the installation sequence, your WSL environment will be pushed a ~250MB [image](https://github.com/kindtek/devels-playground#kali-cli) and the capability to contribute to this repository using either Github or Docker immediately. The script you are running bootloads and installs all dependencies before presenting you with a command line integrated with both Windows and any/every Linux subsystem, Docker, Github, and anything you want -- maybe you could be the one to add add a search engine or AI troubleshooter? If you seriously considered the previous statement you will find it easy to contribute and/or build your own ideas by [making a pull request](https://github.com/kindtek/devels-workshop/pulls) or [forking this repository](https://github.com/kindtek/devels-workshop/fork) 

---

### The Docker Linux images created by Kindtek and hosted by Docker on the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) are available for free [here](https://github.com/kindtek/devels-playground#image-tags)

### Find a bug? Feel free to create an [issue](https://github.com/kindtek/devels-workshop/issues) or submit a patch with a [pull request](https://github.com/kindtek/devels-workshop/pulls)

### Note 1: This project currently is in alpha status (although it is rapidly approaching beta). It is to be used only for development purposes until an official stable version is released

### Note 2: The full edition of the devels-workshop is currently only available for Windows. A loose integration using the [devels-playground](https://github.com/kindtek/devels-playground#idle-minds-are-the-developers-playground) is available for Linux. Mac and OpenBSD integration will be here before you know it

---

&nbsp;

## All in a day's work

## Now time for the fun stuff

## **Helpful descriptions for images available to import from the [kindtek devels-playground docker hub repo](https://hub.docker.com/r/kindtek/dvlp/tags) are [found here](https://github.com/kindtek/devels-playground#idle-minds-are-the-developers-playground)**

&nbsp;

## NEW FEATURES

## Build a kernel and pop into a [Kali KEX GUI](https://www.kali.org/docs/wsl/win-kex/) with [kali-gui-kernel-goodies](https://hub.docker.com/r/kindtek/devels-playground/tags)

### just copypasta this:

```bat
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-gui-kernel-goodies"


```

### [CLICK for more details](https://github.com/kindtek/devels-playground#kali-gui-goodies)

Tip: you can easily install all features at a later time even with the basic image, kali-cli [instructions for install here](https://github.com/kindtek/devels-workshop#setup). However, what you gain in flexibility is lost in the extra time it takes to install

---

---

&nbsp;

MIT License

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
