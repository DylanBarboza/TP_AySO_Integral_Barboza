#!/bin/bash


	#ruta del archivo
LISTA="./Lista_URL.txt"

# Fecha y hora actual
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

ANT_IFS=$IFS
IFS=$'\n'

			#bucle para procesar cada linea de archivo ##
for line in $(grep -v '^#' "$LISTA" | grep -v '^[[:space:]]*$' | grep -v '^#################################$' | grep -v '^$'); do
    
    # filtro por dominio y url
    DOMAIN=$(echo "$line" | awk '{print $1}')
    URL=$(echo "$line" | awk '{print $2}')

    # Obtengo estado HTTP
    STATUS_CODE=$(curl -LI -o /dev/null -w '%{http_code}\n' -s "$URL")

    #imprimo la fecha, url y code
    echo "$TIMESTAMP - URL:$URL - Code:$STATUS_CODE"
done

IFS=$ANT_IFS

