🚀 React Production VPS Setup Script

Bash script to fully prepare an Ubuntu VPS for hosting a React production build using Nginx + SSL (Let's Encrypt).

سكريبت يقوم بتجهيز سيرفر Ubuntu بالكامل لاستضافة نسخة Production من React باستخدام Nginx مع SSL تلقائي.

🎯 What This Script Does | ماذا يفعل هذا السكريبت؟

This script automatically:

✅ Updates the system

✅ Installs required packages (Nginx, UFW, Node.js)

✅ Configures firewall (UFW)

✅ Creates a sudo deployment user

✅ Configures Nginx for SPA (React / Vite / CRA)

✅ Installs and configures SSL using Certbot

✅ Prepares the web root directory

📦 Important Concept | فكرة مهمة

⚠️ This script is designed for CI/CD deployment.

It does NOT clone the repository and does NOT build React inside the VPS.

Why?

Because the recommended production approach is:

Build the React app inside GitLab CI pipeline.

Use rsync in the deploy stage.

Send only the final build/ or dist/ folder to the VPS.

هذا أفضل أمنيًا وأسرع وأخف على السيرفر.

🛠 Requirements | المتطلبات

Ubuntu 20.04 / 22.04 VPS

Root access

Domain pointing to the VPS IP

Open ports: 22, 80, 443

⚙️ Configuration Section

Before running the script, edit the configuration part:

### ========= CONFIG =========
HOSTNAME_NAME="new-hostname"
NEW_USER="deploy"
DOMAIN_NAME="yourdomain.com"
EMAIL="youremail@example.com"
WEB_ROOT="/var/www/app"
NGINX_SITE_NAME="app"
NODE_VERSION="20"
### ==========================
What each variable means:
Variable	Description
HOSTNAME_NAME	Server hostname
NEW_USER	Deployment sudo user
DOMAIN_NAME	Your domain
EMAIL	Email for SSL registration
WEB_ROOT	Directory where build files will be uploaded
NGINX_SITE_NAME	Nginx config filename
NODE_VERSION	Node.js version
🚀 How To Use | طريقة الاستخدام

1️⃣ Upload the script to your VPS:

scp setup.sh root@your_server_ip:/root/

2️⃣ SSH into server:

ssh root@your_server_ip

3️⃣ Make it executable:

chmod +x setup.sh

4️⃣ Run it:

./setup.sh
🔄 How Deployment Works (CI/CD Flow)

Example GitLab CI deploy stage:

deploy:
  stage: deploy
  script:
    - rsync -avz --delete dist/ $DEPLOY_USER@$DEPLOY_HOST:/var/www/app/

After deployment:

Nginx automatically serves the updated build files.

No need to restart Nginx.

No Node.js runtime required for serving React.

🌐 Nginx Configuration (SPA Ready)

The script configures Nginx like this:

location / {
    try_files $uri /index.html;
}

This ensures:

React Router works correctly

All routes fallback to index.html

🔐 SSL Setup

The script installs:

snapd

certbot

auto SSL configuration

auto renewal test

SSL is issued using:

certbot --nginx
💡 Why This Approach?

✔️ Cleaner production architecture
✔️ CI builds, server only serves
✔️ Better security
✔️ Faster deployments
✔️ Less CPU usage on VPS
✔️ DevOps best practice

🧠 Recommended Architecture
Developer → GitLab → CI Build → rsync → VPS (Nginx serves static files)

NOT:

Developer → VPS → git pull → npm install → npm run build
📌 Notes

This script is for static React deployment only

If you need SSR (Next.js), different setup required

If using Docker, architecture will change

Make sure DNS is configured before running SSL step

🤝 Contribution

Feel free to fork, improve, or adapt it to your infrastructure.

إذا عندك تحسينات أو اقتراحات تفضل افتح Pull Request 👌

🏷 Author
Faisal Alhaj

Built with ❤️ for DevOps workflows.