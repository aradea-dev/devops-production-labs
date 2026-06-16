#!/bin/bash

# Folder untuk mencatat riwayat pemulihan
LOG_DIR="$HOME/dev/devops-production-labs/awesome-app-production-grade/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/self_healing_activity.log"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Menjalankan pengecekan kontainer berkala..." >> "$LOG_FILE"

# 1. Cari tahu apakah ada kontainer yang berstatus 'unhealthy'
UNHEALTHY_CONTAINERS=$(docker ps --filter "health=unhealthy" --format "{{.Names}}")

if [ -n "$UNHEALTHY_CONTAINERS" ]; then
    echo "[$TIMESTAMP] PERINGATAN: Ditemukan kontainer tidak sehat:" >> "$LOG_FILE"
    echo "$UNHEALTHY_CONTAINERS" >> "$LOG_FILE"
    
    # 2. Lakukan pemulihan: Restart kontainer yang bermasalah secara otomatis
    for CONTAINER in $UNHEALTHY_CONTAINERS; do
        echo "[$TIMESTAMP] Memulai pemulihan otomatis untuk: $CONTAINER..." >> "$LOG_FILE"
        docker restart "$CONTAINER" >> "$LOG_FILE" 2>&1
        
        if [ $? -eq 0 ]; then
            echo "[$TIMESTAMP] BERHASIL: $CONTAINER telah berhasil dipulihkan." >> "$LOG_FILE"
        else
            echo "[$TIMESTAMP] GAGAL: Tidak dapat merestart $CONTAINER. Butuh intervensi manual!" >> "$LOG_FILE"
        fi
    done
else
    echo "[$TIMESTAMP] AMAN: Semua kontainer berjalan dengan status sehat." >> "$LOG_FILE"
fi
