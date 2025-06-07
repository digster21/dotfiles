#!/usr/bin/env bash

set -e

git ls-remote --tags https://github.com/nrfconnect/sdk-nrf.git \
| grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+$' \
| sort -V
