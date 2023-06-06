#!/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
PROJECT_DIR=$SCRIPT_DIR/..
INSTALL_DIR="/usr/local"

function check_if_user_has_sudo() {
    if [[ $(sudo -v) == "*may not run sudo*" ]]
    then
        return 1
    else 
        return 0
    fi
}

cd $PROJECT_DIR

# mkdir -p local/lib

if check_if_user_has_sudo
then
    echo "[Install Script] Installing Kimera-VIO with sudo"
else
    echo "[Install Script] Installing Kimera-VIO without sudo"
fi

echo "[Install Script] Install Prefix: $INSTALL_DIR"
mkdir -p $INSTALL_DIR

if check_if_user_has_sudo
then
    sudo apt-get update && sudo apt-get install -y --no-install-recommends apt-utils 
    sudo apt-get update && sudo apt-get install -y git cmake 

    # Install xvfb to provide a display 
    sudo apt-get update && sudo apt-get install -y xvfb
else
    # Check dependencies exist
    echo ""
fi

$SCRIPT_DIR/install_gtsam4.1.sh $INSTALL_DIR

$SCRIPT_DIR/install_opencv3.3.1_ubuntu22.sh $INSTALL_DIR

$SCRIPT_DIR/install_opengv.sh $INSTALL_DIR

$SCRIPT_DIR/install_DBoW2.sh $INSTALL_DIR

$SCRIPT_DIR/install_Kimera-RPGO.sh $INSTALL_DIR

$SCRIPT_DIR/install_Kimera-VIO-eval.sh $INSTALL_DIR

$SCRIPT_DIR/install_Kimera-VIO.sh $INSTALL_DIR

