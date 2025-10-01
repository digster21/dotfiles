#!/usr/bin/env bash

meminfo=$(grep -E 'Mem(Total|Available):' /proc/meminfo)
total_kb=$(echo "$meminfo" | awk '/MemTotal:/ {print $2}')
avail_kb=$(echo "$meminfo" | awk '/MemAvailable:/ {print $2}')
used_kb=$((total_kb - avail_kb))

humanize() {
    printf "$1" "$(echo "$2/1048576" | bc -l)"
}

used_h=$(humanize "%5.1f" "$used_kb")
total_h=$(humanize "%.1f" "$total_kb")

echo "${used_h}/${total_h} Gi"

