FROM ubuntu:focal

ENV OPENCV_VERSION 4.5.2
ENV OPENCV_DOWNLOAD_URL https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip
ENV OPENCV_CONTRIB_DOWNLOAD_URL https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip

RUN apt-get update \
  && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    libfcgi-dev \
    libmemcached-dev \
    libpng-dev \
    zlib1g-dev \
    librabbitmq-dev \
    uuid-dev \
    build-essential \
    cmake \
    unzip \
    pkg-config \
    curl \
    libjpeg-dev \
    libatlas-base-dev \
    dh-autoreconf \
    autoconf \
    libtool \
  && apt-get clean \
  && apt-get autoclean \
  && rm -rf /var/cache/apk/*

RUN cd ~ \
  && curl -fsSL "$OPENCV_DOWNLOAD_URL" -o opencv.zip \
  && curl -fsSL "$OPENCV_CONTRIB_DOWNLOAD_URL" -o opencv_contrib.zip \
  && unzip opencv.zip \
  && unzip opencv_contrib.zip \
  && mv "opencv-$OPENCV_VERSION" opencv \
  && mv "opencv_contrib-$OPENCV_VERSION" opencv_contrib \
  && cd ~/opencv \
  && mkdir build \
  && cd build \
  && cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_CXX_FLAGS="-std=c++11" \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_ENABLE_NONFREE=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
    -D BUILD_LIST=core,imgproc,imgcodecs,optflow,video \
    -D BUILD_opencv_apps=OFF \
    -D BUILD_DOCS=OFF \
    -D BUILD_PACKAGE=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_FAT_JAVA_LIB=OFF \
    -D WITH_PROTOBUF=OFF \
    -D WITH_JASPER=OFF \
    -D WITH_WEBP=OFF \
    -D WITH_OPENEXR=OFF \
    -D WITH_PVAPI=OFF \
    -D WITH_GIGEAPI=OFF \
    -D WITH_QT=OFF \
    -D WITH_TIFF=OFF \
    .. \
  && make -j 4 \
  && make install \
  && ldconfig \
  && cd ../../ \
  && rm -rf opencv*

WORKDIR /app
