# *** Enunciado del ejercicio ***
# Con el dataframe iris (viene cargado en R y puedes leer su descripción con ?iris):
# *** Fin del enunciado ***


# *** a. ¿Cómo está estructurado el dataframe? Utilizar las funciones str y dim. ***
str(iris) # devuelve información de la estructura del dataframe. Te dice el número de
# filas y columnas, y el nombre de cada columna, el tipo de datos que contiene y sus
# valores.
dimension <- dim(iris) # obtiene la dimensión del dataframe
dimension


# *** b. ¿De qué tipo es cada una de las variables del dataframe?  ***
sapply(iris, FUN = typeof) # se obtiene un vector con el tipo de cada variable
sapply(iris, FUN = mode) # se obtiene un vector con el tipo de cada variable


# *** c. Utilizar la función summary para obtener un resumen de los estadísticos de las variables. ***
summary(iris) # se obtiene un resumen estadístico de los datos del dataframe. Vemos como
# las variables numéricas se muestran datos estadísticos como el mínimo, la media o el 
# máximo. En una variable no numérica, se muestra un recuento de las distintas opciones.


# *** d. Comprueba con las funciones mean y range que se obtienen los mismos valores para cada una de las variables. Pista: usar funciones tipo apply. ***
mean_r <- sapply(iris[,-5], FUN = mean)
range_r <- sapply(iris[,-5], FUN = range) # para poder aplicar ambas funciones no se debe tener en 
# cuenta la última variable o columna del dataframe que tiene datos caracter.
mean_r
range_r


# *** e. Cambia los valores de las variables Sepal.Length y Sepal.Width de las 5 primeras observaciones por NA. ***
iris[1:5, c("Sepal.Length", "Sepal.Width")] <- NA
head(iris)


# *** f. ¿Qué pasa si usamos ahora las funciones mean y range con las variables Sepal.Length y Sepal.Width? ¿Tiene el mismo problema la función summary? ***
mean2_r <- sapply(iris[,-5], FUN = mean)
range2_r <- sapply(iris[,-5], FUN = range) # para las dos primeras variables donde se introdujeron
# algunos valores NA ahora al aplicar las funciones mean y range se obtiene como resultado
# NA, aunque no todos los valores de esa columna sean NA.
mean2_r
range2_r

summary(iris) # summary ofrece entre sus datos el recuento de NAs en aquellas columnas o 
# variables donde hay missing values. El resto de datos se siguen calculando, por tanto a la
# función summary no parece afectar del mismo modo que a las anteriores.


# *** g. ¿Qué parámetro habría que cambiar para arreglar el problema anterior?  ***
mean3_r <- sapply(iris[,-5], FUN = mean, na.rm = TRUE)
range3_r <- sapply(iris[,-5], FUN = range, na.rm = TRUE) # Utilizando na.rm = TRUE se consigue que los
# missing values codificados con NA no sean tenidos en cuenta y entonces al hacer mean y 
# range sobre las dos primeras variables se obtienen unos resultados coherentes.
mean3_r
range3_r


# *** h. Visto lo anterior, ¿por qué es importante codificar los missing values como NA y no como 0, por ejemplo? ***
# Es importante codificar los missing values como NA porque así se pueden realizar operaciones
# sobre esas variables y esos valores pueden no ser tenidos en cuenta que es lo correcto.
# Si se codificaran como 0 si se tendrían en cuenta en las operaciones o estadísticas sobre
# los datos, y por tanto desvirtuarían los resultados.


# *** i. Ordena el dataframe por la columna Sepal.Length con la función order ¿qué sucede con los missing values? Pista: Mirar la documentación de la función order. ***
irisOrder <- iris[order(iris$Sepal.Length),] # las filas o registros que tienen valores NA
# en la columna por la que se ha ordenado se colocan los últimos al ordenar.
head(irisOrder)


# *** j. Elimina los valores NA usando na.omit.  ***
irisSinNAs <- na.omit(irisOrder) # con na.omit se eliminan aquellas filas donde había missing values
irisSinNAs


# *** k. Calcula la media de la variable Petal.Length para cada una de las distintas especies (Species) de dos formas diferentes usando el dataframe obtenido del apartado j. ***
mean.setosa <- mean(irisSinNAs[irisSinNAs$Species == "setosa","Petal.Length"])
mean.setosa
mean.versicolor <- mean(irisSinNAs[irisSinNAs$Species == "versicolor","Petal.Length"])
mean.versicolor
mean.virginica <- mean(irisSinNAs[irisSinNAs$Species == "virginica","Petal.Length"])
mean.virginica
mean_agreg <- aggregate(formula = Petal.Length ~ Species, FUN = mean, data = irisSinNAs)
mean_agreg

