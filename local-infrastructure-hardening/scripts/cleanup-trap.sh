#!/usr/bin/env bash

# Tetap gunakan Strict Mode dari Hari 1
set -euo pipefail

# Membuat file temporary simulasi
TEMP_FILE="/tmp/devops_proses_$$.tmp"

# FUNGSI CLEANUP: Ini yang akan dipanggil saat script mati
cleanup() {
    echo ""
    echo "[TRAP] Mengaktifkan fungsi cleanup..."
    if [ -f "$TEMP_FILE" ]; then
        rm -f "$TEMP_FILE"
        echo "[TRAP] File sampah $TEMP_FILE berhasil dihapus!"
    fi
}

# DAFTARKAN TRAP: Panggil fungsi cleanup jika script keluar karena EXIT, SIGINT (Ctrl+C), atau SIGTERM
trap cleanup EXIT INT TERM

# --- Simulasi Proses Utama Script ---
echo "Membuat file temporary di: $TEMP_FILE"
touch "$TEMP_FILE"

echo "Menulis data penting ke file temporary..."
echo "Data DevOps Rahasia" > "$TEMP_FILE"

echo "Script sedang berjalan... (Tunggu 5 detik atau tekan Ctrl+C untuk menguji trap)"
sleep 5

echo "Proses selesai dengan sukses!"
# Trap EXIT akan otomatis terpicu di sini saat script selesai secara normal
