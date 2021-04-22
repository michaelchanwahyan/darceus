# Dockerfile for building general development
# environment for orbital
FROM ubuntu:18.04
LABEL maintainer "michaelchan_wahyan@yahoo.com.hk"

ENV SHELL=/bin/bash \
    TZ=Asia/Hong_Kong \
    PYTHONIOENCODING=UTF-8 \
    PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/lib:/usr/local/lib:/SOURCE/udsdk/include:/SOURCE/udsdk/lib/ubuntu18.04_GCC_x64:/SOURCE/udsdksamples/external/stb:/SOURCE/udsdksamples/external/udcore/Include:/SOURCE/udsdksamples/languages/cpp/build \
    LD_LIBRARY_PATH=/usr/local/lib:/SOURCE/orbital/build:/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib:/SOURCE/udsdk/include:/SOURCE/udsdk/lib/ubuntu18.04_GCC_x64:/SOURCE/udsdksamples/languages/cpp/lib:/SOURCE/udsdksamples/external/stb:/SOURCE/udsdksamples/external/udcore/Include:/SOURCE/udsdksamples/languages/cpp/build \
    LIBRARY_PATH=/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib:/SOURCE/udsdk/include:/SOURCE/udsdk/lib/ubuntu18.04_GCC_x64:/SOURCE/udsdksamples/languages/cpp/lib:/SOURCE/udsdksamples/external/stb:/SOURCE/udsdksamples/external/udcore/Include:/SOURCE/udsdksamples/languages/cpp/build \
    CPLUS_INCLUDE_PATH=/SOURCE/orbital \
    BOOST_SYSTEM_LIBRARY=/SOURCE/boost-1.61.0/bin.v2/libs

RUN apt-get -y update ;\
    apt-get -y upgrade

RUN apt-get -y install screen apt-utils htop wget curl net-tools \
        cmake gcc make g++ gfortran ca-certificates musl-dev fortune \
        vim nano git apt-transport-https bc doxygen firefox cowsay sl

#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install xorg openbox \
#        xauth xserver-xorg-core xserver-xorg ubuntu-desktop x11-xserver-utils

# in order to run the x11 forward from container to host machine
# we need to execute `xhost +local:docker` in host machine to
# give docker the rights to access the X-Server
# ref: https://forums.docker.com/t/start-a-gui-application-as-root-in-a-ubuntu-container/17069

RUN mkdir -p /SOURCE /data

RUN echo /usr/local/lib >> /etc/ld.so.conf ;\
    ldconfig

COPY [ ".bashrc" , ".vimrc" , "/root/" ]

CMD [ "/bin/bash" ]
