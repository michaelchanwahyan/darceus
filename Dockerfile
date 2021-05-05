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
    PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/lib:/usr/local/lib:/SOURCE/udsdk/include:/SOURCE/udsdk/lib/ubuntu18.04_GCC_x64:/SOURCE/udsdksamples/external/stb:/SOURCE/udsdksamples/external/udcore/Include:/SOURCE/udsdksamples/languages/cpp/build:/SOURCE/arceus/build:/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib:/SOURCE/libLAS/build/bin/Release \
    LD_LIBRARY_PATH=/usr/local/lib:/SOURCE/arceus/build:/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib:/SOURCE/libLAS/build/bin/Release:/SOURCE/udsdk/include:/SOURCE/udsdk/lib/ubuntu18.04_GCC_x64:/SOURCE/udsdksamples/languages/cpp/lib:/SOURCE/udsdksamples/external/stb:/SOURCE/udsdksamples/external/udcore/Include:/SOURCE/udsdksamples/languages/cpp/build \
    LIBRARY_PATH=/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib:/SOURCE/libLAS/build/bin/Release:/SOURCE/udsdk/include:/SOURCE/udsdk/lib/ubuntu18.04_GCC_x64:/SOURCE/udsdksamples/languages/cpp/lib:/SOURCE/udsdksamples/external/stb:/SOURCE/udsdksamples/external/udcore/Include:/SOURCE/udsdksamples/languages/cpp/build \
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
        unzip \
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
RUN cd /SOURCE ;\
    git clone --depth 1 https://github.com/michaelchanwahyan/libLAS.git ;\
    cd libLAS ; mkdir build ; cd build ; /SOURCE/cmake_3_10_2/bin/cmake -DCMAKE_BUILD_TYPE=Release .. ; make -j8 ; make install

# =================
#     part 4
#   Hadoop Spark
# =================
RUN git clone https://github.com/michaelchanwahyan/jdk1.8.0_171 ;\
    git clone https://github.com/michaelchanwahyan/spark-2.4.0-bin-hadoop2.7 ;\
    git clone https://github.com/michaelchanwahyan/hadoop-2.7.7 ;\
    apt-get -y update ;\
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
    anyio==2.2.0 \
    argon2-cffi==20.1.0 \
    arrow==1.1.0 \
    async-generator==1.10 \
    attrs==20.3.0 \
    Babel==2.9.1 \
    backcall==0.2.0 \
    bleach==3.3.0 \
    certifi==2020.12.5 \
    cffi==1.14.5 \
    chardet==4.0.0 \
    click==7.1.2 \
    contextvars==2.4 \
    cycler==0.10.0 \
    Cython==0.29.23 \
    dataclasses==0.8 \
    decorator==4.4.2 \
    defusedxml==0.7.1 \
    deprecation==2.1.0 \
    dill==0.3.3 \
    entrypoints==0.3 \
    findspark==1.4.2 \
    gensim==4.0.1 \
    idna==2.10 \
    imageio==2.9.0 \
    immutables==0.15 \
    importlib-metadata==4.0.1 \
    ipykernel==5.5.3 \
    ipython==7.16.1 \
    ipython-genutils==0.2.0 \
    ipywidgets==7.6.3 \
    jedi==0.18.0 \
    Jinja2==2.11.3 \
    joblib==1.0.1 \
    json5==0.9.5 \
    jsonschema==3.2.0 \
    jupyter==1.0.0 \
    jupyter-client==6.1.12 \
    jupyter-console==6.4.0 \
    jupyter-core==4.7.1 \
    jupyter-packaging==0.9.2 \
    jupyter-server==1.6.4 \
    jupyterlab==3.0.14 \
    jupyterlab-launcher==0.13.1 \
    jupyterlab-pygments==0.1.2 \
    jupyterlab-server==2.5.0 \
    jupyterlab-widgets==1.0.0 \
    kiwisolver==1.3.1 \
    laspy==1.7.0 \
    lxml==4.6.3 \
    MarkupSafe==1.1.1 \
    matplotlib==3.3.4 \
    matplotlib-venn==0.11.6 \
    mistune==0.8.4 \
    multiprocess==0.70.11.1 \
    nbclassic==0.2.7 \
    nbclient==0.5.3 \
    nbconvert==6.0.7 \
    nbformat==5.1.3 \
    nest-asyncio==1.5.1 \
    networkx==2.5.1 \
    nltk==3.6.2 \
    notebook==6.3.0 \
    numpy==1.19.5 \
    opencv-python==4.5.1.48 \
    packaging==20.9 \
    pandocfilters==1.4.3 \
    parso==0.8.2 \
    pexpect==4.8.0 \
    pickleshare==0.7.5 \
    Pillow==8.2.0 \
    plotly==4.14.3 \
    plyfile==0.7.4 \
    pptk==0.1.0 \
    prometheus-client==0.10.1 \
    prompt-toolkit==3.0.18 \
    ptyprocess==0.7.0 \
    py4j==0.10.9 \
    pycparser==2.20 \
    Pygments==2.9.0 \
    pyparsing==2.4.7 \
    pyrsistent==0.17.3 \
    pyspark==3.1.1 \
    python-dateutil==2.8.1 \
    pytz==2021.1 \
    PyWavelets==1.1.1 \
    pyzmq==22.0.3 \
    qtconsole==5.1.0 \
    QtPy==1.9.0 \
    regex==2021.4.4 \
    requests==2.25.1 \
    retrying==1.3.3 \
    scikit-image==0.17.2 \
    scikit-learn==0.24.2 \
    scipy==1.5.4 \
    Send2Trash==1.5.0 \
    six==1.15.0 \
    smart-open==5.0.0 \
    sniffio==1.2.0 \
    terminado==0.9.4 \
    testpath==0.4.4 \
    threadpoolctl==2.1.0 \
    tifffile==2020.9.3 \
    tomlkit==0.7.0 \
    toolz==0.11.1 \
    tornado==6.1 \
    tqdm==4.60.0 \
    traitlets==4.3.3 \
    typing-extensions==3.10.0.0 \
    urllib3==1.26.4 \
    wcwidth==0.2.5 \
    webencodings==0.5.1 \
    widgetsnbextension==3.5.1 \
    zipp==3.4.1

RUN jupyter nbextension enable --py widgetsnbextension ;\
    jupyter serverextension enable --py jupyterlab

RUN pip3 install git+https://github.com/IcarusSO/nbparameterise.git

RUN echo /usr/local/lib >> /etc/ld.so.conf ;\
    ldconfig

COPY [ ".bashrc" , ".vimrc" , "/root/" ]

CMD [ "/bin/bash" ]
