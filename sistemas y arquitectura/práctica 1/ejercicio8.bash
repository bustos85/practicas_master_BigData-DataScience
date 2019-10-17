#!/bin/bash
#Primero eliminamos el fichero con los tiempos de la anterior ejecución
#Con un bucle for lanzamos time 4 veces para calcular el tiempo real en ejecutar el script
#Almacenamos los 4 tiempos en un fichero de texto, lo recorremos con un for para sumar los tiempos
#Una vez tenemos el total calculamos la media

rm tiemposprueba.txt

for i in `seq 1 4`;
do
	(sudo time -f "%e" ./calculaFG.bash) 2>> tiemposprueba.txt
done

tiempos=`head -4 tiemposprueba.txt`
suma=0
for item in ${tiempos[*]}
do
	suma=`echo "$suma+$item" | bc -l`
done

media=$(echo "$suma/4" | bc -l)

echo "Los tiempos de cada una de las 4 ejecuciones han sido: "$tiempos
echo "La media ha sido: "$media

