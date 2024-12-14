# atlys-task

This repository contains the source code for the Atlys web application. It includes a frontend built with React.js, a backend using Node.js and Express, and a MySQL database. It is containerized using Docker and deployed on Google Cloud Platform (GCP) with SSL support via Traefik.

---

## Prerequisites
1. **GCP Account**
2. **Docker and Docker Compose**
3. **Git**

---

## Setup Instructions

### Clone the Repository
```bash
git clone https://github.com/SubhanshuMG/atlys-task.git
cd atlys-task
```

### Configure Environment Variables
env-vars specified in docker-compose.yaml:
```
DB_HOST=34.170.73.196
DB_USER=root
DB_PASSWORD=atlys123
DB_NAME=atlys
```

### Dockerize the Application
Build and run containers:
```bash
docker-compose up -d
```

---

## Deployment Instructions

### Step 1: Setup GCP VM Instance
- Create a VM instance with Ubuntu OS.
- Install Docker and Docker Compose:
```bash
sudo apt update && sudo apt install docker.io docker-compose -y
```

### Step 2: Deploy Application
1. Clone the repository on the VM:
   ```bash
   git clone <repository-url>
   cd atlys-clone
   ```
2. Run Docker Compose:
   ```bash
   docker-compose up -d
   ```

### Step 3: Add SSL with Traefik
Update DNS records and configure Traefik in `docker-compose.yml`.
```bash
# Restart containers
docker-compose up -d
```

---

# Brief Report: Architecture and Design Decisions

## 1. Architecture Overview
The application is a full-stack implementation:
- **Frontend**: React.js with React Router for navigation.
- **Backend**: Node.js (Express) to handle API requests.
- **Database**: MySQL for structured data storage.
- **Containerization**: Docker and Docker Compose for environment consistency.
- **Deployment**: Hosted on GCP with Traefik for SSL and load balancing.

### Design Decisions
- **React.js**: Chosen for its component-based architecture and seamless SPA implementation.
- **MySQL**: Reliable RDBMS for handling application data.
- **Traefik**: Used for managing SSL and routing due to its lightweight nature and compatibility with Docker.
- **GCP**: Selected for scalability, reliability, and integration with modern DevOps tools.

---

## 2. Challenges Faced
### Dockerizing MySQL
Configuring persistent storage and ensuring network isolation between containers took additional debugging.

### SSL Configuration
Integrating Traefik with Let's Encrypt required additional DNS configuration and testing.

### Deployment Automation
Ensuring seamless CI/CD integration with GitHub Actions for a multi-service setup.

---

## Access Details

### Application URLs
- **Frontend**: https://atlys-fe.subhanshumg.com
- **Backend API**: https://atlys-be.subhanshumg.com
- **Traefik Dashboard**: https://monitor-atlys.subhanshumg.com

### Credentials
|  Type    |  Username |  Password |
|----------|-----------|-----------|
| mysql_db |   root    | atlys123  |
| traefik  |   admin   | admin11!! |

