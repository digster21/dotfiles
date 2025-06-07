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
            shift 2
            ;;
        -h|--help)
            PRINT_HELP
            exit 0
            ;;
        -*|--*)
            echo "Error: Unknown option: $1"
            echo "Try -h|--help"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

if [[ ${#POSITIONAL_ARGS[@]} -ne 0 ]]; then
    echo "Error: Positional arguments not supported."
    echo "Try -h|--help"
    exit 1
fi

if [[ -z "$NCS_VERSION" ]]; then
    echo "Error: No NCS version specified."
    echo "Try -h|--help"
    exit 1
fi

NCS_ROOT="$HOME/ncs"
NCS_DIR="${NCS_ROOT}/${NCS_VERSION}"
VENV_DIR="${NCS_DIR}/venv"

if [ -d "$NCS_DIR" ]; then
    echo "Error: NCS version $NCS_VERSION already exists at $NCS_DIR"
    exit 1
fi

# Validate version
if ! grep -qx "$NCS_VERSION" <(bash ./nrf-ncs-list-versions.sh); then
    echo "Available versions:"
    bash ./nrf-ncs-list-versions.sh
    echo "Error: Invalid NCS version: $NCS_VERSION"
    exit 1
fi

mkdir -p "$NCS_DIR"

echo "Installing dependencies..."
sudo apt install --no-install-recommends -y \
  git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel \
  xz-utils file make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1 \
  libffi-dev libssl-dev libncurses-dev python3.12-venv

echo "Setting up Python virtual environment..."
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

echo "Installing west and nrfutil..."
pip install --upgrade pip
pip install --upgrade west nrfutil


