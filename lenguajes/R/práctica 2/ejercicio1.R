# *** Enunciado del ejercicio ***
# Con el dataset diamonds (viene incluido en el paquete ggplot2), crear un nuevo dataframe que 
# sea el resultado de aplicar las siguientes operaciones:
# 1. Filtrar los diamantes con corte "Ideal".
# 2. Seleccionar las columnas carat, cut, color, price y clarity.
# 3. Crear una nueva columna precio/quilate.
# 4. Agrupar los diamantes por color.
# 5. Calcular la media del precio/quilate para cada uno de los grupos anteriores.
# 6. Ordenar por precio/quilate de forma descendente.
# *** Fin del enunciado ***


# *** 1.
# leemos los datos y cargamos en un dataframe con la función read.csv
# luego damos el nombre a las variables, y filtramos creando otro dataframe con los datos que cumplen
# una caracteristica, que el valor de una variable sea uno determinado.
diamonds <- read.csv(file = "diamonds.csv", header = TRUE, sep = ",", na.strings = "", dec = ".", stringsAsFactors = FALSE)
colnames(diamonds)<-c("id","carat","cut","color","clarity","depth","table","price","x","y","z")
diamonds_ideal <- diamonds[diamonds$cut=='Ideal',]


# *** 2. 
# se seleccionan varias columnas del dataframe, desechando el resto
diamonds_ideal <- diamonds_ideal[,c("carat","cut","color","price","clarity")]


# *** 3. 
# se crea una nueva columna en principio con valores secuenciales, tantos como numero de registros tiene
# el dataframe. Se añade esta nueva columna al dataframe, y luego se calculan sus valores a partir de
# otros del propio dataframe.
nueva.col <- c(seq(1:nrow(diamonds_ideal)))
diamonds_ideal$precio_quilate <- nueva.col
diamonds_ideal$'precio_quilate' = diamonds_ideal$price/diamonds_ideal$carat


# *** 4.
# se agrupa en un dataframe por la variable color
diamonds_ideal_agrup <- aggregate(diamonds_ideal, by=list(diamonds_ideal$color), FUN="mean")


# *** 5. 
# se muestra por cada grupo anterior por color, el valor de precio por quilate para cada uno
diamonds_media <- aggregate(diamonds_ideal$precio_quilate, by=list(diamonds_ideal$color), FUN="mean")


# *** 6.
# con la función order se ordena el dataframe por la columna indicada, con la opcion decreasing a 
# T sera en orden descendente.
diamonds_ideal_order <- diamonds_ideal[order(diamonds_ideal$precio_quilate, decreasing=T),]

