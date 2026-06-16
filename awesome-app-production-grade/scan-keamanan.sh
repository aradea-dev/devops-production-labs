#!/bin/bash

echo "=================================================="
echo "🛡️  MEMULAI PEMINDAIAN KEAMANAN MANUAL (TRIVY) 🛡️"
echo "=================================================="
echo "Waktu Scan: $(date)"
echo ""

echo "[1/2] Membersihkan cache pemindaian lama..."
trivy clean --scan-cache
echo "✓ Cache berhasil dibersihkan."
echo ""

echo "[2/2] Memindai image 'awesome-backend:production'..."
echo "--------------------------------------------------"
# Menjalankan scan dan hanya menampilkan celah yang sudah ada perbaikannya (patch)
trivy image --ignore-unfixed awesome-backend:production

echo ""
echo "=================================================="
echo "✓ Pemindaian Selesai!"
echo "=================================================="
