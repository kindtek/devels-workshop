# Idle Hands are the **Developer's Workshop**

## Import a Linux Docker image from the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) into WSL _virtually_ without lifting a finger

---

---

## SETUP

### Easy as 1, 2, .., 4

```bat
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-gui-kernel"


```

1. copy/pasta the above line of code into a terminal ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))
2. press the ENTER, 'y', or 'n' key a few times and log in to your machine between restarts
3. ??
4. profit



---

## With little more than a few key strokes and restarts, a suite of tightly connected developer productivity software will be pushed to your Windows 10+ machine. Easily rename/backup/restore your WSL distributions, hit the ground coding with VSCode, become a cybersecurity expert with Kali without debugging obscure error codes

![wsl_docker_devel](doc/devel_ui.png)

![kali_gui](doc/kali_gui.png)

### Set up occurs so smoothly that you will likely feel like you skipped step 3 -- especially if you've been tripped up by any of these tricky procedures _(ie : installing WSL, Github, Docker, seting up SSH logins with Github and Docker, manually adding new app registries, building a kernel, installing a GUI on Linux)_ in the past. But don't worry, as long as you keep repeating step 1, have a reliable internet connection, and a handful of spare gigabytes, you are good to go - there is no technical expertise required. You can use some of the time you're saving during the installation process to make an informed choice on what shiny new toy you want to play with first. You can either try out your freshly installed WSL distribution and use Kali Linux to go straight to `/hel` in a ~~hand..~~ [sandboxed user environment](https://github.com/kindtek/devels-playground#line-dance-with-the-devel) or use the devel's playground to try out any of the thousands of Docker Linux images on the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) integrated seamlessly with ur machine. Check out this summary of user environments [images offered by Kindtek](https://github.com/kindtek/devels-playground#image-tags) that you can set as your main WSL environment with the devels-playground

## At the end of the installation sequence, your WSL environment will be pushed a ~250MB [image](https://github.com/kindtek/devels-playground#kali-dind) and the capability to contribute to this repository using either Github or Docker immediately

---

### All of the menial technical labor is eliminated so you can get straight to the good stuff. Fork this repository and see how easy it is to set up your use the code as a template for setting up software that revolves around a Github repo like this one

### The Docker Linux images [created by Kindtek](https://github.com/kindtek/devels-playground#image-tags) and hosted by [Docker](https://hub.docker.com/repository/docker/kindtek/dvlp) on the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) are available for free.

### Got an idea, suggestion, need help, or find a bug? Feel free to create an [issue](https://github.com/kindtek/devels-workshop/issues) or [pull request](https://github.com/kindtek/devels-workshop/pulls)

---

&nbsp;

## All in a day's work

## Now time for the fun stuff

## **Instructions for choosing an image from [hub.docker.com](https://hub.docker.com/search?q=&image_filter=official) and the official [kindtek devel's playground docker hub repo](https://hub.docker.com/r/kindtek/dvlp/tags) into WSL with the devel's playground are [found here](https://github.com/kindtek/devels-playground#idle-minds-are-the-developers-playground)**

&nbsp;

## NEW FEATURES

## Build a kernel and pop into a Kali KEX GUI with [kali-gui-kernel](https://hub.docker.com/r/kindtek/devels-playground/tags)

No setup necessary ( !!! )

### [CLICK for more details](https://github.com/kindtek/devels-playground#idle-minds-are-the-developers-playground)

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
