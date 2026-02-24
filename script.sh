#!/usr/bin/env bash
set -e

### ========= CONFIG =========
HOSTNAME_NAME="new-hostname"
NEW_USER="deploy"
DOMAIN_NAME="yourdomain.com"
EMAIL="youremail@example.com"
WEB_ROOT="/var/www/app"
NGINX_SITE_NAME="app"
NODE_VERSION="20"
### ==========================

echo "🚀 Starting FULL React production VPS setup..."

# ================= STEP 1 =================
echo "🔄 System update..."
apt update -y && apt upgrade -y
apt install -y software-properties-common curl unzip zip git ca-certificates ufw nginx

# ================= STEP 2 =================
echo "🏷️ Hostname..."
hostnamectl set-hostname "$HOSTNAME_NAME"

# ================= STEP 3 =================
echo "👤 Create sudo user..."
if ! id "$NEW_USER" &>/dev/null; then
  adduser "$NEW_USER"
  usermod -aG sudo "$NEW_USER"
fi

# ================= STEP 4 =================
echo "🔥 Firewall (UFW)..."
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw allow 80
ufw allow 443
ufw --force enable

# ================= STEP 5 =================
echo "🟢 Install Node.js..."
curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -
apt install -y nodejs
node -v
npm -v

# ================= STEP 6 =================
echo "🌐 Nginx..."
systemctl enable nginx
systemctl start nginx

mkdir -p "$WEB_ROOT"

# ================= STEP 9 =================
echo "🧾 Configure Nginx..."

cat > /etc/nginx/sites-available/$NGINX_SITE_NAME <<EOF
server {
    listen 80;
    server_name $DOMAIN_NAME www.$DOMAIN_NAME;

    root $WEB_ROOT/$BUILD_DIR;
    index index.html;

    location / {
        try_files \$uri /index.html;
    }

    location ~ /\. {
        deny all;
    }
}
EOF

unlink /etc/nginx/sites-enabled/default 2>/dev/null || true
ln -sf /etc/nginx/sites-available/$NGINX_SITE_NAME /etc/nginx/sites-enabled/$NGINX_SITE_NAME

nginx -t
systemctl restart nginx

chown -R www-data:www-data "$WEB_ROOT"
chmod -R 755 "$WEB_ROOT"

# ================= STEP 10 =================
echo "🔒 SSL..."
apt install -y snapd
snap install core
snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot || true

certbot --nginx -d "$DOMAIN_NAME" -d "www.$DOMAIN_NAME" \
  -m "$EMAIL" --agree-tos --non-interactive

certbot renew --dry-run

echo "✅ REACT PRODUCTION VPS READY"