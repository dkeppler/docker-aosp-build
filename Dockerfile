FROM ubuntu:14.04
MAINTAINER David Keppler "dave@kepps.net"

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-security multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-security multiverse" >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

# make multiarch work
RUN dpkg --add-architecture i386

RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN apt-get install -y git gnupg flex bison gperf build-essential \
            zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
            libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
            libgl1-mesa-dev g++-multilib gcc-multilib mingw32 tofrodos \
            python-markdown libxml2-utils xsltproc zlib1g-dev:i386 \
            libswitch-perl qemu-utils virtualbox

# Install repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
RUN chmod a+x /usr/local/bin/repo

# Install JDK6
ADD jdk-6u45-linux-x64.bin /opt/jdk-6u45-linux-x64.bin
RUN chmod a+x /opt/jdk-6u45-linux-x64.bin
WORKDIR /opt
RUN /opt/jdk-6u45-linux-x64.bin
RUN /bin/sh -c 'cd /usr/local/bin ; for i in /opt/jdk1.6.0_45/bin/* ; do ln -s $i ; done'
RUN echo "export PATH=${PATH}:/opt/jdk1.6.0_45/bin" >> /etc/profile.d/java
RUN echo "export JAVA_HOME=/opt/jdk1.6.0_45" >> /etc/profile.d/java

RUN useradd --create-home buildbot
RUN echo "export USE_CCACHE=1" >> /etc/profile.d/android

USER buildbot
WORKDIR /home/buildbot/android
VOLUME /home/buildbot/android
