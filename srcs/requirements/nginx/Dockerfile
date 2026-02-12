FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Generate self-signed certificate
# link ==> https://www.avonture.be/blog/docker-localhost-ssl/
RUN mkdir -p  /etc/nginx/ssl &&                                          \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048                  \
    -keyout /etc/nginx/ssl/privkey.pem                                   \
    -out /etc/nginx/ssl/fullchain.pem                                    \
    -subj "/C=AT/ST=Vienna/L=Vienna/O=42/OU=Inception/CN=ibondarc.42.fr" \
    -addext "subjectAltName=DNS:ibondarc.42.fr,DNS:www.ibondarc.42.fr"

COPY ./conf/nginx.conf /etc/nginx/conf.d/nginx.conf

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;"]