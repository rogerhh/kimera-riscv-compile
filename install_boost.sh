#!/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
PROJECT_DIR=$SCRIPT_DIR/..
INSTALL_DIR=/usr/local

if [[ ! -z $1 ]]
then
    $INSTALL_DIR=$1
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
if [ ! -d $PROJECT_DIR/boost ]
then
    git clone --recursive https://github.com/boostorg/boost.git 
fi

cd $PROJECT_DIR/boost

./bootstrap.sh --prefix=$INSTALL_DIR --with-libraries="serialization,system,fileystem,thread,program_options,date_time,timer,chrono,regex"

# Change project-config.jam

./b2 link=static toolset=gcc-riscv install
