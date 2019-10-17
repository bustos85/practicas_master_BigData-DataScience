#!/bin/bash
# script que crea tantos ficheros como número de argumentos se pasen al script
# con el tamaño en MB de cada uno de los argumentos.

if [ $# -ge 1 ]; then
    numArgs=$#
    listaArgs=$@

    for i in $@;
    do
	    dd if='/dev/random' of='rnd_'$i'.txt' bs=1024 count=$i*1024
    done


else
	echo "El número de argumentos debe ser al menos 1, y expresar en MB el tamaño."
fi
