#!/bin/bash
clear

###############################
#
# Parametros:
#  - Lista de Usuarios a crear
#  - Usuario del cual se obtendra la clave
#
#  Tareas:
#  - Crear los usuarios segun la lista recibida en los grupos descriptos
#  - Los usuarios deberan de tener la misma clave que la del usuario pasado por parametro
#
###############################

# usuario donde quiero q se tome la clave
USUARIO_BASE="vagrant"

# el path de lista de usuarios
LISTA="./Lista_Usuarios.txt"

# hago que tenga la misma contraseña del usuario base
CLAVE_USUARIO=$(sudo getent shadow "$USUARIO_BASE" | cut -d: -f2)

# Guardar el IFS original
ANT_IFS=$IFS
IFS=$'\n'

# Bucle para procesar cada línea del archivo
for LINEA in $(grep -v '^#' "$LISTA"); do
    #filtro por coma
    USUARIO=$(echo "$LINEA" | awk -F ',' '{print $1}')
    GRUPO=$(echo "$LINEA" | awk -F ',' '{print $2}')
    DIRECTORIO=$(echo "$LINEA" | awk -F ',' '{print $3}')
    
    #creo grupo 
    sudo groupadd -f "$GRUPO"
    

    if [ ! -d "$DIRECTORIO" ]; then
        # Crear el directorio de inicio si no existe
        sudo mkdir -p "$DIRECTORIO"
        sudo chown "$USUARIO:$GRUPO" "$DIRECTORIO"
        sudo chmod 700 "$DIRECTORIO"
    fi


    #asigno/creo el grupo, directorio y usuario
    sudo useradd -m -s /bin/bash -g "$GRUPO" -d "$DIRECTORIO" "$USUARIO"

      		#establesco la misma contraseña q el usuario
    echo "$USUARIO:$CLAVE_USUARIO" | sudo chpasswd

    # Imprimir el comando ejecutado para verificación
    echo "--usuarios creados--"
done

# Restaurar el IFS original
IFS=$ANT_IFS

