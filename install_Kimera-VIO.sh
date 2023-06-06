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
    # Install glog, gflags
    sudo apt-get update && sudo apt-get install -y libgflags2.2 libgflags-dev libgoogle-glog0v5 libgoogle-glog-dev
fi

# Install Kimera-VIO
git clone https://github.com/MIT-SPARK/Kimera-VIO.git
cd Kimera-VIO && mkdir build && cd build && cmake .. && make -j$(nproc)

# Download and extract EuRoC dataset.
sudo pt-get update && sudo apt-get install -y wget
wget http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/vicon_room1/V1_01_easy/V1_01_easy.zip
mkdir -p $PROJECT_DIR/euroc && unzip V1_01_easy.zip -d $PROJECT_DIR/euroc

# Yamelize euroc dataset
$PROJECT_DIR/Kimera-VIO/scripts/euroc/yamelize.bash -p $PROJECT_DIR/euroc
