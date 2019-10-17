#!/bin/bash
#Se realiza control para que el número de argumentos pasado sea 1 como se dice en el enunciado
#Una vez se pasa un argumento, se obtiene su extensión y se realiza una búsqueda en el directorio actual 
#con esa extensión, se guardan los resultados en un fichero y se cuenta el número de lineas de dicho fichero
#Se muestra el número de archivos con la extensión y se elimina el fichero auxiliar creado.

if [ $# -eq 1 ]; then
	cadena=$1
	ext=${cadena#*.}
	`find . -maxdepth 1 -type f -name "*.$ext" > fichero.txt`
	lineas=`cat fichero.txt | wc -l`
	echo "El número de archivos con esa extensión es: "$lineas
	rm fichero.txt
else
	echo "El número correcto de argumentos es 1"
fi
