# *** Enunciado del ejercicio ***
# Ejercicios con matrices
# 3. Crea la matriz 4x5 siguiente: 
# A = (1 2 3 4 5
#     6 7 8 9 10
#     11 12 13 14 15
#     16 17 18 19 20)
# *** Fin del enunciado del ejercicio ***

# Se crea la matriz del enunciado:
A <- matrix(1:20,nrow=4,ncol=5,byrow=TRUE,dimnames=list(c("uno","dos","tres","cuatro")))

# *** a.Extrae los elementos A[4,3], A[3,4] y A[2,5] utilizando una matriz de índices. ***
matrizIndices <- matrix(c(4, 3, 3, 4, 2, 5), ncol = 2, byrow=TRUE)
C <- A[matrizIndices]
C


# *** b. Reemplaza dichos elementos con 0. ***
A[matrizIndices] <- 0
A


# *** c. Crea la matriz identidad 5x5 ***
I <- diag(5)
I


# *** d. Convierte la matriz A anterior en una matriz cuadrada B añadiendo al final una fila de unos(función rbind) ***
cinco <- c(1,1,1,1,1)
B <- rbind(A,cinco)
B


# *** e. Calcula la inversa de la matriz B con la función solve ***
inversa <- solve(B)
inversa


# *** f. Multiplica B por su inversa ***
multi <- B%*%inversa # multiplicación de filas por columnas
multi


# *** g. Comprueba si el resultado es exactamente la matriz identidad I ***
iden <- identical(multi,I)
iden


# *** h. En caso contrario, calcular el error o precisión de la operación ***
# Para calcular el error se realiza una división donde el denominador es el número de
# elementos de la matriz B. El numerador será el sumatorio de restar la multiplicación
# de B por la inversa y restarle la matriz identidad.
numerador <- sum(abs(multi-I))
denominador <- length(B)
error <- numerador / denominador
error


