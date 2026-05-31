# Local Infrastructure Hardening - Labs

This repository contains documentation and practical results for automation and security hardening of local infrastructure (WSL2).

## Implemented Security Features:
- **Day 1:** OS Foundations (Non-root User) & Bash Strict Mode (`set -euo pipefail`).
- **Day 2:** Background Automation (`cron`) & Error Handling (`trap`).
- **Day 3:** Edge Security Hardening (Nginx Server Tokens Off, Rate Limiting 5r/s, Security Headers).
- **Day 4:** Local HTTPS Encryption using `mkcert` on Port 443.

---

## 🚀 Lab Verification & Proof of Work (Day 3 & 4)

This section demonstrates the successful implementation of Nginx Security Hardening, Rate Limiting, and local HTTPS via `mkcert`.

### 1. Network Socket Verification
Verifying that Nginx is actively listening on both HTTP (Port 80) and HTTPS (Port 443):

```bash
$ sudo ss -tulpn | grep -E ':80|:443'
Output:

Plaintext
tcp   LISTEN 0      511          0.0.0.0:443        0.0.0.0:* users:(("nginx",pid=6264,fd=7)...)
tcp   LISTEN 0      511          0.0.0.0:80         0.0.0.0:* users:(("nginx",pid=6264,fd=6)...)
2. Security Hardening & Rate Limiting Test
An automated loop of 10 consecutive requests via curl was executed to test the Rate Limiting (5r/s), Server Tokens (Off), and Security Headers implementation.

Bash
for i in {1..10}; do curl -I -k https://localhost/; done
Successful Request (Within Rate Limit - HTTP 200 OK)
The first few requests successfully hit the server, confirming SSL handshake capability and demonstrating the removal of the Nginx version token along with strict security headers:

Plaintext
HTTP/1.1 200 OK
Server: nginx
Date: Sun, 31 May 2026 08:31:59 GMT
Content-Type: text/html
Content-Length: 612
Connection: keep-alive
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Referrer-Policy: no-referrer-when-downgrade
Content-Security-Policy: default-src 'self'; http: https: data: blob: 'unsafe-inline'
Blocked Request (Rate Limit Exceeded - HTTP 503 Service Unavailable)
Subsequent burst requests exceeding the defined limit (rate=5r/s burst=5 nodelay) were instantly blocked by Nginx to prevent resource exhaustion/DDoS:

Plaintext
HTTP/1.1 503 Service Temporarily Unavailable
Server: nginx
Date: Sun, 31 May 2026 08:31:59 GMT
Content-Type: text/html
Content-Length: 74
Connection: keep-alive
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Referrer-Policy: no-referrer-when-downgrade
Content-Security-Policy: default-src 'self'; http: https: data: blob: 'unsafe-inline'
🛠️ Configuration Architecture
Main Configuration: Linked directly to /etc/nginx/nginx.conf

Server Blocks: Modular structure under /nginx/conf.d/default.conf

SSL Certificates: Locally trusted Root CA managed by mkcert inside /nginx/certs/
