# ==========================================
# STAGE 1: Build & Install Dependencies
# ==========================================
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package.json untuk install dependensi
COPY src/package.json ./
RUN npm install

# Copy source code aplikasi
COPY src/ ./

# ==========================================
# STAGE 2: Production Environment (Final Image)
# ==========================================
FROM node:20-alpine
WORKDIR /app

# Menyalin hanya file yang dibutuhkan dari Stage 1 (builder)
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./server.js

# HARDENING: Membuat user non-root dan memberikan hak akses folder /app
RUN addgroup -S devopsgroup && adduser -S alpine -G devopsgroup \
    && chown -R alpine:devopsgroup /app

# Pindah dari user root ke user non-root 'alpine'
USER alpine

# Expose port aplikasi
EXPOSE 8080

# Jalankan aplikasi
CMD ["npm", "start"]
