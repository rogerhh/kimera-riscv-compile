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
    ## [Optional] Install Kimera-VIO-Evaluation from PyPI
    sudo apt-get update && \
    sudo apt-get install software-properties-common -y

    # Get python3
    sudo apt-get update && \
         sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt-get update && \
         sudo apt-get install -y python3 python3-dev python3-pip python3-tk

    # We use `pip3 install -e .` so that Jinja2 has access to the webiste template...
    # Roger Fix: missing ffi.h
    sudo apt-get install libffi-dev
fi

pip3 install PyQt5==5.14
pip3 install numpy==1.20.3

# Install evo-1 for evaluation
# Hack to avoid Docker's cache when evo-1 master branch is updated.
git clone https://github.com/ToniRV/evo-1.git
(cd evo-1 && python3 $(which pip3) install .)

# Install spark_vio_evaluation
python3 $(which pip3) install ipython prompt_toolkit
git clone https://github.com/ToniRV/Kimera-VIO-Evaluation.git

(cd Kimera-VIO-Evaluation && python3 $(which pip3) install -e .)
