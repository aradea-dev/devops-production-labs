#!/bin/bash

# --- KONFIGURASI UTAMA (Ubah sesuai kebutuhan Anda) ---
BACKUP_DIR="$HOME/dev/devops-production-labs/awesome-app-production-grade/backups"
LOG_DIR="$HOME/dev/devops-production-labs/awesome-app-production-grade/logs"
mkdir -p "$BACKUP_DIR" "$LOG_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")
BACKUP_NAME="redis_backup_$TIMESTAMP.tar.gz"
ENCRYPTED_NAME="$BACKUP_NAME.enc"
LOG_FILE="$LOG_DIR/backup_s3_activity.log"

# Kunci Enkripsi (Ganti dengan password rahasia Anda di lingkungan produksi)
ENCRYPTION_KEY="RahasiaDevOpsGradeA2026"

# Informasi Bucket AWS S3
S3_BUCKET="s3://nama-bucket-s3-anda/backups/redis"

echo "=== MEMULAI PROSES CADANGAN [$TIMESTAMP] ===" >> "$LOG_FILE"

# 1. Ekstraksi Berkas Database Redis dari Kontainer
echo "Membuat snapshot database Redis..." >> "$LOG_FILE"
# Memaksa Redis menyimpan data terbaru ke disk lokal kontainer
docker exec database-storage redis-cli save >> "$LOG_FILE" 2>&1

# Menyalin berkas dump database dari kontainer ke folder backup lokal host
docker cp database-storage:/data/dump.rdb "$BACKUP_DIR/dump.rdb" >> "$LOG_FILE" 2>&1

if [ ! -f "$BACKUP_DIR/dump.rdb" ]; then
    echo "EROR Kritis: Gagal mengekstrak berkas dump.rdb dari kontainer!" >> "$LOG_FILE"
    exit 1
fi

# Kompres berkas menjadi tar.gz
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$BACKUP_DIR" dump.rdb
rm -f "$BACKUP_DIR/dump.rdb"

# 2. Proses Enkripsi Militer AES-256
echo "Melakukan enkripsi file cadangan menggunakan AES-256..." >> "$LOG_FILE"
openssl enc -aes-256-cbc -salt -pbkdf2 -in "$BACKUP_DIR/$BACKUP_NAME" -out "$BACKUP_DIR/$ENCRYPTED_NAME" -pass pass:"$ENCRYPTION_KEY"

if [ $? -ne 0 ]; then
    echo "EROR Kritis: Proses enkripsi gagal!" >> "$LOG_FILE"
    exit 1
fi
rm -f "$BACKUP_DIR/$BACKUP_NAME" # Hapus file tar yang tidak terenkripsi demi keamanan

# 3. Unggah ke Cloud AWS S3
echo "Mengunggah berkas terenkripsi ke AWS S3..." >> "$LOG_FILE"
# Perintah ini membutuhkan AWS CLI yang sudah terkonfigurasi di mesin host Anda (aws configure)
aws s3 cp "$BACKUP_DIR/$ENCRYPTED_NAME" "$S3_BUCKET/$ENCRYPTED_NAME" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "SUKSES: Berkas $ENCRYPTED_NAME berhasil diamankan di S3." >> "$LOG_FILE"
    rm -f "$BACKUP_DIR/$ENCRYPTED_NAME" # Bersihkan penyimpanan lokal host setelah sukses unggah
else
    echo "PERINGATAN: Gagal mengunggah ke S3. File dipertahankan di lokal untuk keamanan." >> "$LOG_FILE"
fi

echo "=== SIKLUS CADANGAN SELESAI ===" >> "$LOG_FILE"
