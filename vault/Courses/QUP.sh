#!/bin/bash

# Ruta de la carpeta (usa "." si estás ya dentro)
carpeta="."

# Recorremos todos los archivos *.md (ajusta si usas otro tipo)
for archivo in "$carpeta"/*.md; do
    # Nombre sin ruta
    nombre_archivo=$(basename "$archivo")
    
    # Separar nombre y extensión
    nombre_sin_ext="${nombre_archivo%.*}"
    extension="${nombre_archivo##*.}"

    # Quitar la última palabra
    nuevo_nombre=$(echo "$nombre_sin_ext" | sed 's/ [^ ]*$//')

    # Construir nombre nuevo con extensión
    nuevo_archivo="${carpeta}/${nuevo_nombre}.${extension}"

    # Renombrar si el nombre cambió
    if [[ "$archivo" != "$nuevo_archivo" ]]; then
        mv "$archivo" "$nuevo_archivo"
        echo "Renombrado: $archivo → $nuevo_archivo"
    fi
done
