#!/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
PROJECT_DIR=$SCRIPT_DIR/..

INSTALL_DIR="/usr/local"

if [[ ! -z $1 ]]
then
    INSTALL_DIR=$1
fi

function check_if_user_has_sudo() {
    if [[ $(sudo -v) == "*may not run sudo*" ]]
    then
        return 1
    else
        return 0
    fi
}

cd $PROJECT_DIR

if check_if_user_has_sudo 
then
    # Install OpenCV for Ubuntu 20. Opencv seems to need a different package for ubuntu 22
    sudo apt-get update && sudo apt-get install -y \
         build-essential cmake unzip pkg-config \
         libjpeg-dev libpng-dev libtiff-dev \
         libvtk6-dev \
         libgtk-3-dev \
         libatlas-base-dev gfortran
fi

cd $PROJECT_DIR
if [ ! -d $PROJECT_DIR/opencv ]
then
    git clone https://github.com/opencv/opencv.git opencv3.3.1
    ln -s opencv3.3.1 opencv
    cd opencv && git checkout tags/3.3.1
fi

cd $PROJECT_DIR
if [ ! -d $PROJECT_DIR/opencv_contrib ]
then
    git clone https://github.com/opencv/opencv_contrib.git opencv_contrib3.3.1
    ln -s opencv_contrib3.3.1 opencv_contrib
    cd opencv_contrib && git checkout tags/3.3.1
fi

# Roger: Fix ffmpeg version in 20.04? Not needed in 18.04
cd $PROJECT_DIR/opencv/modules/videoio/src && \
    printf '#define AV_CODEC_FLAG_GLOBAL_HEADER (1 << 22) \n#define CODEC_FLAG_GLOBAL_HEADER AV_CODEC_FLAG_GLOBAL_HEADER \n#define AVFMT_RAWPICTURE 0x0020 \n' | \
    cat - cap_ffmpeg_impl.hpp > /tmp/out && \
    mv /tmp/out cap_ffmpeg_impl.hpp

cd $PROJECT_DIR/opencv && mkdir -p build && cd build && pwd
cmake -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -D BUILD_opencv_python=OFF \
  -D BUILD_opencv_python2=OFF \
  -D BUILD_opencv_python3=OFF \
  -DENABLE_CXX11=ON \
  -DOPENCV_EXTRA_MODULES_PATH=${PROJECT_DIR}/opencv_contrib/modules ..

if check_if_user_has_sudo
then
  sudo make -j$(nproc) install
else
  make -j$(nproc) install
fi
