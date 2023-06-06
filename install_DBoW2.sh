#!/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
PROJECT_DIR=$SCRIPT_DIR/..
INSTALL_DIR=$PROJECT_DIR/local

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
if [ ! -d $PROJECT_DIR/DBoW2 ]
then

    # Install DBoW2
    git clone https://github.com/dorian3d/DBoW2.git

fi

cd DBoW2 && mkdir build && cd build && \
   cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DCMAKE_TOOLCHAIN_FILE=$PROJECT_DIR/riscv.cmake

if check_if_user_has_sudo
then
    sudo make -j$(nproc) install
else
    make -j$(nproc) install
fi
