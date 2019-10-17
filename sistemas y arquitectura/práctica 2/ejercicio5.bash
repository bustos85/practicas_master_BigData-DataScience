#!/bin/bash

if [ $# -eq 1 ]; then
	interfaz=$1
	ethtool --show-offload $interfaz > fichero.txt
	cat fichero.txt
	rm fichero.txt
else
	echo "El número correcto de argumentos es 1"
fi
