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
if [ ! -d $PROJECT_DIR/opengv ]
then
    # Install Open_GV
    git clone https://github.com/laurentkneip/opengv
fi

cd ${PROJECT_DIR}/opengv && mkdir -p build && cd build && \
   cmake -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
         -DEIGEN_INCLUDE_DIRS=$PROJECT_DIR/gtsam/gtsam/3rdparty/Eigen \
         -DEIGEN_INCLUDE_DIR=$PROJECT_DIR/gtsam/gtsam/3rdparty/Eigen .. 

if check_if_user_has_sudo
then
    sudo make -j$(nproc) install
else
    make -j$(nproc) install
fi

