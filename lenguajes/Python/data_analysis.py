import pandas as pd
from pandas import DataFrame
from pandas import Series
from pandas.tools.plotting import scatter_matrix
import numpy as np
import matplotlib.pyplot as plt

######################################################################################
# Funcion load_data: 
# Carga en un DataFrame de pandas los datos leidos de un fichero con formato csv.
#
# Argumentos:
#  inputFile: nombre del fichero csv que contiene los datos.
#  delimiter: caracter que delimita los datos en el fichero; por defecto es una
#             coma (",").
#  nan: lista de Strings que seran tratados como missing values; cualquier aparicion 
#       en el fichero de entrada de una de las cadenas en esta lista se interpretara 
#       como un NaN; el valor por defecto es None.
#  header: flag booleano que indica si el fichero contiene cabecera (True) o si no 
#          (False); por defecto es True.
#  varNames: lista de Strings que se usan como nombres de las variables solo en el 
#            caso en el que header sea False; el valor por defecto es None.
#  pref: string que se usa como prefijo para los nombres de las variables solo en 
#        el caso en el que header sea False y no se haya definido la lista 
#        varNames;  por ejemplo, si pref = "x", los nombres de las variables seran 
#        "x0", "x1", "x2", etc; el valor por defecto es "var_".
#
# Devuelve: 
#  DataFrame con los datos leidos del fichero.
######################################################################################
def load_data(inputFile, delimiter = ",", nan = None, header = True,
              varNames = None, pref = "var_"):

    data = DataFrame() 
#-------------------------------------------------------------------------------------
# Ejercicio 1. Carga de datos.
# Incluye aqui tu codigo:
#-------------------------------------------------------------------------------------
    # Se incluye el modulo os para capturar la ruta del fichero a cargar
    import os

    # Esta realizado en MAC OS y se ha visto que es necesario formatear de esta manera la ruta
    path = os.getcwd() + "/" + inputFile

    # El argumento header de la funcion recibe None cuando no hay cabecera, e infer como valor
    # por defecto cuando si hay cabecera en el archivo a cargar
    if header is False:
        header = None
        # Si header es False y varNames esta definido no se debe utilizar prefijo para columnas
        if varNames is True:
            pref = None
    else:
        header = 'infer'
        varNames = None
        pref = None

    data = pd.read_csv(path, sep=delimiter, na_values=nan, header=header, names=varNames, prefix=pref)
#-------------------------------------------------------------------------------------
# Fin del codigo necesario para el ejercicio 1.
#-------------------------------------------------------------------------------------
   
    return data

######################################################################################
# Funcion compute_statistics:
# Calcula estadisticas sobre los datos contenidos en un DataFrame.
#
# Argumentos:
#  data: DataFrame con los datos .
#
# Devuelve: 
#  DataFrame con las estadisticas calculadas, que son las siguientes:
#
#  - count: numero de valores validos (aquellos que no son *NaN*).
#  - nan: numero de valores missing (aquellos que son *NaN*).
#  - total: numero total de valores.
#  - unique: numero de valores unicos.
#  - unique_not_nan: numero de valores unicos que no son *NaN*.
#  - dtype: tipo de dato de la variable.
#
#  Si la variable es numerica, tambien se calculan e incluyen las siguientes 
#  estadisticas:
#
#  - mean: valor medio.
#  - std: esviacion estandar.
#  - min: valor minimo.
#  - max: valor maximo.
######################################################################################
def compute_statistics(data):

    stats = DataFrame(index = data.columns, columns = ["count", "nan", "total",
                                                       "unique", "unique_not_nan",
                                                       "dtype", "mean", "std",
                                                       "min", "max"])
#-------------------------------------------------------------------------------------
# Ejercicio 2. Calculo de estadisticas.
# Incluye aqui tu codigo:
#-------------------------------------------------------------------------------------
    # Hacemos los calculos correspondientes a cada columna del dataframe de
    # entrada y se lo asignamos a su columna del nuevo dataframe
    stats['count'] = data.count()
    stats['nan'] = data.isnull().sum()
    stats['total'] = stats['count'] + stats['nan']
    stats['unique'] = data.apply(lambda x: len(x.unique()))
    stats['unique_not_nan'] = data.apply(Series.nunique)
    stats['dtype'] = data.dtypes

    # Estos calculos deben hacerse si los datos son numericos
    stats['mean'] = data.mean(numeric_only=True)
    stats['std'] = data.std(numeric_only=True)
    stats['min'] = data.min(numeric_only=True)
    stats['max'] = data.max(numeric_only=True)
#-------------------------------------------------------------------------------------
# Fin del codigo necesario para el ejercicio 2. 
#-------------------------------------------------------------------------------------
 
    return stats

######################################################################################
# Funcion detect_duplicates:
# Devuelve las filas duplicadas.
#
# Argumentos:
#  data: DataFrame con los datos.
#
# Devuelve: 
#  x: DataFrame con las filas que aparecen duplicadas en data. La ultima columna de
#     x, num_reps, contiene el numero de repeticiones de cada fila. 
######################################################################################
def detect_duplicates(data):

    x = DataFrame(columns = data.columns.tolist() + ["num_reps"])
#-------------------------------------------------------------------------------------
# Ejercicio 3. Deteccion de filas duplicadas. Para hacer este ejercicio puedes
# encontrar utiles los metodos duplicated, drop_duplicates y groupby de la clase
# DataFrame.
# Incluye aqui tu codigo:
#-------------------------------------------------------------------------------------
    # Utilizamos duplicated para obtener las filas repetidas del dataframe pasado
    # asi tenemos otro dataframe solo con las filas duplicadas.
    df_duplicados = data[data.duplicated(keep=False)]

    # En otro dataframe eliminamos los duplicados y nos queda un dataframe solo con la
    # primera aparicion de cada fila duplicada, incluido el indice.
    df_single_duplicados = df_duplicados.drop_duplicates()

    # Se utiliza groupby para agrupar por columnas y hacer un recuento de las filas repetidas. 
    # Primero se cambian los NaN por un valor para poder ejecutarle el groupby al dataframe. 
    # Hacemos el groupby al dataframe que solo tiene ya las filas repetidas del original.
    df_agrupados = df_duplicados.fillna(value="vacio").groupby(df_duplicados.columns.tolist()).size().reset_index(name='num_reps')
    df_agrupados = df_agrupados.replace('vacio', np.nan) 

    # Una vez tenemos los dos dataframe, hacemos un merge para obtener la union de ambos en el orden
    # que queremos, que sabemos que es el correcto. Asignamos posteriormente los indices correctos
    # correspondientes al primer dataframe de la primera aparicion de cada duplicado.
    df_unido = pd.merge(df_single_duplicados, df_agrupados, on=df_single_duplicados.columns.tolist(), how='right')
    df_unido.index = df_single_duplicados.index
    x = df_unido
#-------------------------------------------------------------------------------------
# Fin del codigo necesario para el ejercicio 3. 
#-------------------------------------------------------------------------------------

    return x

######################################################################################
# Funcion plot_data:
# Dibuja graficas sobre los datos de un DataFrame.
#
# Argumentos:
#  data: DataFrame con los datos.
#  x: String con el nombre de una columna del DataFrame.
#  y: (opcional) String con el nombre de otra columna del DataFrame.
#
# Devuelve:
#  Nada, dibuja un tipo u otro de grafica en funcion de los argumentos x e y:
#  - Si ambos argumentos existen y son numericos, se invoca a la fucion plot_scatter
#    para dibujar un diagrama de dispersion de data[y] frente a data[x].
#  - Si solo existe x y es numerico, se invoca a la funcion plot_histogram para
#    dibujar un histograma con los valores de data[x].
#  - Si solo existe x y no es numerico, se invoca a la funcion plot_bars para
#    dibujar un diagrama de barras con los valores de data[x].
#  - En cualquier otro caso la funcion no dibuja ninguna grafica.
######################################################################################
def plot_data(data, x, y = None):

    if y == None:
        # Si solo hay una variable, x:
        if np.issubdtype(data[x].dtype, np.number):
            # Si x es numerica dibujamos el histograma:
            plot_histogram(data[x])
        else:
            # Si x no es numerica hacemos un diagrama de barras:
            plot_bars(data[x])
    elif np.issubdtype(data[x].dtype, np.number) and np.issubdtype(data[y].dtype, np.number):
        # Si hay dos variables ambas deben ser numericas, hacemos un
        # scatter-plot:
        plot_scatter(data[x], data[y])
    
######################################################################################
# Funcion plot_bars:
# Dibuja un diagrama de barras sobre los datos.
#
# Argumentos:
#  x: Serie con los datos.
#
# Devuelve:
#  Nada, dibuja un diagrama de barras con el numero de veces que se repite cada
#  valor en la Serie, ignorando los missing values.
######################################################################################
def plot_bars(x):

    plt.figure(figsize=(10, 6))    
#-------------------------------------------------------------------------------------
# Ejercicio 4. Funcion plot_bars.
# Incluye aqui tu codigo:
#-------------------------------------------------------------------------------------
    # Para la grafica horizontal se utiliza la funcion barh. Hay que tener en cuenta
    # eliminar los missing values para que funcione correctamente. Pasamos como nombres
    # de los elementos del eje Y los distintos valores posibles sin contar NaN.
    plt.barh(np.arange(x.nunique(dropna=True)), np.array(x.value_counts(dropna=True)), align = 'center', color = 'red', tick_label = list(x.dropna().unique()))
#-------------------------------------------------------------------------------------
# Fin de tu codigo. 
#-------------------------------------------------------------------------------------

    plt.grid(True)
    plt.xlabel('counts')
    plt.ylabel('values')

######################################################################################
# Funcion plot_scatter:
# Dibuja un diagrama de dispersion sobre los datos.
#
# Argumentos:
#  x: Serie con los datos a representar en el eje x.
#  y: Serie con los datos a representar en el eje y.
#
# Devuelve:
#  Nada, dibuja un diagrama de dispersion de los valores en y frente a los valores
#  en x. 
######################################################################################
def plot_scatter(x, y):

    plt.figure(figsize=(8, 8))    
#-------------------------------------------------------------------------------------
# Ejercicio 4. Funcion plot_scatter.
# Incluye aqui tu codigo:
#-------------------------------------------------------------------------------------
    # Para el diagrama de dispersion se utiliza la funcion scatter.
    plt.scatter(x, y, c = 'red', edgecolor='black', linewidth='1')
#-------------------------------------------------------------------------------------
# Fin de tu codigo. 
#-------------------------------------------------------------------------------------

    plt.grid(True)
    plt.xlabel(x.name, size=16)
    plt.ylabel(y.name, size=16)

######################################################################################
# Funcion plot_histogram:
# Dibuja un histograma sobre los datos.
#
# Argumentos:
#  x: Serie con los datos.
#
# Devuelve:
#  Nada, dibuja un histograma con los datos. Para calcular el histograma se ignoran
#  todos los puntos cuya distancia al promedio es mayor de 3 desviaciones estandar
#  (estos puntos se consideran outliers). El numero de cajas del histograma es el
#  minimo entre 100 y el numero de puntos (descontando missing values y outliers)
#  dividido entre 20.
######################################################################################
def plot_histogram(data):

    plt.figure(figsize=(8, 6))    
#-------------------------------------------------------------------------------------
# Ejercicio 4. Funcion plot_histogram.
# Incluye aqui tu codigo:
#-------------------------------------------------------------------------------------
    # quitamos missing values al conjunto de datos a utilizar
    data = data.dropna()

    # calculamos el valor minimo y maximo permitido para los datos a tener en cuenta para realizar el grafico. 
    # Seran validos aquellos datos comprendidos en estos valores, que son calculados como el punto promedio mas 3 
    # veces la desviacion estandar, y el punto promedio menos 3 veces la desviacion estandar.
    punto_max = data.mean()+(data.std()*3)
    punto_min = data.mean()-(data.std()*3)

    # obtenemos el conjunto de datos que estan comprendidos entre ambos puntos minimo y maximo
    data_z = data[(data >= punto_min) & (data <= punto_max)]

    # calculamos el numero de cajas para la funcion hist. Las cajas seran el valor menor entre
    # 100 (valor por defecto) y dividir el numero de datos valido entre 20.
    cajas = 100
    num = int(np.ceil(len(data_z)/20.0))
    if num < cajas:
        cajas = num

    # una vez tenemos todos los datos necesarios se invoca a la funcion hist
    plt.hist(data_z, cajas, color='red', edgecolor='white', linewidth='1')
#-------------------------------------------------------------------------------------
# Fin de tu codigo. 
#-------------------------------------------------------------------------------------

    plt.grid(True)
    plt.xlabel('values')
    plt.ylabel('counts')

######################################################################################
# Funcion compute_distances:
# Calcula distancias utilizando bucles.
#
# Argumentos:
#  x: array de NumPy con tamanyo Nxd, cada fila es un vector, cada columna una
#     dimension.
#  y: array de NumPy con tamanyo Mxd, cada fila es un vector, cada columna una
#     dimension.
#
# Devuelve:
#  D: matriz de distancias, el elemento D[i,j] contiene la distancia euclidea entre
#     x[i,:] e y[j,:]
######################################################################################
def compute_distances(x, y):

    # Numero de ejemplos y dimension:
    N, d  = x.shape
    M, d_ = y.shape
    
    # La dimension de x e y debe ser la misma:
    if d != d_:
        print "Dimensiones de x e y no coinciden, no puedo calcular las distancias..."
        return None

    # Calculo de las distancias con bucles:
    D = np.zeros((N, M))
    for i, vx in enumerate(x):
        for j, vy in enumerate(y):
#-------------------------------------------------------------------------------------
# Ejercicio 5. Funcion compute_distances.
# Incluye aqui tu codigo:
#-------------------------------------------------------------------------------------
            # Para cada elemento se calcula el valor a introducir en la matriz resultado
            # que sera la raiz cuadrada del sumatorio de la diferencia al cuadrado.
            valor = np.sqrt(np.sum((vx-vy)**2))
            D[i, j] = valor
#-------------------------------------------------------------------------------------
# Fin de tu codigo. 
#-------------------------------------------------------------------------------------

    return D

######################################################################################
# Funcion compute_distances_vect:
# Calcula distancias utilizando operaciones vectoriales de NumPy.
#
# Argumentos:
#  x: array de NumPy con tamanyo Nxd, cada fila es un vector, cada columna una
#     dimension.
#  y: array de NumPy con tamanyo Mxd, cada fila es un vector, cada columna una
#     dimension.
#
# Devuelve:
#  D: matriz de distancias, el elemento D[i,j] contiene la distancia euclidea entre
#     x[i,:] e y[j,:]
######################################################################################
def compute_distances_vect(x, y):

    # Numero de ejemplos y dimension:
    N, d  = x.shape
    M, d_ = y.shape
    
    # La dimension de x e y debe ser la misma:
    if d != d_:
        print "Dimensiones de x e y no coinciden, no puedo calcular las distancias..."
        return None

    # Calculo de las distancias sin bucles:
    D = np.zeros((N, M))

#-------------------------------------------------------------------------------------
# Ejercicio 5. Funcion compute_distances_vect.
# Incluye aqui tu codigo:
#-------------------------------------------------------------------------------------
    # Sin utilizar bucles, usamos funciones de numpy
    D = np.sqrt(np.sum((x[:,np.newaxis,:] - y[np.newaxis,:,:]) ** 2, axis=-1))
#-------------------------------------------------------------------------------------
# Fin de tu codigo. 
#-------------------------------------------------------------------------------------

    return D

