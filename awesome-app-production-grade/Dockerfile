# ==========================================
# STAGE 1: Build Stage (Menggunakan Node Alpine)
# ==========================================
FROM node:20-alpine AS builder
WORKDIR /app

# Salin manifes dependensi dari sub-folder src lokal
COPY src/package*.json ./

# UBAH BARIS INI: Menggunakan npm install agar dependensi Express terurai otomatis
RUN npm install --omit=dev

# ==========================================
# STAGE 2: Runtime Stage (Google Distroless Securing)
# ==========================================
FROM gcr.io/distroless/nodejs20-debian12:20260501
WORKDIR /app

# Salin folder node_modules yang sudah matang dari stage builder
COPY --from=builder /app/node_modules ./node_modules

# Salin kode aplikasi utama dari folder src lokal ke container
COPY src/ .

# Jalankan container dengan user non-root bawaan distroless
USER nonroot

EXPOSE 3000
CMD ["app.js"]