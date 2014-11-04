# We start with our base OS, Ubuntu 14.04
FROM ubuntu:14.04

# This Dockerfile is HEAVILY based on David Keppler "dave@kepps.net" version
MAINTAINER Mike Wallace "mike.wallace@risesoftware.com"

# Add the repositories needed for the packages we're going to install
# These are added to the Ubuntu base, not your host operating system. As are all the packages.
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-security multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-security multiverse" >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

# make multiarch work (only a 14.04 thing?)
RUN dpkg --add-architecture i386

RUN apt-get -qq update
RUN apt-get -qqy upgrade

# install all of the tools and libraries that we need.
RUN apt-get install -y git gnupg flex bison gperf build-essential \
            zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
            libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
            libgl1-mesa-dev g++-multilib gcc-multilib mingw32 tofrodos \
            python-markdown libxml2-utils xsltproc zlib1g-dev:i386 \
            libswitch-perl qemu-utils virtualbox

RUN apt-get install -y software-properties-common python-software-properties

# Install Oracle Java 6
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -qq update
RUN echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java6-installer
RUN update-java-alternatives -s java-6-oracle
RUN apt-get install oracle-java6-set-default

# Extras that android-x86.org and android-ia need
RUN apt-get install -y gettext python-libxml2 yasm bc
RUN apt-get install -y squashfs-tools genisoimage dosfstools mtools

# Adding a user called 'builder' and setting up CCACHE
RUN useradd --create-home builder
RUN echo "export USE_CCACHE=1" >> /etc/profile.d/android
ENV USE_CCACHE 1

USER builder

ENV HOME /home/builder

# End of the Dockerfile

# I'm leaving these installation instructions for different Java versions in case you need them.

# Install JDK6
#ADD jdk-6u45-linux-x64.bin /opt/jdk-6u45-linux-x64.bin
#RUN chmod a+x /opt/jdk-6u45-linux-x64.bin
#WORKDIR /opt
#RUN /opt/jdk-6u45-linux-x64.bin
#RUN /bin/sh -c 'cd /usr/local/bin ; for i in /opt/jdk1.6.0_45/bin/* ; do ln -s $i ; done'
#RUN echo "export PATH=${PATH}:/opt/jdk1.6.0_45/bin" >> /etc/profile.d/java
#RUN echo "export JAVA_HOME=/opt/jdk1.6.0_45" >> /etc/profile.d/java

# Install Oracle Java 7
#RUN sudo add-apt-repository ppa:webupd8team/java
#RUN sudo apt-get -qq update
#RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
#RUN sudo apt-get install -y oracle-java7-installer
#RUN update-java-alternatives -s java-7-oracle
#RUN apt-get install oracle-java7-set-default
