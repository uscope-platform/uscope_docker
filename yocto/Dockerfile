FROM ubuntu:bionic

WORKDIR /yocto

# Setup timezone
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install git and yocto dependencies
RUN apt-get update
RUN apt-get -y install build-essential dialog apt-utils gawk git diffstat unzip gcc-multilib socat python3 chrpath cpio diffstat gawk texinfo python wget nano locales python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm xvfb dbus dbus-x11 curl xorg-docs
RUN cd /usr/bin && curl https://storage.googleapis.com/git-repo-downloads/repo > repo && chmod a+x repo

# Generate and set locale for Xilinx crappy stuff (it only works with en_us.utf-8)
RUN locale-gen "en_US.UTF-8"
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8    

RUN useradd -ms /bin/bash fils
RUN chown -R fils:fils /yocto
USER fils

RUN repo init -u git://github.com/Xilinx/yocto-manifests.git -b rel-v2020.1
RUN repo sync
RUN repo start rel-v2020.1 --all

RUN cd sources && git clone -b zeus git://git.yoctoproject.org/meta-java

# Apply patch to force microzed-zynq7 machine to use uboot-xlnx
COPY microzed_compatibility.patch /yocto/sources/meta-xilinx/microzed_compatibility.patch
RUN cd /yocto/sources/meta-xilinx && git apply microzed_compatibility.patch && rm microzed_compatibility.patch


COPY local.conf /yocto/build/conf/local.conf
COPY bblayers.conf /yocto/build/conf/bblayers.conf
USER root
RUN apt-get -y install docbook-xsl
RUN chown -R fils:fils /yocto/build
USER fils

RUN echo "source /fast_software/Vitis/2020.1/settings64.sh"  >> /home/fils/.bashrc


#ENTRYPOINT [ "/yocto/setupsdk" ]

CMD [ "/bin/bash" ]
