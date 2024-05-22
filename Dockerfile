# Build environment in docker for act

FROM catthehacker/ubuntu:act-22.04

ARG MIRROR=mirrors.huaweicloud.com

RUN sed -i "s@http://.*archive.ubuntu.com@http://${MIRROR}@g" /etc/apt/sources.list \
    && sed -i "s@http://.*security.ubuntu.com@http://${MIRROR}@g" /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y \
    sudo \
    lshw \
    ack antlr3 aria2 asciidoc autoconf automake autopoint binutils bison build-essential bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python3 python3-pip libpython3-dev qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && git config --system http.sslVerify false

ARG USER=op

RUN useradd -m -G sudo -s /bin/bash ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER}

USER ${USER}
WORKDIR /home/${USER}
