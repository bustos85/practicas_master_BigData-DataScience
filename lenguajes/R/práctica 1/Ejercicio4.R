# *** Enunciado del ejercicio ***
# Con el dataframe mtcars (viene cargado en R y puedes leer su descripción con ?mtcars): 
# *** Fin del enunciado ***


# *** a. Previsualiza el contenido con la función head ***
previsualizacion <- head(mtcars)
previsualizacion


# *** b. Mira el número de filas y columnas con nrow y ncol ***
numFilas <- nrow(mtcars)
numCols <- ncol(mtcars)
numFilas
numCols


# *** c. Crea un nuevo dataframe con los modelos de coche que consumen 
# menos de 15 millas/galón (mpg) ***
dataC <- mtcars[mtcars$mpg<15,]
dataC


# *** d. Ordena el dataframe del apartado c) por cilindrada (disp.) ***
dataCord <- dataC[order(dataC$disp),] # por defecto ordena de manera creciente
dataCord


# *** e. Calcula la media del peso (wt) de los modelos del dataframe del apartado c) ***
media <- mean(dataC$wt)
media


# *** f. Cambia el nombre de las variables del dataframe del apartado c) a var1, var2, ….,
# var11. Pista: Mira la documentación de la función paste y úsala para generar el 
# vector (“var1”, “var2”, …, “varN”), donde N es el número de variables del dataframe. ***
nombres <- paste(c("var"), 1:ncol(dataC), sep="")
names(dataC) <- nombres
dataC

