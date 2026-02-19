# DEVELOPER DOCUMENTATION

## Instruction 

### 1. Prerequisites

- Docker 
- Docker Compose
- GNU Make
- Linux environment (Debian or Ubuntu recommended)

- [General system requirements](https://docs.docker.com/desktop/setup/install/linux/)
- [Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/)

Verify installation:

    - docker --version
    - docker compose version
    - make --version 

### 2. Clone the repository

    git clone https://github.com/IgoryanDeltoro/inception.git && cd inception 

### 3. Configure environment variable

#### Create .env file inside /srcs directory and fill in:

    DOMAIN_NAME=example.com
    NGINX_NAME=nginx

    MYSQL_DATABASE=wordpress
    MYSQL_USER=WordPress_user

    WORDPRESS_DB_HOST=mariadb
    WORDPRESS_DB_NAME=wordpress
    WORDPRESS_DB_USER=WordPress_user
    WORDPRESS_DB_ADMIN=Achilles
    WORDPRESS_DB_TITLE=Inception
    WORDPRESS_DB_PORT=4242

#### Create two files inside /secrets directory for passwords:

    mkdir secrets && touch  secrets/db_password.txt secrets/db_root_password.txt

### 4. Add domain name to /etc/hosts.

    127.0.0.1 example.com

### 5. Allow HTTPS traffic on port 443 through firewall.

    sudo ufw allow 443/tcp

---

## Build and Launch the project.

### 1. Start the project:

    make 

or:

    docker compose up --build -d    

### 2. Access the Website

In the brawser address bar that opens, enter:

    https://example.com

A self-signed TSL certificate is used, so the browser will show a security warning.

###  3.  Access WordPress Admin

    https://example.com/wp-admin

###  4. Stop the Project 

    make down 

## Container Management

List Running Containers:

    make status

View Logs:

    make logs

Restart Containers:

    make restart

Restart Containers with memory wipe:

    make re

Access Container Shell:
ID is the name of the service.

    make exec ID=nginx

Show low-level information on Docker objects:
ID is the name of the service.

    make inspect ID=nginx

## Volume Management

List Volumes:

    make vl

Inspect Volumes:

    make volumes

Remove volumes:

    make clean

or:

    make fclean

## Trobleshooting

Check container staus:

    make status

Check database connections:

    make dconn

Verify network resolution:

    make vnres

##   Checking HTTPS request 

    curl -v -k https://www.example.com
                            