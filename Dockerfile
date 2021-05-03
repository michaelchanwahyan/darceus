# Dockerfile for building general development
# environment for arceus
FROM ubuntu:18.04
LABEL maintainer "michaelchan_wahyan@yahoo.com.hk"

# =================
#     part 1
#   basic env setup
# =================
ENV SHELL=/bin/bash \
    TZ=Asia/Hong_Kong \
    PYTHONIOENCODING=UTF-8 \
    HADOOP_COMMON_HOME=/hadoop-2.7.7 \
    HADOOP_HDFS_HOME=/hadoop-2.7.7 \
    HADOOP_HOME=/hadoop-2.7.7 \
    HADOOP_CONF_DIR=/hadoop-2.7.7/etc/hadoop \
    HADOOP_COMMON_LIB_NATIVE_DIR=/hadoop-2.7.7/lib/native \
    HADOOP_INSTALL=/hadoop-2.7.7 \
    HADOOP_MAPRED_HOME=/hadoop-2.7.7 \
    JAVA_HOME=/jdk1.8.0_171 \
    PYSPARK_DRIVER_PYTHON="jupyter" \
    PYSPARK_DRIVER_PYTHON_OPTS="notebook" \
    PYSPARK_PYTHON=python3 \
    SPARK_HOME=/spark-2.4.0-bin-hadoop2.7 \
    SPARK_PATH=/spark-2.4.0-bin-hadoop2.7 \
    YARN_HOME=/hadoop-2.7.7 \
    PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/lib:/usr/local/lib:/SOURCE/udsdk/include:/SOURCE/udsdk/lib/ubuntu18.04_GCC_x64:/SOURCE/udsdksamples/external/stb:/SOURCE/udsdksamples/external/udcore/Include:/SOURCE/udsdksamples/languages/cpp/build:/SOURCE/arceus/build:/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib \
    LD_LIBRARY_PATH=/usr/local/lib:/SOURCE/arceus/build:/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib:/SOURCE/udsdk/include:/SOURCE/udsdk/lib/ubuntu18.04_GCC_x64:/SOURCE/udsdksamples/languages/cpp/lib:/SOURCE/udsdksamples/external/stb:/SOURCE/udsdksamples/external/udcore/Include:/SOURCE/udsdksamples/languages/cpp/build \
    LIBRARY_PATH=/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib:/SOURCE/udsdk/include:/SOURCE/udsdk/lib/ubuntu18.04_GCC_x64:/SOURCE/udsdksamples/languages/cpp/lib:/SOURCE/udsdksamples/external/stb:/SOURCE/udsdksamples/external/udcore/Include:/SOURCE/udsdksamples/languages/cpp/build \
    CPLUS_INCLUDE_PATH=/SOURCE/arceus \
    BOOST_SYSTEM_LIBRARY=/SOURCE/boost-1.61.0/bin.v2/libs

RUN mkdir -p /app /data /SOURCE

# =================
#     part 2a
#   basic tools
# =================
RUN apt-get -y update ;\
    apt-get -y upgrade ;\
    apt-get -y install \
        apt-transport-https \
        apt-utils \
        bc \
        build-essential \
        ca-certificates \
        cmake \
        cowsay \
        curl \
        doxygen \
        firefox \
        fortune \
        g++ \
        gcc \
        gfortran \
        git \
        htop \
        imagemagick \
        make \
        musl-dev \
        nano \
        net-tools \
        screen \
        sl \
        software-properties-common \
        vim \
        wget

# =================
#     part 2b
#   basic libraries
# =================
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install \
        autotools-dev \
        e2fslibs-dev \
        freeglut3-dev \
        libaudit-dev \
        libblkid-dev \
        libboost-all-dev \
        libboost-dev \
        libboost-thread-dev \
        libbz2-dev \
        libcurl4-openssl-dev \
        libeigen3-dev \
        libflann-dev \
        libgl1-mesa-glx \
        libglew-dev \
        libglfw3-dev \
        libglu1-mesa-dev \
        libgmp-dev \
        libgmpxx4ldbl \
        libicu-dev \
        libjpeg-dev \
        libjsoncpp-dev \
        libmpfr-dev \
        libopenni-dev \
        libopenni2-dev \
        libpcap-dev \
        libpcl-dev \
        libpng-dev \
        libssl-dev \
        libtbb-dev \
        libudev-dev \
        libusb-1.0-0-dev \
        libvtk6-dev \
        libx11-dev \
        python-dev \
        xorg-dev

# =================
#     part 3a
#   cmake build tools
# =================
RUN cd /SOURCE ;\
    wget https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.tar.gz ;\
    tar -zxvf cmake-3.10.2-Linux-x86_64.tar.gz ; rm -f cmake-3.10.2-Linux-x86_64.tar.gz ; mv cmake-3.10.2-Linux-x86_64 cmake_3_10_2

# =================
#     part 3b
#   pcl base lib
# =================
RUN cd /SOURCE ;\
    wget https://sourceforge.net/projects/boost/files/boost/1.61.0/boost_1_61_0.tar.bz2 ;\
    tar --bzip2 -xf boost_1_61_0.tar.bz2 ; rm -f boost_1_61_0.tar.bz2 ;\
    cd boost_1_61_0 ; ./bootstrap.sh ; ./b2 install -j1

RUN cd /SOURCE ;\
    wget https://gitlab.com/libeigen/eigen/-/archive/3.2.8/eigen-3.2.8.tar.bz2 ;\
    tar --bzip2 -xf eigen-3.2.8.tar.bz2 ; rm -f eigen-3.2.8.tar.bz2 ; mv eigen-3.2.8 eigen_3_2_8 ;\
    cd eigen_3_2_8 ; mkdir build ; cd build ; /SOURCE/cmake_3_10_2/bin/cmake -DCMAKE_BUILD_TYPE=Release .. ; make -j8 ; make install

RUN apt-get -y install \
        unzip

RUN cd /SOURCE ;\
    wget -O flann_1_8_4-src.zip https://src.fedoraproject.org/lookaside/extras/flann/flann-1.8.4-src.zip/a0ecd46be2ee11a68d2a7d9c6b4ce701/flann-1.8.4-src.zip ;\
    unzip flann_1_8_4-src.zip ; rm -f flann_1_8_4-src.zip ; mv flann-1.8.4-src flann_1_8_4 ;\
    cd flann_1_8_4 ; mkdir build ; cd build ; /SOURCE/cmake_3_10_2/bin/cmake -DCMAKE_BUILD_TYPE=Release .. ; make -j8 ; make install

RUN cd /SOURCE ;\
    wget -O vtk_7_1_0.tar.bz2 https://gitlab.kitware.com/vtk/vtk/-/archive/v7.1.0/vtk-v7.1.0.tar.bz2 ;\
    tar --bzip2 -xf vtk_7_1_0.tar.bz2 ; rm -f vtk_7_1_0.tar.bz2 ; mv vtk-v7.1.0 vtk_7_1_0 ;\
    cd vtk_7_1_0 ; mkdir build ; cd build ; /SOURCE/cmake_3_10_2/bin/cmake -DCMAKE_BUILD_TYPE=Release .. ; make -j8 ; make install

RUN cd /SOURCE ;\
    wget https://github.com/PointCloudLibrary/pcl/archive/pcl-1.8.0.tar.gz ;\
    tar -zxvf pcl-1.8.0.tar.gz ; rm -f pcl-1.8.0.tar.gz ; mv pcl-pcl-1.8.0 pcl ;\
    cd pcl ; mkdir build ; cd build ; /SOURCE/cmake_3_10_2/bin/cmake -DCMAKE_BUILD_TYPE=Release .. ; make -j8 ; make install

# =================
#     part 3c
#   laslib library
# =================
RUN apt-get -y install liblas-dev
#RUN cd /SOURCE ;\
#    wget https://github.com/libLAS/libLAS/archive/refs/tags/1.8.1.tar.gz ;\
#    tar -zxvf 1.8.1.tar.gz ; rm -f 1.8.1.tar.gz ; mv libLAS-1.8.1 liblas
#    cd liblas ; mkdir build ; cd build ; /SOURCE/cmake_3_10_2/bin/cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../ ; make -j8 ; make install

# =================
#     part 4
#   Hadoop Spark
# =================
RUN git clone https://github.com/michaelchanwahyan/jdk1.8.0_171 ;\
    git clone https://github.com/michaelchanwahyan/spark-2.4.0-bin-hadoop2.7 ;\
    git clone https://github.com/michaelchanwahyan/hadoop-2.7.7 ;\
    mkdir /gcs-connector-hadoop ;\
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list ;\
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - ;\
    apt-get -y update ;\
    apt-get -y install google-cloud-sdk ;\
    wget https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-latest-hadoop2.jar ;\
    mv   gcs-connector-latest-hadoop2.jar       /gcs-connector-hadoop/ ;\
    echo export     HADOOP_CLASSPATH=/gcs-connector-hadoop/gcs-connector-latest-hadoop2.jar >> /hadoop-2.7.7/etc/hadoop/hadoop-env.sh ;\
    echo spark.driver.extraClassPath /gcs-connector-hadoop/gcs-connector-latest-hadoop2.jar >> $SPARK_HOME/conf/spark-defaults.conf ;\
    echo spark.driver.memory                    5g                                          >> $SPARK_HOME/conf/spark-defaults.conf ;\
    echo spark.driver.maxResultSize             5g                                          >> $SPARK_HOME/conf/spark-defaults.conf ;\
    echo spark.driver.allowMultipleContexts     True                                        >> $SPARK_HOME/conf/spark-defaults.conf

# info to hadoop                 <-- HADOOP_CLASSPATH
# info to spark                  <-- spark.driver.extraClassPath
# max mem consumed per core      <-- spark.driver.memory
# prevent rdd.collect() exceed   <-- spark.driver.maxResultSize

# =================
#     part 5
#   Python 3.6.8
# =================
# build and install Python3.6.8
RUN cd / ;\
    wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz ;\
    tar -zxvf Python-3.6.8.tgz ;\
    cd Python-3.6.8 ; ./configure ; make -j8 ; make install ;\
    pip3 install --upgrade pip

RUN pip3 install \
        ipython==7.16.1 \
        ipywidgets==7.4.1 \
        jupyter-client==6.1.7 \
        jupyter-console==6.2.0 \
        jupyter-core==4.6.3 \
        jupyter==1.0.0 \
        jupyterlab-launcher==0.13.1 \
        jupyterlab==2.2.6 \
        nbconvert==5.6.1 \
        protobuf==3.13.0

RUN pip3 install \
        Cython==0.29.21 \
        Pillow==7.2.0 \
        anytree==2.8.0 \
        arrow==0.16.0 \
        django-file-md5==1.0.3 \
        findspark==1.4.2 \
        folium==0.11.0 \
        gensim==3.8.3 \
        h5py==2.10.0 \
        lxml==4.5.2 \
        matplotlib-venn==0.11.5 \
        matplotlib==3.3.1 \
        networkx==2.5 \
        numpy==1.19.1 \
        pandas==1.1.1 \
        pattern3==3.0.0 \
        pyspark==3.0.0 \
        scikit-image==0.17.2 \
        scikit-learn==0.23.2 \
        scipy==1.5.2 \
        seaborn==0.10.1

RUN pip3 install \
        astcheck==0.2.5 \
        astsearch==0.2.0 \
        cvxpy==1.1.5 \
        ecos==2.0.7.post1 \
        fastcache==1.1.0 \
        implicit==0.4.2 \
        jieba==0.42.1 \
        laspy==1.7.0 \
        multiprocess==0.70.10 \
        nltk==3.5 \
        open3d-python==0.7.0.0 \
        opencv-python==4.4.0.42 \
        osqp==0.6.1 \
        plotly==4.9.0 \
        plyfile==0.7.2 \
        pptk==0.1.0 \
        python-pcl==0.3.0a1 \
        scs==2.1.2 \
        setuptools==56.0.0 \
        toolz==0.10.0

RUN jupyter nbextension enable --py widgetsnbextension ;\
    jupyter serverextension enable --py jupyterlab

RUN pip3 install git+https://github.com/IcarusSO/nbparameterise.git

RUN echo /usr/local/lib >> /etc/ld.so.conf ;\
    ldconfig

COPY [ ".bashrc" , ".vimrc" , "/root/" ]

COPY [ "startup.sh"         , "/"      ]

CMD [ "/bin/bash" ]
