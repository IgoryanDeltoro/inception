*This project has been created as part of 42 curriculum by ibondarc.*

![Architecture] (assets/architecture.webp)

# INCEPTON - Dockerized Web Infrastracture

---

##  Description

**Inception** is a system administration and DevOps project focused on building a secure,
production-style web infrasructure using Docker. The goal of this project is to conteinerize
a complete WordPress stack composed of:

- **NGINX** (revere proxy with TLSv1.2 or TLSv1.3)
- **PHP-FPM**
- **MariaDB** 
- **WordPress**
- Persistent storage via Docker volumes
- Secure comunication over HTTPS 

The infrastracture is orchestrated usin **Docker Compose** and follows best practices in container isolation, service networking, TLS configuration, and data persistence.

This project demonstrates how modern web services are deployed in isolated environments while maintaining secure and maintainable architecture.

---

##  Project Architecture

**Browset** => **NGINX** => **PHP-FPM (WordPress)** => **MariaDB**

Each service runs in its own container and communicate throught a private Docker network
using a specific port.

---

##  Why Docker?

Docker allows applications and services to run in isolated containers that include all required
dependencies. This guarantees:

- Isolation
- Portability
- Reeproducibility
- Simplified deployment

---

##  Technical Design Choices

###     Virtual Machines vs Docker

| Virtual Machines        | Docker                  |
|-------------------------|-------------------------|
| Full OS per VM          | Sharres host kernel     |
| Heavy resource usage    | Lightweight containers  | 
| Slover startup          | Fast startup            |
| Hardware virtualization | OS-level virtualization |

Docker is preferred becouse it's lightweight and faster than full OS such as Linux, in addition
better suited for microservice-based architectures.

---

###     Secrets vs Environment Variable

| Secrets                     | Environment Variables       |
|-----------------------------|-----------------------------|
| Securely stored             | Visible in container config |
| Not exposed in image layers | Can leak in logs            |
| Better for prodaction       | Acceptable for development  |

In this project, environment variables are used for simplicity, but secrets are recommendet for production
environments.

---

###     Docker Network vs Host Network

| Dcker Network               | Host Network                |
|-----------------------------|-----------------------------|
| Container isolated          | Shares host networking      |
| Internal DNS resolution     | No isolation                |
| Better security             | Less secure                 |
| Controlled communication    | Direct host access          |

A didicated Docker bridge network is used to ensure service isolation and internal DNS resolution.

---

###     Docker Volumes vs Bind Mounts

| Dcker Volumes               | Bind Mounts                 |
|-----------------------------|-----------------------------|
| Managed by Docker           | Linked to host filesystem   |
| Portable                    | Host-dependent              |
| Safer in production         | Good for development        |
| Abstract storage location   | Direct host access          |

Docker volumes are used to persist database and WordPress data securely and independently 
from the host system.

---

##  Instruction 

###  1  Prerequisites

- Docker 
- Docker Compose
- GNU Make
- Linux environment (Debian or Ubuntu recommended)

[General system requirements](https://docs.docker.com/desktop/setup/install/linux/)
[Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/)

---

###  2  Clone the repositoty

    git clone https://github.com/IgoryanDeltoro/inception.git && cd inception 

---

###  3  Configure environment variable

#### Create .env file inside /srcs and fill in:

    DOMAIN_NAME=*example.com*
    MYSQL_DATABASE=*wordpress*
    MYSQL_USER=*WordPress user*
    MYSQL_PASSWORD=*WordPress password*
    WORDPRESS_DB_HOST=*mariadb*
    WORDPRESS_DB_NAME=*wordpress*
    WORDPRESS_DB_USER=*WordPress user*

---

###  4  Add domain name to /etc/hosts

    127.0.0.1 example.com

---

###  5  Build and start the project

    make 

####  if the project was built:

    make up 

---

###  6  Access the Website

#### In the brawser address bar that opens, enter:

    https://example.com

#### A self-signed TSL certificate is used, so the browser will show a security warning.

---

###  7  Access WordPress Admin

    https://example.com/wp-admin

---

###  8  Stop the Project 

    make down 

---

##   Checking Services 

###  List running containers:
    
    make status

###  View logs:
    
    make logs 

###  Display the details about a service in an easily readable format:

    make inspect ID=ServiceName

###  Execute a command in a running container:

    make exec ID=ServiceName 

---

##  Resources

[Docker Documentation](https://docs.docker.com/)
[Docker compose Documantation](https://docs.docker.com/compose/)
[NGINX Documentation](https://nginx.org/en/docs/)
[TLS Wickipedia](https://en.wikipedia.org/wiki/Transport_Layer_Security)
[PHP-FPM Documentation](https://www.php.net/manual/en/install.fpm.php)
[MariaDB Documentation](https://mariadb.org/documentation/)
[WordPress Documentation](https://mariadb.org/documentation/)
