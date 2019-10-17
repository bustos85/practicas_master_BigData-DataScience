# *** Enunciado del ejercicio ***
# Con el conjunto de datos titanic.csv de la practica 3:
# 1. Representar, en un mismo grafico, dos histogramas de la variable age, uno para los pasajeros con 
# sexo masculino y otro para los pasajeros con sexo femenino. En caso de que se solapen los 
# histogramas, usar colores con transparencias (ver funcion rgb()).
# 2. Examinar la variable name, ¿que otra variable podemos extraer de la misma?. 
# Extraer los distintos valores de esa variable.
# 3. Crear una nueva variable title con los valores Master (hombre soltero), Miss (mujer soltera), 
# Mr. (hombre casado), Mrs. (mujer casada) y Otro a partir de la variable nombre. Es importante tener 
# en cuenta que el titulo Miss esta en ocasiones codificado con su abreviatura en frances Mlle 
# (mademoiselle) y lo mismo ocurre con Mrs., que en ocasiones aparece como Ms. o Mme (madame).
# 4. Explorar la relacion entre las variables age y la nueva variable title mediante un boxplot para 
# cada uno de los valores de la misma. ¿Tienen alguna relacion?.
# 5. Ver la relacion entre la supervivencia la nueva variable title con un grafico de barras. En el 
# caso del valor Otros de la variable title, ¿nos proporciona este alguna informacion sobre la 
# supervivencia?. ¿A que se debe?.
# 6. Corregir el problema anterior con el grupo Otros dividiendo el mismo en dos nuevos titulos. 
# Para ello se puede explorar los datos y hacer "trampas", es decir, ver que titulos hasta ahora 
# categorizados como Otros han sobrevivido y cuales no y si se puede encontrar un patron comun entre 
# los mismos.
# 7. Explorar la relacion entre age, pclass y title en varios graficos de dispersion con colores, 
# donde el color representa la supervivencia (Pista: usar facetas).
# 8. En la practica 3 se han completado los missing value de la variable age con la mediana de sus 
# valores. De acuerdo al grafico del punto 7, ¿es esta la solucion correcta?. Completar ahora los 
# missing values pero con la mediana de los valores de acuerdo a las variables pclass y title.
# *** Fin del enunciado ***

install.packages("ggplot2")
library(ggplot2)

# *** 1. 
# cargamos el dataset titanic.csv
datos <- read.table(file = "titanic.csv", header = TRUE, sep = ";", na.strings = "", dec = ",", quote = "", stringsAsFactors = FALSE)
#
ggplot(datos, aes(datos$age)) + geom_histogram() + facet_wrap(~sex) + xlab("Edad")


# *** 2. 
# vemos los primeros valores de la variable name
head(datos$name)
# se puede ver que de esta variable podrían sacarse otras como separar nombre propio del
# apellido y que este ultimo se almacenara en otra variable. Tambien podria sacarse el
# tratamiento Mr, Miss, etc.
unique(datos$name) # con unique se visualizan los valores distintos de una variable


# *** 3. 
# creamos nueva columna que primero rellenamos del 1 al nº de filas del df, la introducimos
# en el df y luego se le asignan los valores sacados del nombre con el uso de split.
nueva.col <- c(seq(1:nrow(datos)))
datos$title <- nueva.col
datos$title <- sapply(datos$name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
# vemos con unique los distintos valores de title
unique(datos$title)
# agrupamos los valores para que los unicos posibles sean 
datos$title[datos$title %in% c('Mlle')] <- 'Miss'
datos$title[datos$title %in% c('Ms', 'Mme')] <- 'Mrs'
datos$title[datos$title %in% c('Major', 'Dr', 'the Countess', 'Jonkheer', 'Rev', 'Don', 'Lady', 'Capt', 'Col', 'Dona', 'Sir')] <- 'Otro'
# volvemos a ver los distintos valores de la variable y ya solo aparecen los 5 requeridos
unique(datos$title)


# *** 4.
# diagrama de cajas con la relacion entre edad y la variable title
boxplot(datos$age ~ datos$title, xlab = "Title", ylab = "Edad")
# se aprecia una relacion, ya que cada titulo identifica a un grupo de personas de edades
# similares 


# *** 5. 
# se crea diagrama de barras para representar los distintos titulos y el nº de supervivientes
# en cada uno
ggplot(data=datos, aes(x=title, y=survived)) + geom_bar(stat="identity")


# *** 6.
# nos quedamos en un df con los pasajeros categorizados con otro en title
datos_otros = datos[datos$title=='Otro',]
valores_otros <- sapply(datos_otros$name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
valores_otros <- unique(valores_otros)
# creamos nueva columna con los valores del grupo otros y la asignamos al df de otros
nueva.col <- c(seq(1:nrow(datos_otros)))
datos_otros$title_dos <- nueva.col
datos_otros$title_dos <- sapply(datos_otros$name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
# ahora sobre la nueva columna volvemos a hacer la grafica de supervivientes
ggplot(data=datos_otros, aes(x=title_dos, y=survived)) + geom_bar(stat="identity")


# *** 7.
# Creamos graficos de dispersion entre age, pclass y title, donde el color representa la 
# supervivencia. Creamos varios variando las variables en los ejes
ggplot(data = datos, mapping = aes(x = age, y = title, color = survived)) + 
geom_point(size = 1) + xlab("Edad") + ylab("Titulo") + facet_wrap(~pclass)

ggplot(data = datos, mapping = aes(x = age, y = pclass, color = survived)) + 
geom_point(size = 1) + xlab("Edad") + ylab("Clase") + facet_wrap(~title)


# *** 8. 
# En la practica 3 se han completado los missing value de la variable age con la mediana de sus 
# valores. De acuerdo al grafico del punto 7, ¿es esta la solucion correcta?. Completar ahora los 
# missing values pero con la mediana de los valores de acuerdo a las variables pclass y title.
# primero sustituimos los NA de la variable age por la mediana para no tener missing values
mediana <- median(datos$age, na.rm=T)
datos$age <- ifelse(is.na(datos$age), mediana, datos$age)
# ahora agrupamos por clase y titulo y se calcula la mediana de age en cada grupo
datos_agrupados <- aggregate(datos$age, by=list(datos$pclass, datos$title), FUN=median)
# ahora se sustituye en el dataset los NAs por la mediana de cada grupo 

