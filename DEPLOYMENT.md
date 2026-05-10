# Nazary — Deployment Reference

## Infrastructure Overview

```
Mobile App (Expo)
    |
    | HTTPS/HTTP
    v
EC2 (t3.micro) — 16.170.146.169
    |  Docker Container: nazary-backend
    |  Rails 8 + Puma on port 3000
    |  Thruster reverse proxy on port 80
    |
    | port 5432 (SSL)
    v
RDS PostgreSQL 16 — nazary-backend.cz88mos8qvaq.eu-north-1.rds.amazonaws.com
    |  Database: nazary_backend_production
    |  Username: postgres
```

---

## URLs & Endpoints

| Service | URL |
|---------|-----|
| **Backend API** | `http://16.170.146.169/api/v1` |
| **RDS Endpoint** | `nazary-backend.cz88mos8qvaq.eu-north-1.rds.amazonaws.com` |
| **EC2 Public IP** | `16.170.146.169` |
| **Mobile Repo** | `github.com/Rao-Ahmar/nazary-mobile` |
| **Backend Repo** | `github.com/Rao-Ahmar/nazary-backend` |

---

## AWS Resources

### EC2 Instance
- **Name**: nazary-backend
- **Type**: t3.micro (free tier)
- **AMI**: Amazon Linux 2023
- **Region**: eu-north-1 (Stockholm)
- **Security Group**: nazary-backend-sg
  - SSH (22) — My IP only
  - HTTP (80) — Anywhere
  - HTTPS (443) — Anywhere
- **Key Pair**: nazary-key (PEM file in ~/Downloads/)
- **Storage**: 20 GB gp3

### RDS PostgreSQL
- **Identifier**: nazary-backend
- **Engine**: PostgreSQL 16
- **Type**: db.t3.micro (free tier)
- **Database Name**: nazary_backend_production
- **Username**: postgres
- **Security Group**: nazary-db-sg
  - PostgreSQL (5432) — from nazary-backend-sg + My IP
- **Storage**: 20 GB gp2
- **Public Access**: Yes

---

## SSH Access

```bash
ssh -i ~/Downloads/nazary-key.pem ec2-user@16.170.146.169
```

---

## Environment Variables (on EC2 Docker container)

| Variable | Value |
|----------|-------|
| `RAILS_MASTER_KEY` | (from config/master.key) |
| `DATABASE_URL` | `postgres://postgres:<PASSWORD>@nazary-backend.cz88mos8qvaq.eu-north-1.rds.amazonaws.com:5432/nazary_backend_production?sslmode=require` |
| `RAILS_ENV` | `production` |

---

## Common Commands

### SSH into server
```bash
ssh -i ~/Downloads/nazary-key.pem ec2-user@16.170.146.169
```

### View logs
```bash
docker logs nazary-backend
docker logs -f nazary-backend    # follow/stream logs
```

### Rails console (production)
```bash
docker exec -it nazary-backend bin/rails console
```

### Run migrations
```bash
docker exec nazary-backend bin/rails db:migrate
```

### Seed database
```bash
docker exec nazary-backend bin/rails db:seed
```

### Restart container
```bash
docker restart nazary-backend
```

---

## Redeployment (when you push new backend code)

```bash
# SSH into EC2
ssh -i ~/Downloads/nazary-key.pem ec2-user@16.170.146.169

# Pull latest code and rebuild
cd nazary-backend
git pull

# Rebuild Docker image
docker build -t nazary-backend .

# Stop old container and start new one
docker stop nazary-backend && docker rm nazary-backend
docker run -d --name nazary-backend --restart always -p 80:80 \
  -e RAILS_MASTER_KEY="<master_key>" \
  -e DATABASE_URL="postgres://postgres:<PASSWORD>@nazary-backend.cz88mos8qvaq.eu-north-1.rds.amazonaws.com:5432/nazary_backend_production?sslmode=require" \
  -e RAILS_ENV=production \
  nazary-backend

# Run any new migrations
docker exec nazary-backend bin/rails db:migrate
```

---

## Mobile App Build (EAS)

### Set API URL
The production API URL is hardcoded in `nazary-mobile/src/api/client.ts`.
Can also be overridden via `EXPO_PUBLIC_API_URL` env var.

### Build commands
```bash
cd nazary-mobile

# Install EAS CLI
npm install -g eas-cli

# Login
eas login

# Configure (first time only)
eas build:configure

# Android APK (testing)
eas build --platform android --profile preview

# Android AAB (Play Store)
eas build --platform android --profile production

# iOS (App Store)
eas build --platform ios --profile production
```

---

## Free Tier Limits (watch these)

| Resource | Free Tier Limit | Expires |
|----------|----------------|---------|
| EC2 t3.micro | 750 hours/month | 12 months from signup |
| RDS db.t3.micro | 750 hours/month | 12 months from signup |
| RDS storage | 20 GB | 12 months from signup |
| EC2 storage | 30 GB | 12 months from signup |
| Data transfer | 15 GB/month outbound | 12 months from signup |

---

## TODO

- [ ] Set up a domain name (e.g., api.nazary.pk) and point it to EC2 IP
- [ ] Configure SSL with Let's Encrypt
- [ ] Set up S3 bucket for Active Storage image uploads
- [ ] Configure FCM for push notifications
- [ ] Set Google OAuth client ID in mobile app.json
- [ ] Enable Solid Queue for background jobs (create queue/cache/cable DBs)
- [ ] Set up GitHub Actions for auto-deployment on push
