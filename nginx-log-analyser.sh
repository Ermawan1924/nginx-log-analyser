#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <nginx-access-log-file>"
  exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
  echo "Error: File $LOG_FILE tidak ditemukan."
  exit 1
fi

echo "Top 5 IP addresses with the most requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | \
  awk '{print $2 " - " $1 " requests"}'

echo ""
echo "Top 5 most requested paths:"
# Extract request path, contoh log format: "GET /api/v1/users HTTP/1.1"
# Field ke 7 jika dipisah spasi dan tanda petik
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | \
  awk '{print $2 " - " $1 " requests"}'

echo ""
echo "Top 5 response status codes:"
# Status code biasanya field ke 9
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | \
  awk '{print $2 " - " $1 " requests"}'

echo ""
echo "Top 5 user agents:"
# User agent biasanya mulai field ke 12 sampai akhir, diapit oleh tanda petik ""
# Contoh: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)..."
# Cara ambil field mulai 12 sampai akhir dan hapus tanda petik
awk -F'"' '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | \
  awk '{sub(/^ +/, ""); print $0}' | awk '{print substr($0, index($0,$2)) " - " $1 " requests"}'
