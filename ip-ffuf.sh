#!/bin/bash

# Usage: ./ip_fuzzer.sh ips.txt sensitive_wordlist.txt output_dir
# Example: ./ip_fuzzer.sh ips.txt sensitive_wordlist.txt results

IPS_FILE=$1
WORDLIST=$2
OUTPUT_DIR=$3

# Check arguments
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <ips_file> <wordlist> <output_dir>"
    exit 1
fi

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Loop through each IP and fuzz
while IFS= read -r ip; do
    if [[ -n "$ip" ]]; then
        echo "[*] Fuzzing $ip ..."
        ffuf -u http://$ip/FUZZ \
             -w "$WORDLIST" \
             -mc 200,302,403 \
             -t 50 \
             -o "$OUTPUT_DIR/${ip}_ffuf.json"
    fi
done < "$IPS_FILE"

echo "[+] Fuzzing complete. Results saved in $OUTPUT_DIR"
