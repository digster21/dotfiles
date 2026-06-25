#!/usr/bin/env bash

format_bytes() {
    awk -v bytes="$1" '
    function human(x, i, units) {
        units = "B KiB MiB GiB TiB PiB"
        split(units, u, " ")
        i = 1
        while (x >= 1024 && i < 6) {
            x /= 1024
            i++
        }
        return sprintf((x >= 10 || i == 1) ? "%.0f%s" : "%.1f%s", x, u[i])
    }
    BEGIN { print human(bytes) }
  '
}

case "$(uname -s)" in
    Darwin)
        page_size="$(sysctl -n hw.pagesize)"
        total_bytes="$(sysctl -n hw.memsize)"
        used_bytes="$(
        vm_stat | awk -v ps="$page_size" '
            /Pages active/ { gsub("\\.", "", $NF); active = $NF }
            /Pages wired down/ { gsub("\\.", "", $NF); wired = $NF }
            /Pages occupied by compressor/ { gsub("\\.", "", $NF); comp = $NF }
            END { print (active + wired + comp) * ps }
        '
    )"
        echo "$(format_bytes "$used_bytes")/$(format_bytes "$total_bytes")"
        ;;
    Linux)
        free -h | awk '/^Mem:/ {print $3 "/" $2}'
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac
