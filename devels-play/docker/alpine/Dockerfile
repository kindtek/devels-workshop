# to build, for exemple, run: 
# `username=mine groupname=ours docker run -d -i`
FROM alpine:latest AS dplay_skel
ARG username=${username:-gbl
ARG groupname=${groupname:-archan}

# set up basic utils
RUN apk update && \
    apk upgrade && \
    # install github, build-essentials, libssl, etc
    apk add git github-cli build-base libressl-dev ca-certificates wget curl gnupg \
    lsb-release python3 py3-pip shadow musl libgcc libstdc++ g++ make vips-dev

# set up group/user 
# RUN addgroup -S -g 1000 ${groupname} 
# RUN adduser -SD -h /home/${username} -s /bin/bash -u 1000 ${username}
# RUN addgroup -S ${groupname} && adduser -S -s /bin/ash -h /home/${username} -G ${groupname} ${username}
# create groups
RUN addgroup -g 1001 ${groupname} && \
    addgroup -g 1008 devbp
# add ${username} user
RUN adduser -h /home/${username} -s /bin/ash -G ${groupname} -u 1001 ${username} -D
# add ${username} to groups
RUN addgroup ${username} devbp && \
    addgroup ${username} ${groupname} && \
    addgroup root devbp

# make default user and ensure no password
RUN echo "[user]\ndefault=${username}" >> /etc/wsl.conf

USER ${username}:devbp
# install cdir - an absolute lifesaver for speedy nav in an interactive cli (cannot be root for install)
# update all the paths
RUN pip3 install cdir --user && \
    echo "alias cdir='source cdir.sh'" >> ~/.bashrc 

USER root:devbp
# update all the paths (with etc/skel)
RUN export PATH=$PATH:\~/.local/bin:/usr/.local/bin
RUN install -d -g devbp -m 775 ./home/${username}/.local/bin /usr/.local
RUN install -d -g devbp -m 775 ./home/${username} /etc/skel

RUN adduser -s /bin/ash -h /home/dvl -G wheel dvl -D && \
    addgroup dvl devbp
# RUN sed -e 's;^# \(%wheel.*NOPASSWD.*\);\1;g' -i /etc/sudoers
# RUN addgroup ${username} wheel

# non-root will need to use sudo from now on
RUN apk add sudo 
# add dvl and ${username} to sudo group
# sudo adduser ${username} sudo && \
# sudo adduser dvl sudo

# ensure no one has a passwd 
# RUN sudo passwd -d dvl &&  sudo passwd -d ${username} && 
RUN sudo passwd -d root && \
    sudo passwd -l root && \
    sudo passwd -d dvl && \
    sudo passwd -d  ${username}
USER ${username}:devbp
WORKDIR /home/${username}

FROM dplay_skel AS dplay_msdot
USER root:devbp
# TODO: add audio support with - alsa-base pulseaudio (ubuntu packages need to be verified/updated for alpine)
RUN apk update && \
    apk upgrade && \
    apk add dpkg gnupg plasma-desktop systemsettings sddm breeze elogind polkit-elogind udev \
    dbus-x11 openrc elogind polkit pulseaudio
RUN rc-update add dbus && rc-update add elogind && rc-update && rc-update add udev
COPY --chown=0:0 --from=kasmweb/brave:1.12.0 . .

USER ${username}:devbp

# TODO: make brave work
# for brave install - https://linuxhint.com/install-brave-browser-alpine/
# RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
# RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main"| tee /etc/apt/sources.list.d/brave-browser-release.list
# for docker install - https://docs.docker.com/engine/install/alpine/
# RUN sudo mkdir -p /etc/apt/keyrings && \
#   curl -fsSL https://download.docker.com/linux/alpine/gnupg | sudo gnupg --dearmor -o /etc/apt/keyrings/docker.gpg
# RUN echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/alpine \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# brave browser/gui/media/docker support
# RUN apk update && apk add gedit gimp nautilus vlc x11-apps apt-transport-https brave-browser
# USER ${username}

# TODO: https://github.com/mbacchi/brave-docker

FROM dplay_msdot as dplay_msdott
USER root:devbp
ARG ALPINE_VERSION=${ALPINE_VERSION:-v3.17}
# VSCODE
# RUN apk add code-server
# DOCKER
# COPY --chown=0:0 --from=alpinelinux/docker-alpine ./ /
# COPY --chown=0:0 --from=0 ./etc /etc

# GNOME
RUN echo "@alpine-comm-reg http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/community/" >> /etc/apk/repositories
# RUN echo "set shared/default-x-display-manager lightdm" | debconf-communicate
RUN echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
RUN apk add gnome@alpine-comm-reg
# RUN apk add gnome-apps-extra

USER ${username}:devbp


# RUN sudo -S apk add docker-ce docker-ce-cli containerd.io docker-compose-plugin

# username=dev08 groupname=wheel docker compose -f docker-compose.ubuntu.yaml build
# username=dev08 groupname=wheel docker compose -f docker-compose.alpine.yaml build