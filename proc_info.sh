#!/bin/bash

printf "%-8s %-8s %-12s %s\n" "PID" "PPID" "STATE" "COMMAND"
printf "%s\n" "------------------------------------------------------------"

for pid_dir in /proc/[0-9]*; do
    [ -d "$pid_dir" ] || continue
    pid=$(basename "$pid_dir")

    if [ -f "$pid_dir/status" ]; then
        # Извлекаем имя, PPID и состояние процесса из /proc/PID/status
        name=$(awk '/^Name:/ {print $2}' "$pid_dir/status")
        ppid=$(awk '/^PPid:/ {print $2}' "$pid_dir/status")
        state=$(awk '/^State:/ {print $2}' "$pid_dir/status")
    else
        continue
    fi

    if [ -f "$pid_dir/cmdline" ] && [ -s "$pid_dir/cmdline" ]; then
        cmd=$(tr '\0' ' ' < "$pid_dir/cmdline")
    else

	    cmd="[$name]"
    fi

    printf "%-8s %-8s %-12s %s\n" "$pid" "$ppid" "$state" "$cmd"
done
