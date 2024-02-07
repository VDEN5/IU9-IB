#!/bin/bash
if [ "$#" -ne 2 ]; then
echo "Использование: $0 <путь к скрипту> <период в минутах>"
exit 1
fi
script_path=$1
period=$2
while true; do
timestamp=$(date +%Y%m%d%H%M%S)
output_log="output_$timestamp.log"
error_log="error_$timestamp.log"
if ! grep -f "$script_path" > /dev/null; then
"$script_path" > "$output_log" 2> "$error_log" &
fi
sleep "${period}m"
done