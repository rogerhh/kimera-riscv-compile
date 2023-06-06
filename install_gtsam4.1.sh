#!/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
PROJECT_DIR=$SCRIPT_DIR/..
INSTALL_DIR="/usr/local"

if [[ ! -z $1 ]]
then
    INSTALL_DIR=$1
fi

# Return 0 if user has sudo
function check_if_user_has_sudo() {
    if [[ $(sudo -v) == "*may not run sudo*" ]]
    then
        return 1
    else
        return 0
    fi
}

if check_if_user_has_sudo
then
    sudo apt-get update && sudo apt-get install -y libboost-all-dev
fi

if [ ! -d $PROJECT_DIR/gtsam ]
then
    # Install gtsam4.1.1 
    cd $PROJECT_DIR
    git clone https://github.com/borglab/gtsam.git gtsam4.1
    ln -s gtsam4.1 gtsam 
    cd ${PROJECT_DIR}/gtsam && git fetch origin tags/4.1.1 && git reset --hard FETCH_HEAD
fi

cd ${PROJECT_DIR}/gtsam && mkdir -p build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
          -DGTSAM_BUILD_TESTS=OFF \
          -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF \
          -DCMAKE_BUILD_TYPE=Release \
          -DGTSAM_BUILD_UNSTABLE=ON \
          -DGTSAM_TANGENT_PREINTEGRATION=OFF .. 

if check_if_user_has_sudo
then
    make clean && sudo make -j$(nproc) install
else
    make clean && make -j$(nproc) install
fi


