#!/usr/bin/env bash

set -e

PRINT_HELP() {
    echo "Nordic Semiconductor nRF Connect SDK (NCS) Installer."
    echo "Options:"
    echo "-h|--help        List options"
    echo "-i|--install     NCS version to install"
    echo ""
}


NCS_VERSION=""
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in 
        -i|--install)
            NCS_VERSION="$2"
            shift
            shift
            ;;
        -h|--help)
            PRINT_HELP
            exit 0
            ;;
        -*|--*)
            UNKNOWN="$2"
            echo "Error: Unknown option: ${UNKNOWN}"
            echo "try -h|--help"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

set -- "${POSITIONAL_ARGS[@]}"
if [[ -n $1 ]]; then
    echo "Error: Positional arguments not supported."
    echo "try -h|--help"
    exit 1
fi

NCS_ROOT="$HOME/ncs"
NCS_DIR="${NCS_ROOT}/${NCS_VERSION}"
VENV_DIR="${NCS_DIR}/venv"

# Create install directoy
echo "Create NCS directory"
if [ -d "${NCS_DIR}" ]; then
    echo "Error: NCS version ${NCS_VERSION} already exists at ${NCS_DIR}"
fi

# Check is version is valid 
if ! grep -qx "$NCS_VERSION" <(bash ./nrf-ncs-list-versions.sh); then
    echo "Available versions:"
    bash ./nrf-ncs-list-versions.sh
    echo "Error: Invalid NCS version: $NCS_VERSION"
    exit 1
fi

mkdir -p "${NCS_DIR}"

# Install Required dependencies
echo "Install Zephyr + NCS dependencies"
sudo apt install --no-install-recommends git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1 \
libffi-dev libssl-dev libncurses-dev

# Setup Python virtual environment
sudo apt install python3.12-venv
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

# Install west + nrfutil
echo "Installing west and nrfutil"
pip install --upgrade pip
pip install --upgrade west nrfutil

