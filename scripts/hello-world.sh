#!/usr/bin/env bash

show_help() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    -v, --verbose     Enable verbose output
    -h, --help        Show this help message and exit
    --version         Show version information and exit
EOF
}

show_version() {
    echo "0.0.0"
}

log() {
    if [[ "$VERBOSE" -eq 1 ]]; then
        echo "$0: $*" >&2
    fi
}

VERBOSE=0

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        --version)
            show_version
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "error: unknown option: $1" >&2
            show_help >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

log "Verbose enabled"

echo "Hello World!"
