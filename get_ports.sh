for fd in /proc/1/fd/*; do
  link=$(readlink "$fd" 2>/dev/null) || continue
  case "$link" in socket:\[*\])
    inode=$(printf '%s' "$link" | sed -n 's/.*\[\([0-9]\+\)\].*/\1/p')
    grep -H -- " $inode" /proc/net/tcp /proc/net/tcp6 2>/dev/null | \
      while IFS= read -r line; do
        file=$(printf '%s\n' "$line" | cut -d: -f1)
        entry=$(printf '%s\n' "$line" | cut -d: -f2-)
        state=$(printf '%s\n' "$entry" | awk '{print $4}')
        [ "$state" = "0A" ] || continue   # 0A = LISTEN
        local_hex=$(printf '%s\n' "$entry" | awk '{print $2}')
        hex_port=${local_hex#*:}
        port=$((16#$hex_port))
        printf "%s -> %s (port %s, hex %s) inode %s\n" "$fd" "$file" "$port" "$hex_port" "$inode"
      done
    ;;
  esac
done
