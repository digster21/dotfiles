#!/usr/bin/env bash

set -e

PRINT_HELP() {
    echo "Nordic Semiconductor NCS (Zephyr) Installer."
    echo "Options:"
    echo "-h|--help        List options"
    echo "-i|--install     NCS version to install"
    echo ""
}


NCS_INSTALL_VERSION=""
HELP=false
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in 
        -i|--install)
            NCS_INSTALL_VERSION="$2"
            shift
            shift
            ;;
        -h|--help)
            HELP=true
            shift
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

if [ "${HELP}" = true ]; then
    PRINT_HELP
    exit 0 
fi

echo "-i = ${NCS_INSTALL_VERSION}"




