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
if [ ! -d $PROJECT_DIR/Kimera-RPGO ]
then
    # Install RobustPGO
    git clone https://github.com/MIT-SPARK/Kimera-RPGO.git
fi

cd Kimera-RPGO && mkdir -p build && cd build && \
   cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} .. 

if check_if_user_has_sudo
then
    sudo make -j$(nproc) install
else
    make -j$(nproc) install
fi
