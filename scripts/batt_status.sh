#!/usr/bin/env bash

if ! command -v upower >/dev/null 2>&1; then
    exit 1
fi

upower -d | awk -F: '
/native-path/ {gsub(/^[ \t]+/, "", $2); native=$2}
/model/       {gsub(/^[ \t]+/, "", $2); model=$2}
/percentage/  {gsub(/^[ \t]+/, "", $2); percent=$2}
/^$/ {
    if (native != "" && percent != "") {
        if (native ~ /BAT/ || model == "") {
            printf "%-30s %s\n", native, percent
        } else {
            gsub(/ /,"_", model)
            printf "%-30s %s\n", model, percent
        }
    }
    native=""; model=""; percent=""
}'
