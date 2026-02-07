bloodlife/
│
├── app/
│   ├── assets/
│   │   ├── uploads/        # Hospital receipts (folder will auto creates once docker images created)
│   │   └── style.css       # Global styles + background
│   │
│   ├── config/
│   │   └── db.php          # MySQL connection
│   │
│   ├── index.php
│   ├── register.php
│   ├── login.php
│   ├── dashboard.php
│   ├── admin.php
│   ├── request.php
│   ├── profile.php
│   └── logout.php
├── db/init
│   ├──init.sql
│
├── docker compose.yml/compose.yml
├── Dockerfile
└── README.md


Create a blood_web image with Dockerfile first, having prerequisite with docker compose
Register with email: admin@bloodlife.com -- to get the admin credentials
Images: blood_web, blood_db
Containers: blood_web, blood_db
To go inside db:
docker exec -it blood_db mysql -uroot -proot

DB credentials:
root:root
