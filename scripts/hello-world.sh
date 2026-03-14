#!/usr/bin/env bash

show_help() {
    cat <<EOF
Usage $0 [OPTIONS]

Options:
    -h, --help        Show this help message and exit
    -v, --version     Show version information and exit
    --verbose         Enable verbose output
EOF
}

show_version() {
    echo "0.0.0"
}

VERBOSE=0

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        --verbose)
            VERBOSE=1
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Unknown option: $1" >&2
            show_help >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [ "$VERBOSE" -eq 1 ]; then
    echo "Verbose enabled"
fi

echo "Hello World!"
