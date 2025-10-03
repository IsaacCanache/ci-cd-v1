#!/bin/bash
# Iniciar nginx en primer plano
nginx -g 'daemon off;' &
# Ejecutar Flask
flask run --host=0.0.0.0 --port=8000
