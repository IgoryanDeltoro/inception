# USER DOCUMENTATION

## Quick navigation

- [Introduction](#Introduction)
- [Services Provided by the Stack](#Services-Provided-by-the-Stack)
- [Starting the Project](#Starting-the-Project)
- [Stopping the Project](#Stopping-the-Project)
- [Accessing the Administration Panel](#Accessing-the-Administration-Panel)
- [Locating and Managing Credentials](#Locating-and-Managing-Credentials)
- [Checking that Services are Running](#Checking-that-Services-are-Running)
- [Data Persistence](Data-Persistence)

---

## Instruction 

### 1. Introduction

This projcet provides a complete WordPress website infrastructure running
inside Docker containers.

- NGINX - Web server handling HTTPS connections    
- WordPress - Wesite content management system    
- PHP-FPM - Executes WordPress PHP code    
- MariaDB Database storing website data    
- Docker Volumes - Persistent storage for database and website files
    
All services are automatically started and connected together.

---
    
### 2. Services Provided by the Stack

The stack delivers:

- A secure HTTPS website    
- A wordPress administration panel    
- A persistent database    
- Automatic container orchestration via Docker Compose
    
The system is designed so that services restart cleanly and data persists across 
restarts.

---

### 3. Starting the Project

From the project root directory:

    make
    
Or manually:
    
    docker compose up -d

This will:

- build images    
- create required volumes    
- create containers
- start all services

---

### 4. Stopping the Project 

To stop containers:

    make down
    
Or: 

    docker compose down
    
To stop and remove all stored data

    make fclean

### 5. Accessing the Websit

Make sure your /etc/hosts file contains:
    
    127.0.0.1 login.42.fr

Then open in your browser:

    https://login.42.fr
    
Because a self-signed SSL certificate is used, your browser will display a security 
warning. You may safely proceed.

---

## 6. Accessing the Administration Panel

To manage the website:
    
     https://login.42.fr/wp-admin
    
Log in using the administrator credentials defined during installation.

---

## 7. Locating and Managing Credentials

All credential are stored in srcs/.env and secrets/

- secrets/db_password.txt - wp password    
- secrets/db_password.txt - root password    
- MYSQL_USER=wp_user

To modify credentials:

1. Stop the project    
2. Edit the .env file    
3. Restart the project

It's very important! The .env file must never be committed to Git.

---

##  8. Checking that Services are Running

### Check Running Containers

    make ps
    
You should see:

- nginx    
- wordpress    
- mariadb
    
### Check Logs

    make logs
    
or check single container:

    dicker logs "service name"

### Test HTTPS Connection

    curl -v -k https://login.42.fr
    
---

## 9. Data Persistence 

The project uses Docker volumes to store:

- Database data
- WordPress content
    
This means:

- Data survives container restarts 
- Data survives **docker compose down**    
- Data is removed only when using **make fclean** or **docker compose down -v**
    
---

## 10. Troubleshooting

If the website does not load:

1. Check containers are running:
        
    make ps 
    
2. Check logs:
    
    make logs
        
3. Ensure domain is correctly added to /etc/hosts
    



