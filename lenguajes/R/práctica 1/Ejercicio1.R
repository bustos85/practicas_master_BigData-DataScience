# *** Enunciado del ejercicio ***
# 1. Los resultados de una encuesta de satisfacción de clientes han sido los siguientes: 
# 4, 3, -7, 10, 3, 5, 4, 2.5, 2, 3, 1, -1 
# Los valores válidos de respuesta eran enteros de 1 a 5, incluidos. Identifica aquellos 
# valores inválidos en el vector, asignarles NA, y calcular la media de satisfacción de 
# los clientes. 
# *** Fin del enunciado ***

# Creamos un vector con los valores iniciales del enunciado
vectorInicial <- c(4, 3, -7, 10, 3, 5, 4, 2.5, 2, 3, 1, -1)
# Creamos otro vector con los valores válidos para el ejercicio que serían los 
# enteros del 1 al 5 ambos incluidos
valores <- c(1:5)
# Al vector inicial le reemplazamos los valores que no estén en el vector de
# valores válidos por missing values NA
vectorValido <- replace(vectorInicial, !vectorInicial %in% valores, NA)
# Por último calculamos la media sobre el vector donde se han cambiado los valores
# no válidos por NA. Al calcular la media no tenemos en cuenta los NA
media <- mean(vectorValido, na.rm = T)
media

