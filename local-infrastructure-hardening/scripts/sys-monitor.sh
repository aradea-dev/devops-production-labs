#!/usr/bin/env bash

# Mengaktifkan Strict Mode untuk keamanan script
set -euo pipefail

echo "========================================="
echo "       SISTEM MONITORING SEDERHANA       "
echo "========================================="
echo "Waktu Pemeriksaan: $(date)"
echo "User yang Menjalankan: $(whoami)"
echo "----------------------------------------="

# 1. Cek Penggunaan Disk (Akan error jika perintah salah, berkat set -e)
echo "[1] Penggunaan Space Disk:"
df -h / | awk 'NR==2 {print "Total/Tersedia: " $2 "/" $4 " (Digunakan: " $5 ")"}'

echo ""

# 2. Cek Penggunaan Memori/RAM
echo "[2] Penggunaan Memori RAM:"
free -h | awk '/^Mem:/ {print "Total RAM: " $2 " | Digunakan: " $3 " | Bebas: " $4}'

echo ""

# 3. Cek Load Average CPU
echo "[3] Load Average CPU (1, 5, 15 menit):"
uptime | awk -F'load average:' '{print $2}'

echo "========================================="
