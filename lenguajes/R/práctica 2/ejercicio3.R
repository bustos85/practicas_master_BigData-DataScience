# *** Enunciado del ejercicio ***
# Con el conjunto de datos diamonds original (no el modificado en el ejercicio 1):
# 1. Ver el tipo de cada una de las variables.
# 2. Realizar un analisis estadistico de las variables numericas: calcular la
# media, varianza, rangos, etc. ¿Tienen las distintas variables rangos muy diferentes?.
# 3. Hacer un grafico de cajas de la variable price para cada uno de los distintos valores de color.
# 4. Hacer el mismo grafico del punto anterior pero con un grafico de cajas para cada uno de los 
# valores de la variable cut.
# 5. Calcular la correlacion de todas las variables numericas con la variable price.
# 6. Crear un histograma de la variable carat para cada uno de los distintos valores de color.
# ¿Son muy diferentes las distribuciones?.
# 7. Realizar un grafico de dispersion para las variables que tienen mas y menos correlacion con 
# price y comentar los resultados. ¿Como seria el grafico de dispersion entre dos vectores con 
# correlacion 1?.
# 8. Definimos los outliers como los elementos (filas) de los datos para los que cualquiera de las 
# variables (numericas) esta por encima o por debajo de la mediana mas/menos 3 veces el MAD 
# (Median Absolute Deviation). Identificar estos outliers y quitarlos.
# 9. Separar el conjunto de datos en dos subconjuntos disjuntos de forma aleatoria, el primero 
# conteniendo un 70% de los datos y el segundo un 30%.
# 10. Escalar los datos para que tengan media 0 y varianza 1, es decir, restar a cada variable 
# numerica su media y dividir por la desviacion tipica. Calcular la media y desviacion en el conjunto 
# de train, y utilizar esa misma media y desviacion para escalar el conjunto de test.
# *** Fin del enunciado ***


# *** 1. 
# cargamos los datos y colocamos los nombres a cada variable
diamonds <- read.csv(file = "diamonds.csv", header = TRUE, sep = ",", na.strings = "", dec = ".", stringsAsFactors = FALSE)
colnames(diamonds)<-c("id","carat","cut","color","clarity","depth","table","price","x","y","z")
# con typeof junto a sapply se aplica a cada variable la funcion y se obtiene un vector con los tipos
sapply(diamonds, FUN = typeof)
sapply(diamonds, FUN = mode) # mode no distingue entre los distintos tipos de valores numéricos


# *** 2. 
# con summary se realiza un resumen estadistico de cada variable del dataframe
summary(diamonds)


# *** 3.
# con la funcion bloxpot se crean diagramas de cajas, y se pasa la variable x e y implicadas
boxplot(diamonds$price ~ diamonds$color, xlab = "Color", ylab = "Precio")


# *** 4.
# con la funcion bloxpot se crean diagramas de cajas, y se pasa la variable x e y implicadas
boxplot(diamonds$price ~ diamonds$cut, xlab = "Corte", ylab = "Precio")


# *** 5. 
# la correlacion entre dos variables se calcula con la funcion cor y se le pasan las variables
# sacar las numericas con is.numeric
cols_numericas <- sapply(diamonds, is.numeric)
diamonds_numericas <-diamonds[,cols_numericas]
# eliminamos del cáclulo de la correlacion la variable id que es la primera columna del df
matriz_cor <- cor(diamonds_numericas[2:ncol(diamonds_numericas)])
# obtener la fila de la matriz correspondiente a price que tiene los valores de correlacion
# del resto de variables contra price
cor_price <- matriz_cor[4,-4]


# *** 6.
# instalamos y cargamos el paquete ggplot2 para hacer gráficas avanzadas
# con ggplot creamos un histograma para la variable carat para cada tipo de color
install.packages("ggplot2")
library(ggplot2)
ggplot(diamonds, aes(diamonds$carat)) + geom_histogram() + facet_wrap(~color)


# *** 7.
# los diagramas de dispersion se crean con la funcion plot. Lo hacemos para la variable con mas 
# correlacion y la que menos con la variable price
plot(diamonds[,8], diamonds[,2], main="")
plot(diamonds[,8], diamonds[,7], main="")
# con ggplot2
ggplot(data=diamonds, aes(x=price, y=carat))+geom_point()
ggplot(data=diamonds, aes(x=price, y=table))+geom_point()


# *** 8. 
# partimos del dataframe con valores numéricos diamonds_numericas. Creamos una funcion
# para obtener los outliers y otra para eliminarlos
obtener_outliers <- function(df, corte = 3) {
  # Calculamos la mediana y el valor mad
  mediana_outlier <- apply(df, 2, median, na.rm = TRUE)
  mad_outlier <- apply(df, 2, mad, na.rm = TRUE)
  # Se identifican las filas que son outliers
  result <- mapply(function(d, s, r) {
    which(d > s+corte*r|d < s-corte*r)
  }, df, mediana_outlier, mad_outlier)
  result
}

# se aplica la funcion anterior y se obtienen los outliers existentes en el dataframe
outliers_diamonds <- obtener_outliers(diamonds_numericas)

# se crea funcion para eliminar los outliers asignandoles valor NA
eliminar_outliers <- function(df, outliers) {
  result <- mapply(function(d, o) {
    res <- d
    res[o] <- NA
    return(res)
  }, df, outliers)
  return(as.data.frame(result))
}

# se aplica la funcion de eliminar outliers y luego se eliminan del datafrme las filas 
# con valores NA y asi eliminar los elementos del df que contenian outliers
diamonds_sin_outliers <- eliminar_outliers(diamonds_numericas, outliers_diamonds)
diamonds_sin_outliers <-na.omit(diamonds_sin_outliers)


# *** 9.
# generamos dos subconjuntos del dataset, uno con el 70% de registros y otro con el 30%
ind <- sample(2, nrow(diamonds_numericas), replace = TRUE, prob = c(0.7, 0.3))
train <- diamonds_numericas[ind == 1, ]
test <- diamonds_numericas[ind == 2, ]


# *** 10.
# se instala y carga el paquete plyr que contiene numerosas funciones para ayudar en la 
# manipulacion de datos
install.packages("plyr")
library(plyr)

# obtenemos la media y la desviacion tipica del dataframe train
media_train = numcolwise(mean)(train)
desviacion_train = numcolwise(sd)(train)
media_desviacion = rbind(media_train,desviacion_train)

# creamos una funcion para escalar los datasets aplicando los datos de media y desviacion
# como se indica en el enunciado, a ambos datasets con los datos calculados a partir de train
escalar = function(dataframe, media_desviacion){
  as.data.frame(
    Map(function(columna, paramn){
      (columna-paramn[1])/(paramn[2])
    }, dataframe, media_desviacion)
  )
}

# aplicamos a los datasets de train y test la media y desviacion para escalar los datos
train_escalado = escalar(train, media_desviacion)
test_escalado = escalar(test, media_desviacion)

