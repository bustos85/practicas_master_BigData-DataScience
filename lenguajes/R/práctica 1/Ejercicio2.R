# *** Enunciado del ejercicio ***
# Ejecuta el siguiente código en R, que genera dos vectores x e y con 250 números enteros
# aleatorios entre 1 y 1000:
# n <- 250
# x <- sample(1:1000, n, replace=T)
# y <- sample(1:1000, n, replace=T)
# *** Fin del enunciado ***


# Código inicial del enunciado del ejercicio
n <- 250
x <- sample(1:1000, n, replace=T)
y <- sample(1:1000, n, replace=T)

# *** a. Calcula el máximo y el mínimo de los vectores x e y. ***
# Para calcular el valor mínimo y máximo de x e y. Se usan las funciones min() y max()
minX <- min(x)
maxX <- max(x)
minY <- min(y)
maxY <- max(y)
minX
maxX
minY
maxY


# *** b. Calcula la media de los vectores x e y. Antes de calcularla, 
# ¿qué valor esperarías? ***
mediaX <- mean(x)
mediaY <- mean(y)
mediaX
mediaY
# Esperaría un valor cercano a la mitad entre los números que se ha creado el vector
# de datos, ya que al ser aleatorio entre el número x e y, lo lógico es que haya 
# números a lo largo de todo el rango y la media acabe tirando a la mitad del rango.


# *** c. Calcula el número de elementos de x divisibles por 2. Pista: 
# Recuerda que el operador módulo es %%. ***
# Vemos de los datos cuales son divisibles por 2 y cuales no, y nos quedamos con los que 
# lo sean almacenándolos, y luego le calculamos el tamaño para saber el número.
logicoX <- c(x%%2 == 0)
pares <- x[logicoX]
longPares <- length(pares)
longPares


# *** d. Ordena los vectores primero usando la función order y luego la función sort. 
# ¿Cuál es la diferencia entre estas dos funciones? ¿Cómo podrías obtener el mismo 
# resultado que sort usando únicamente order? ¿y el resultado de order utilizando la 
# función sort? *** 
xOrder <- order(x)
yOrder <- order(y)
xSort <- sort(x)
ySort <- sort(y)
# Con order(x) lo que se obtiene es un vector con las posiciones que corresponden a
# los elementos del vector original ordenado. Y con sort(x) se obtiene el vector
# ordenado de forma creciente si sólo pasamos el vector como parámetro.

# Para obtener con order() lo mismo que con sort() usamos la siguiente sentencia:
xOrdSort <- x[order(x)] # Se obtienen los elementos ordenados como con sort(x)
yOrdSort <- y[order(y)]

# Para obtener con sort() lo mismo que con order() usamos la siguiente sentencia:
xSortOrd <- sort(x, decreasing=F, index.return=T) # Se obtienen tanto los elementos
# ordenados como las posiciones como con order(x)
ySortOrd <- sort(y, decreasing=F, index.return=T)


# *** e. Selecciona los valores de y menores que 600. ***
menores <- y[y<600]
menores


# *** f. Crea el vector (x1+2x2-x3, x2+2x3-x4, ..., xn-2+2xn-1-xn)
# Donde 𝑥𝑖 representa el elemento i-ésimo del vector x.
# Pista: el vector a generar tiene longitud n-2. ***
# El primer elemento sera x menos los dos últimos elementos, seguido de 2 * x sin 
# el último elemento y comenzado en el segundo, y el tercer elemento sera x con el
# último elemento y comenzando en el tercero.
vector_x <- x[1:248] + 2*x[2:249] - x[3:250]
vector_x


# *** g. Crea el vector: (cosy1sinx2, cosy2sinx3, ..., cosyn-1sinxn).
# Pista: tiene longitud n-1. ***
# Los elementos del vector serán el coseno de los elementos de y empezando por el primero
# entre el seno de los elementos de x comenzando en el siguiente.
vector_cossin <- cos(y[1:249]) / sin(x[2:250])
vector_cossin


