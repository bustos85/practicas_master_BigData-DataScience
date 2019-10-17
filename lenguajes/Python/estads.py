#!/usr/bin/python3

import sys
import statistics
from itertools import chain
from collections import defaultdict


def calcular_estadisticas(fichero, opciones):
    """ Función que recoge un fichero y en base a las opciones pasadas en
    el segundo parámetro realiza una serie de cálculos sobre los datos del
    fichero. Se recogen los caracteres pasados como opción en una lista, y
    con un bucle for se llama a una función que realiza los cálculos de
    cada opción. Los resultados se almacenan en una lista que se devolverá
    para mostrar por pantalla los resultados. Antes de ver las opciones para
    realizar cada una de las llamadas a funciones requeridas, se obtiene un
    diccionario con una lista por cada columna con sus valores, para pasarlo
    a las funciones y que hagan los cálculos en base a los valores de cada
    columna. También se obtienen dos listas una con el número de cada columna
    que alberga valores numéricos y otra con las columnas que albergan datos
    alfabéticos. """
    lista_opciones = []
    resultado = []

    # almacenamos las opciones pasadas a la función en una lista
    for carac in opciones:
        lista_opciones.append(carac)

    # Se abre el fichero en modo lectura
    f = open(fichero, "r")

    # Se obtiene el diccionario con listas, una por cada columna y sus valores
    dicCol = obtener_columnas(f)

    # Se obtienen dos listas, una con las columnas que albergan valores
    # numéricos, y otra con las columnas que albergan datos alfabéticos.
    col_num, col_alfa = tipo_columnas(dicCol)

    # Se realiza un bucle para recorrer la lista de opciones y realizar
    # cada una de las llamadas.
    resul = []
    for item in lista_opciones:
        if item == 'p':
            resul = promedio_moda(dicCol, col_num, col_alfa)
        elif item == 's':
            resul = desviacion_distintos(dicCol, col_num, col_alfa)
        elif item == 'n':
            resul = numero_validos(dicCol)
        elif item == 'm':
            resul = minimo_menos(dicCol, col_num, col_alfa)
        elif item == 'M':
            resul = maximo_mas(dicCol, col_num, col_alfa)

        resultado.append(resul)

    f.close()

    return resultado


def obtener_columnas(f):
    """ Función que obtiene una lista con los elementos de cada columna
    del fichero. Recorremos cada linea del fichero y las vamos almacenando en
    una lista. Luego se crea un diccionario por cada linea, donde la clave será
    la posición del elemento en la lista y el value el valor del elemento. Una
    vez tenemos los diccionarios por linea los almacenamos en una lista de
    diccionarios. Por último, agrupamos en un sólo diccionario todos los
    diccionarios obtenidos anteriormente, agrupando por la key que sería el
    número de la columna en el fichero y los values la lista de sus valores."""
    lista = []
    listaDic = []
    dicFinal = defaultdict(list)

    for line in f:
        line = line.strip().split(",")
        if len(line) > 1:
            lista.append(line)

    for item in lista:
        dic = {}
        for i in range(len(item)):
            dic[i] = item[i]
        listaDic.append(dic)

    for item in listaDic:
        for k, v in chain(item.items()):
            dicFinal[k].append(v)

    return dicFinal


def tipo_columnas(dicCol):
    """ Función para obtener las columnas del fichero que son númericas y
    las que son cadenas de caracteres. Se recorre el diccionario con las listas
    de valores por columna, mirando cada valor de la columna y cuando se ve si
    es alfabético o numérico se almacena el número de la columna en la lista
    que corresponda. """
    tipos_num = []
    tipos_alfa = []

    for i in range(0, len(dicCol)):
        for j in range(0, len(dicCol[i])):
            enc = 0
            if dicCol[i][j].isalpha() is True and dicCol[i][j] != "?":
                tipos_alfa.append(i)
                break
            elif dicCol[i][j].isalpha() is False and dicCol[i][j] != "?":
                for c in dicCol[i][j]:
                    if c.isalpha() is True:
                        enc = 1
                        break
                if enc == 1:
                    tipos_alfa.append(i)
                else:
                    tipos_num.append(i)
                break

    return tipos_num, tipos_alfa


def eliminar_interrogaciones(columna):
    """ Función para eliminar los signos de interrogación de una lista. """
    resul = []

    for i in range(0, len(columna)):
        aux = ""
        if columna[i] != "?":
            aux = columna[i]
            resul.append(aux)

    return resul


def promedio_moda(dicCol, col_num, col_alfa):
    """ El programa calculará el promedio para los atributos numéricos y
    la moda para los atributos categóricos. Se recorren las columnas del
    fichero, si la columna es alfabética se mira la moda de sus valores,
    si la columna es indefinida se asigna el caracter ?, y si la columna
    es numérica se calcula el promedio de sus valores diferenciando si la
    columna almacena números enteros o con decimales. """
    resultado = []

    for i in range(0, len(dicCol)):
        variable = ""
        aux = []

        if i in col_num:
            sin_signos = eliminar_interrogaciones(dicCol[i])
            for j in range(0, len(sin_signos)):
                if sin_signos[j].find(".") >= 0:
                    aux.append(float(sin_signos[j]))
                elif sin_signos[j] != "?":
                    aux.append(int(sin_signos[j]))
            variable = round(statistics.mean(aux), 2)
        elif i in col_alfa:
            sin_signos = eliminar_interrogaciones(dicCol[i])
            variable = statistics.mode(sin_signos)
        else:
            variable = "?"

        resultado.append(variable)

    return resultado


def desviacion_distintos(dicCol, col_num, col_alfa):
    """ Calcula la desviación estándar de los tipos numéricos y el número
    de valores distintos para los atributos categóricos. Se recorren las
    columnas del fichero, si la columna es alfabética se calculan los valores
    distintos que alberga dicha columna, para ello se crea un conjunto con
    sus valores y como no permite duplicados sólo almacena los distintos y
    se puede ver su longitud. Para las columnas que todos sus valores sean
    indefinidos se asigna el caracter ?, y para las columnas que sus valores
    sean numéricos se calcula la desviación estandar, mirando si los valores
    de la columna en cuestión son números enteros o con decimales."""
    resultado = []

    for i in range(0, len(dicCol)):
        variable = ""
        aux = []
        if i in col_num:
            sin_signos = eliminar_interrogaciones(dicCol[i])
            for j in range(0, len(sin_signos)):
                if sin_signos[j].find(".") >= 0:
                    aux.append(float(sin_signos[j]))
                elif sin_signos[j] != "?":
                    aux.append(int(sin_signos[j]))
            variable = round(statistics.pstdev(aux), 2)
        elif i in col_alfa:
            sin_signos = eliminar_interrogaciones(dicCol[i])
            variable = len(list(set(sin_signos)))
        else:
            variable = "?"
        resultado.append(variable)

    return resultado


def numero_validos(dicCol):
    """ Devuelve el número de valores válidos para cada atributos.
    Es decir el número de valores distintos de interrogación. Recorremos cada
    columna del fichero, y se cuentan los valores de dicha columna que no son
    iguales al caracter ?. """
    resultado = []

    for i in range(0, len(dicCol)):
        contador = 0
        for j in range(0, len(dicCol[i])):
            if dicCol[i][j] != "?":
                contador += 1

        resultado.append(contador)

    return resultado


def minimo_menos(dicCol, col_num, col_alfa):
    """ Devuelve el mínimo para cada atributo. Para atributos categóricos
    devolverá el valor que menos aparece. Recorremos las columnas del fichero,
    diferenciando entre columnas que albergan números y las que albergan
    caracteres alfabéticos. Si todos los valores de la columna son indefinidos
    se asigna el caracter ? a su valor en la salida. """
    resultado = []

    for i in range(0, len(dicCol)):
        minimo = ""
        minimo_veces = 0

        for j in range(0, len(dicCol[i])):
            if i in col_num:
                if dicCol[i][j] == "?":
                    pass
                elif j == 0 or minimo == "" or dicCol[i][j] < minimo:
                    minimo = dicCol[i][j]
            elif i in col_alfa:
                if dicCol[i][j] == "?":
                    pass
                else:
                    numero_veces = dicCol[i].count(dicCol[i][j])
                    if j == 0 or minimo_veces == 0 or numero_veces < minimo_veces:
                        minimo_veces = numero_veces
                        minimo = dicCol[i][j]
            else:
                minimo = "?"

        resultado.append(minimo)

    return resultado


def maximo_mas(dicCol, col_num, col_alfa):
    """ Devuelve el máximo para cada atributo. Para atributos categóricos
    devolverá el valor que más aparece.
    Se recorren las columnas del fichero, y para cada una se diferencia entre
    columnas que albergan números o caracteres alfabéticos. Si todos los
    valores de la columna son indefinidos, se asigna el caracter ? al valor
    de esa columna en la salida. """
    resultado = []

    for i in range(0, len(dicCol)):
        maximo = ""
        maximo_veces = 0

        for j in range(0, len(dicCol[i])):
            if i in col_num:
                if dicCol[i][j] == "?":
                    pass
                elif j == 0 or maximo == "" or dicCol[i][j] > maximo:
                    maximo = dicCol[i][j]
            elif i in col_alfa:
                if dicCol[i][j] == "?":
                    pass
                else:
                    numero_veces = dicCol[i].count(dicCol[i][j])
                    if j == 0 or numero_veces > maximo_veces:
                        maximo_veces = numero_veces
                        maximo = dicCol[i][j]
            else:
                maximo = "?"

        resultado.append(maximo)

    return resultado


def obtener_extension(fichero):
    """ Función para obtener la extensión de un fichero """
    pos = fichero.rfind(".")
    ext = fichero[pos + 1:len(fichero):].lower()

    return ext


if __name__ == '__main__':
    # Se controla el número de argumentos y que el tipo del fichero sea .csv
    try:
        if len(sys.argv) == 3:
            extension = obtener_extension(sys.argv[1])
            if extension == 'csv':
                resultado = calcular_estadisticas(sys.argv[1], sys.argv[2])
                for item in resultado:
                    for j in range(0, len(item) + 1):
                        if j == len(item):
                            print("")
                        elif j == 0:
                            print(str(item[j]), end="")
                        else:
                            print("," + str(item[j]), end="")
            else:
                raise Exception("El primer argumento debe ser un fichero .csv")
        else:
            raise Exception("Los argumentos deben ser dos.")
    except Exception as error:
        print(error)
