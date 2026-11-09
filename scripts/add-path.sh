#!/usr/bin/env bash

set -euo pipefail

show_help() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [--] DIR...

Print \$PATH with DIR(s) added. Apply with:
    export PATH="\$($(basename "$0") DIR...)"

Options:
    -a, --append      Add dirs at the end (default: prepend)
    -f, --force       Add dirs even if they don't exist
    -n, --no-dedupe   Don't skip dirs already in PATH
    -v, --verbose     Log decisions to stderr
    -h, --help        Show this help message and exit
    --version         Show version information and exit
EOF
}

show_version() {
    echo "0.1.0"
}

log() {
    if [[ "$VERBOSE" -eq 1 ]]; then
        echo "add-path: $*" >&2
    fi
}

VERBOSE=0
APPEND=0
FORCE=0
DEDUPE=1

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
        -a|--append)
            APPEND=1
            shift
            ;;
        -f|--force)
            FORCE=1
            shift
            ;;
        -n|--no-dedupe)
            DEDUPE=0
            shift
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

if [[ $# -eq 0 ]]; then
    echo "error: no directory given" >&2
    show_help >&2
    exit 1
fi

PATH_IN="${PATH-}"
to_add=()

for dir in "$@"; do
    if [[ -z "$dir" ]]; then
        log "skip (empty)"
        continue
    fi
    [[ "$dir" != "/" ]] && dir="${dir%/}"
    [[ "$dir" != /* ]] && dir="$PWD/$dir"

    if [[ ! -d "$dir" && "$FORCE" -eq 0 ]]; then
        log "skip (missing): $dir"
        continue
    fi

    if [[ "$DEDUPE" -eq 1 ]]; then
        queued=":$(IFS=:; echo "${to_add[*]-}"):"
        if [[ ":$PATH_IN:" == *":$dir:"* || "$queued" == *":$dir:"* ]]; then
            log "skip (duplicate): $dir"
            continue
        fi
    fi

    to_add+=("$dir")
    log "add: $dir"
done

joined="$(IFS=:; echo "${to_add[*]-}")"

if [[ -z "$joined" ]]; then
    printf '%s\n' "$PATH_IN"
elif [[ "$APPEND" -eq 1 ]]; then
    printf '%s\n' "${PATH_IN:+$PATH_IN:}$joined"
else
    printf '%s\n' "$joined${PATH_IN:+:$PATH_IN}"
fi
