#!/usr/bin/env bash

meminfo=$(grep -E 'Mem(Total|Available):' /proc/meminfo)
total_kb=$(echo "$meminfo" | awk '/MemTotal:/ {print $2}')
avail_kb=$(echo "$meminfo" | awk '/MemAvailable:/ {print $2}')
used_kb=$((total_kb - avail_kb))

humanize() {
    awk -v fmt="$1" -v v="$2" 'BEGIN {printf fmt, v/1048576}'
}

used_h=$(humanize "%4.1f" "$used_kb")
total_h=$(humanize "%.1f" "$total_kb")

echo "${used_h}/${total_h} Gi"
