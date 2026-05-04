# WordPress on AWS EC2 with Docker

A Dockerized WordPress stack running **Nginx + PHP-FPM + MySQL** on an AWS EC2 instance.

---

## Stack

| Service   | Technology        |
|-----------|-------------------|
| Web Server| Nginx             |
| PHP       | PHP 8.1-FPM       |
| Database  | MySQL 8.0         |
| CMS       | WordPress (latest)|
| Host      | AWS EC2           |

---

## Project Structure

```
.
├── Dockerfile          # Builds the WordPress + Nginx + PHP-FPM image
├── docker-compose.yml  # Defines wordpress and mysql services
├── nginx.conf          # Nginx site configuration
├── php.ini             # Custom PHP settings
├── entrypoint.sh       # Starts PHP-FPM + Nginx, generates wp-config.php
└── .env                # Environment variables (do not commit this)
```

---

## Prerequisites

- AWS EC2 instance (t3.small or higher recommended)
- Ubuntu 22.04 AMI
- Docker and Docker Compose installed
- Port **80** open in your EC2 Security Group
- A domain name with its **A record** pointing to your EC2 Elastic IP

---

## Setup

### 1. Clone the repository

```bash
git clone git@github.com:sudhanlogics/docker-wordpress.git
cd docker-wordpress
```

### 2. Configure environment variables

```bash
cp .env.example .env
nano .env
```

Fill in your values:

```env
# Your registered domain name (must point to this EC2's Elastic IP)
DOMAIN=wordpress.deoriginlabs.com

# MySQL
MYSQL_ROOT_PASSWORD=Deoriginlabs@123
MYSQL_DATABASE=wordpress
MYSQL_USER=dbadmin
MYSQL_PASSWORD=Deoriginlabs@123

# WordPress
WP_TABLE_PREFIX=wp_
WP_DEBUG=true          # set false when done testing
```

### 4. Install Docker on EC2

```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
     -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 5. Build and start the stack

```bash
docker compose up -d --build
```

### 6. Visit your site

Open your browser and go to:

```
http://yourdomain.com
```

Complete the WordPress installation wizard.

---

## Useful Commands

```bash
# View running containers
docker compose ps

# View logs
docker compose logs -f

# Restart services
docker compose restart

# Stop the stack
docker compose down

# Rebuild after changes
docker compose up -d --build

# Access the WordPress container
docker exec -it wordpress bash

# Access MySQL
docker exec -it mysql mysql -u wp_user -p
```

---

## Configuration

### PHP Settings (`php.ini`)

| Setting               | Value  |
|-----------------------|--------|
| upload_max_filesize   | 64M    |
| post_max_size         | 64M    |
| memory_limit          | 256M   |
| max_execution_time    | 300s   |

### PHP-FPM Socket

PHP-FPM communicates with Nginx via the default Ubuntu socket:
```
/run/php/php8.1-fpm.sock
```

---

## Data Persistence

Data is persisted using Docker named volumes:

| Volume    | Purpose                  |
|-----------|--------------------------|
| `wp_data` | WordPress files          |
| `db_data` | MySQL database files     |

To back up your database:

```bash
docker exec mysql mysqldump -u root -p wordpress > backup.sql
```

---

## Security Notes

- Never commit your `.env` file — add it to `.gitignore`
- Change default passwords in `.env` before deploying
- Restrict EC2 Security Group to only necessary ports (80, 22)

---

## .gitignore

Make sure your `.gitignore` includes:

```
.env
```

---
