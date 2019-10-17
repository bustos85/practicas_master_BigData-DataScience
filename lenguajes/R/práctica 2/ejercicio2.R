# *** Enunciado del ejercicio ***
# 1. Cargar el paquete tidyr.
# 2. Leer el conjunto de datos weather.txt. Cuidado con los missing values, estan codificados como 
# "-" (ver parametro na.strings de read.table).
# 3. Identificar cuales son las variables en los datos.
# 4. Agrupar las variables d1-d31 en dos variables dia y temperatura (funcion gather).
# 5. Convertir las columnas element y temperatura en dos variables TMAX y TMIN (funcion spread, 
# es la operacion contraria a gather).
# 6. Separar la columna id en dos variables, pais e id.
# *** Fin del enunciado ***


# *** 1.
# Primero se instala el paquete y luego se carga
install.packages("tidyr")
library(tidyr)


# *** 2. 
# usamos la función read.table con las opciones adecuadas y se cargan los datos en un dataframe
weather <- read.table(file = "weather.txt", header = TRUE, sep = "\t", na.strings = "-", dec = ",", stringsAsFactors = FALSE)


# *** 3. 
names(weather) # se obtienen el nombre de columnas (variables) del dataframe
str(weather) # se obtiene el tipo de cada variable, y se visualiza para cada una los primeros valores
# almacenados. 

# *** 4.
# con la función gather agrupamos todas las columnas menos las 4 primeras en dos variables dia y temperatura
weather_agrupado = gather(weather,dia,temperatura,-1,-2,-3,-4)


# *** 5. 
# con la función spread creamos dos variables a partir de los valores de element y almacenan los valores 
# a partir de la variable temperatura
weather_spread = spread(weather_agrupado, key = element, value = temperatura)


# *** 6.
# obtenemos un dataframe con una columna dividida en dos, con la función separate le indicamos el
# separador requerido, que en este caso es la posición del caracter por el que queremos separar
weather_separate = separate(data = weather_spread, col = id, into = c("pais", "id"), sep = 2)


