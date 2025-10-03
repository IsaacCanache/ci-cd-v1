# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# Instalar dependencias
RUN apt-get update \
 && apt-get install -y python3 python3-pip nginx \
 && rm -rf /var/lib/apt/lists/*

# Instalar Flask
RUN pip3 install flask==2.2.5

# Copiar aplicación y configuración
COPY helloworld.py /app/helloworld.py
COPY nginx.conf /etc/nginx/sites-available/default
COPY start.sh /start.sh

WORKDIR /app

# Variables de entorno y puerto expuesto
ENV FLASK_APP=helloworld
EXPOSE 80

# Arrancar Nginx + Flask
CMD ["/start.sh"]
