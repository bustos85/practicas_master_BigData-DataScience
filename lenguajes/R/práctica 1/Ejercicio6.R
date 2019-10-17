# *** Enunciado del ejercicio ***
# El conjunto de datos titanic contiene información sobre los pasajeros del barco. 
# Este conjunto de datos se ha utilizado para tratar de predecir la supervivencia de un 
# pasajero en base a otra serie de variables como edad, sexo, o la clase del billete. 
# Ver por ejemplo: https://www.kaggle.com/c/titanic. 
# El conjunto de datos se proporciona en el fichero titanic.csv junto con el enunciado de 
# la práctica1. Cada una de las variables del fichero contiene la siguiente información: 
# • pclass: Clase del pasajero. (1 = primera clase; 2 = segunda clase; 3 = tercera clase) 
# • survived: Supervivencia (0 = No; 1 = Sí) 
# • name: Nombre del pasajero 
# • sex: Sexo del pasajero 
# • age: Edad del pasajero. La edad está en años, salvo para edades menores a un año, que contienen un número fraccional correspondiente al número de meses. 
# • sibsp: Número de hermanos/cónyuge a bordo 
# • parch: Número de padres/hijos a bordo 
# • ticket: Número de billete 
# • fare: Precio del billete 
# • cabin: Cabina 
# • embarked: Puerto de embarque (C = Cherbourg; Q = Queenstown; S = Southampton) 
# En los siguientes ejercicios vamos a realizar un análisis descriptivo de la información 
# contenida en este conjunto de datos. 
# *** Fin del enunciado ***


# *** a. Leer el fichero titanic.csv como un dataframe. Los campos de este fichero se encuentran separados por punto
# y coma (;), los missing values se codifican como cadena vacía, y los separadores decimales vienen indicados con coma.
# Para la lectura del fichero, también es necesario indicar que no existe un delimitador especial para cadenas de
# caracteres. Esto se hace con la opción quote="". No codificar las cadenas de caracteres como factores, dado que esto
# no tiene sentido para algunas variables como name. ***
# Tenemos el archivo a cargar en el directorio de trabajo de R
datos <- read.table(file = "titanic.csv", header = TRUE, sep = ";", na.strings = "", dec = ",", quote = "", stringsAsFactors = FALSE)


# *** b. Calcular el porcentaje de pasajeros que sobrevivió. ***
# almacenamos de los datos los que tienen el campo survived a 1 y son supervivientes.
# obtenemos el número de estos, y lo dividimos por el número de datos iniciales y multiplicamos por 100
supervivientes <- datos[datos$survived==1,]
numSuperv <- nrow(supervivientes)
porcenSuperv <- (numSuperv/nrow(datos))*100
porcenSuperv


# *** c. Calcular el porcentaje de missing values en cada uno de los atributos. Pista: averiguar qué devuelve la función
# is.na cuando se aplica a un dataframe. ***
# primero obtenemos un vector con los registros que son NA en cada atributo
# sobre ese vector podemos aplicar a cada atributo su número de elementos que son NA 
# dividido por el total de registros de cada atributo * 100 con lo cual obtendremos un
# vector que tendra para cada atributo el porcentaje de registros con valor NA.
vector_recuento <- sapply (datos, function (x) which (is.na(x)))
total <- nrow(datos)
vector_porcentajes <- sapply(vector_recuento, function (x) (length(x)/total)*100)
vector_porcentajes


# *** d. Eliminar la variable cabin del dataframe. ***
datos$cabin <- NULL


# *** e. Completar los missing values del atributo age con la mediana del resto de datos. Pista: función median. ***
mediana <- median(datos$age, na.rm=T)
datos$age <- ifelse(is.na(datos$age), mediana, datos$age)


# *** f. Calcular la probabilidad de supervivencia en base al género. ¿Qué conclusión(es) obtienes del resultado?.
# Pista: dado que la variable survived toma el valor 1 cuando el pasajero sobrevivió, es sencillo calcular la 
# probabilidad de supervivencia con una función estadística. ***
# Podría enfocarse en base al total de pasajeros, porque el número de pasajeros de cada género
# no es el mismo, por tanto podemos calcular el número de pasajeros total de cada género.
# Y luego con ese número y teniendo el número de supervivientes de cada género, sacar el porcentaje
pasajeros_male <- datos[datos$sex=='male',]
pasajeros_female <- datos[datos$sex=='female',]
superv_male <- supervivientes[supervivientes$sex=='male',]
superv_female <- supervivientes[supervivientes$sex=='female',]
porcen_total_male <- (nrow(superv_male)/nrow(pasajeros_male))*100
porcen_total_female <- (nrow(superv_female)/nrow(pasajeros_female))*100
porcen_total_male
porcen_total_female
# se puede observar que el porcentaje de supervivencia por género se acentua, ya que el número
# de pasajeros masculinos es mayor que el femenino y al mismo tiempo su número de fallecidos es
# muy superior. Entre el género masculino sobrevivió un 19.1%, y en el género femenino sobrevivió
# un 72,75%
porcentajes_sex <- aggregate(formula=survived~sex, FUN=mean, data=datos)
porcentajes_sex
# con el uso de aggregate también podemos obtener estos porcentajes de 19,1% para el genero masculino
# y de un 72,75% para el genero femenino


# *** g. Calcular la probabilidad de supervivencia en base a la edad. ¿Te parecen fácilmente interpretables estos 
# resultados? ***
# Con aggregate obtenemos la supervivencia en base a la edad, para cada edad se obtiene el porcentaje
# de supervivencia expresado entre 0 y 1. No parecen del todo fácil de intepretar los datos obtenidos.
porcentajes_age <- aggregate(formula=survived~age, FUN=mean, data=datos)
porcentajes_age
# podría verse en base a algunos grupos de edad, como menores de 18, entre 18-36, entre 36 y 65, y por
# último mayores de 65. Dividimos el número de pasajeros que están en cada franja de edad y sobrevivieron
# entre el total de pasajeros de esa franja de edad y multiplicamos por 100 para que el porcentaje esté 
# representado entre 0 y 100 en lugar de entre 0 y 1.
porcentaje_menores <- (nrow(datos[datos$age<18 & datos$survived==1,])/nrow(datos[datos$age<18,]))*100
porcentaje_jovenes <- (nrow(datos[datos$age>=18 & datos$age<=36 & datos$survived==1,])/nrow(datos[datos$age>=18 & datos$age<=36,]))*100
porcentaje_adultos <- (nrow(datos[datos$age>36 & datos$age<=65 & datos$survived==1,])/nrow(datos[datos$age>36 & datos$age<=65,]))*100
porcentaje_mayores <- (nrow(datos[datos$age>65 & datos$survived==1,])/nrow(datos[datos$age>65,]))*100
porcentaje_menores
porcentaje_jovenes
porcentaje_adultos
porcentaje_mayores


# *** h. Crea una nueva variable decade en el dataframe que contenga la década de la edad de los pasajeros y 
# repite el análisis del apartado g) sobre esta nueva variable. ¿Qué conclusión(es) obtienes del resultado? ***
nueva.col1 <- c(seq(1:1309))
datos$decade <- nueva.col1
datos$decade <- cut(datos$age, breaks = seq(0,100,10))


# *** i. Calcula la probabilidad de supervivencia en base a la clase del billete del pasajero (pclass).
# ¿Qué conclusión(es) obtienes del resultado? ***
porcentajes_class <- aggregate(formula=survived~pclass, FUN=mean, data=datos)
porcentajes_class # se puede ver como el porcentaje de supervivencia es mayor para la clase más alta,
# y va bajando según baja también la clase del pasajero. 


# *** j. Combina en una tabla el análisis de la probabilidad de supervivencia en base al sexo y clase del billete 
# del pasajero. ¿Qué conclusiones se obtienen? ***
tabla_analisis <- aggregate(formula=survived~sex+pclass, FUN=mean, data=datos)
tabla_analisis
# Se puede observar al sacar los porcentajes en base tanto al género como a la clase, que los porcentajes
# de supervivencia en las mujeres son más altos que en los hombres para la misma clase y van decreciendo
# a medida que baja el nivel de la clase (la clase más alta es la 1 y la más baja la 3). En los hombres
# se observa que el porcentaje de supervivencia es prácticamente el mismo entre los hombres de clase 2
# y los de clase 3, incluso algo ligeramente superior para los de clase 3.


# *** k. Crea dos nuevas variables en el dataframe con la siguiente información:
# • familysize: número total de parientes incluyendo al propio pasajero.
# • sigleton: valor lógico indicando con valor TRUE si el pasajero viaja solo y FALSE en caso contrario. ***
nueva.col1 <- c(seq(1:1309))
nueva.col2 <- c(seq(1:1309))
datos$familysize <- nueva.col1
datos$sigleton <- nueva.col2
# una vez creadas las dos nuevas columnas y añadidas al dataframe, se calculan los valores
# requeridos para cada una
datos$'familysize' = datos$sibsp+datos$parch+1
datos$'sigleton' = ifelse(datos$familysize<2, TRUE, FALSE)


# *** l. Calcula la probabilidad de supervivencia en base a si el pasajero viajaba solo o no. ¿Qué conclusión se 
# puede obtener? ***
porcentajes_sigleton <- aggregate(formula=survived~sigleton, FUN=mean, data=datos)
porcentajes_sigleton
# El porcentaje de supervivencia es mayor entre los pasajeros que viajaban acompañados.


# *** m. Cuenta el número de pasajeros por tamaño de familia y clase. Por ejemplo, cuántos pasajeros de primera 
# clase pertenecen a una familia de tamaño 4. El resultado debe ser una matriz con la información para todas las 
# posibles combinaciones de clase del billete y tamaño de familia. ***
# con la función table creamos la matriz que tendrá como columnas los distintos valores que coge el 
# atributo del tamaño de familia y como filas los valores para el tipo de clase.
matriz_pasajeros <- table(datos$pclass, datos$familysize)
matriz_pasajeros


# *** n. El fichero titanic2.csv contiene información adicional sobre los pasajeros del barco:
# • boat: identificador del bote salvavidas
# • body: identificador del cuerpo
# • home.dest: Origen/destino
# Leer este fichero (con el mismo tipo de formato que titanic.csv). Para unificar estos dos datraframes, parecería 
# buena opción utilizar la variable name como clave. Determina si esta variable es única por pasajero utilizando 
# la función duplicated y mostrando el número de nombres diferentes repetidos. En caso de existir varios pasajeros
# con el mismo nombre, listar aquellas filas del dataframe inicial en las que el nombre del pasajero esté repetido 
# (la función %in% puede resultar útil para ello). De acuerdo a los resultados, ¿sería la combinación del nombre 
# del pasajero y la clase una buena clave para combinar los dataframes? ***
datosDos <- read.table(file = "titanic2.csv", header = TRUE, sep = ";", na.strings = "", dec = ",", quote = "", stringsAsFactors = FALSE)
# En datosDos tendremos los registros leidos del segundo fichero csv
nombres_repetidos <- table(duplicated(datos$name)) # vemos que hay dos nombres repetidos, por lo 
# tanto el nombre no es un valor único e identificativo en el dataframe inicial
nombres_rep <- datos[duplicated(datos$name),]
nombres_rep # se obtienen los 2 pasajeros que tienen nombre repetido en el dataframe
nombres_repetidos_2 <- table(duplicated(datosDos$name))
nombres_rep_2 <- datosDos[duplicated(datosDos$name),]
nombres_rep_2 # se comprueba que en el segundo dataframe los nombres repetidos son los mismos que en el
# dataframe inicial


# *** o. Combina ambos dataframes utilizando la combinación del nombre y el número de billete respetando el orden 
# de los dataframes de partida. ***
datos_final <- merge(datos, datosDos, by = c("name","ticket"), all.x = T, all.y = T)


# *** p. ¿Qué porcentaje de los pasajeros que sobrevivió tiene asociado un identificador del bote salvavidas? ***
superv_final <- datos_final[datos_final$survived==1,]
superv_final_sinNA <- superv_final[is.na(superv_final$boat)==F,]
porcentajes_boat <- (nrow(superv_final_sinNA)/nrow(superv_final))*100
porcentajes_boat # el 95% de los supervivientes tiene asociado un id de bote salvavidas. El resto tendría
# NA en dicho atributo.


# *** q. Guarda la información de las variables name, age, sex, ticket, pclass, boat por este orden para los 
# pasajeros supervivientes en el fichero titanic_all.csv usando como separador de columnas el tabulador (\t), 
# indicando las cadenas de caracteres con dobles comillas, usando el punto como separador decimal, y mostrando el 
# nombre de las columnas y las filas. ***
# Creamos un dataframe sobre el que teníamos del apartado anterior con los pasajeros supervivientes, con las 
# columnas que queremos almacenar en el fichero csv.
superv_write <- superv_final[,c("name","age","sex","ticket","pclass","boat")]
write.table(x = superv_write, file = "./titanic_all.csv", sep = "\t", dec = ".", row.names = TRUE, col.names = TRUE)


