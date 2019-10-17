#!/usr/bin/python3

import sys
import re
import string
import collections


def contar(fichero, numero, fichero_borrar="vacio"):
    """ Función que devuelve la lista de palabras del primer fichero que se
    repiten más veces que el número pasado, así como el número de veces que
    se repite cada palabra. Si se pasa el tercer argumento opcional que es
    otro fichero, no se deben tener en cuenta a la hora de contar las palabras
    que contenga. Se abre el fichero en modo lectura, y se ve si se ha
    recibido el segundo fichero o no, para llamar a la función que hace los
    cálculos con la lista de palabras a no tener en cuenta o no. Por último
    se devuelve un diccionario que contendrá las palabras como clave y el
    número de veces que aparece en el texto como valor. """
    lista_palabras = []

    f = open(fichero, "r")

    if fichero_borrar != "vacio":
        lista_palabras = obtener_palabras(fichero_borrar)
        resultado = calcular(f, numero, lista_palabras)
    else:
        resultado = calcular(f, numero)

    f.close()

    return resultado


def calcular(f, numero, lista_palabras=""):
    """ Función que obtiene las palabras del fichero que se encuentran más
    veces que las indicadas por el dato 'número'. Si se pasa el segundo
    fichero las palabras que contenga no deben tenerse en cuenta. Primero
    se obtienen las linea del fichero, se eliminan signos y se guarda cada
    linea en una lista cortando por el espacio. Se recorre la lista de lineas
    almacenando en una lista cada palabra en minúscula para que todas las
    palabras sean minúsculas y no haya diferencia entre mayúsculas y
    minúsculas. Una vez tenemos la lista de palabras, usamos collections con
    Counter para obtener un diccionario donde las keys son las palabras que
    aparecen y el valor es el número de veces que aparecen. Ordenamos el
    diccionario y luego lo recorremos, para eliminar del mismo las palabras
    que se repiten el número de veces pasado a la función o menos, y si se
    ha pasado el fichero también eliminamos las palabras que aparecen en el
    mismo. """
    resultado = {}
    lista_lineas = []
    lista_pal = []
    conjunto_contar = []

    for line in f:
        if len(line) > 1:
            lista_lineas.append(line.strip())

    lista_lineas = eliminar_signos(lista_lineas)

    for linea in lista_lineas:
        palabra = linea.split()
        lista_pal.append(palabra)

    for item in lista_pal:
        for palabra in item:
            conjunto_contar.append(palabra.lower())

    resultado = collections.Counter(conjunto_contar)
    resultado = collections.OrderedDict(sorted(resultado.items()))

    for k, v in resultado.items():
        if v <= int(numero) or k in lista_palabras:
            del(resultado[k])

    return resultado


def eliminar_signos(lista):
    """ Función para eliminar los signos de puntuación. """
    resultado = []

    for i in lista:
        resultado.append(re.sub('[%s]' % re.escape(string.punctuation), '', i))

    return resultado


def obtener_palabras(fichero_borrar):
    """ Función que en base al fichero recibido devuelve una lista con las
    palabras que aparecen en el mismo, sin repetir. La utilizamos para obtener
    la lista de palabras del segundo fichero que es opcional, y así tener
    en una lista las palabras sin repetir de este fichero para luego que no
    aparezcan en el resultado final al contar en el primer fichero. """
    lista_palabras = []

    f = open(fichero_borrar, "r")

    # se recorre cada línea del fichero y se almacena en una lista
    for line in f:
        lista_palabras.append(line.strip())

    # Se eliminan los signos de puntuación
    lista_palabras = eliminar_signos(lista_palabras)

    # Se obtiene la lista ordenada y sin elementos repetidos
    lista_palabras = sorted(list(set(lista_palabras)))

    f.close()

    return lista_palabras


def obtener_extension(fichero):
    """ Función para obtener la extensión de un fichero """
    pos = fichero.rfind(".")
    ext = fichero[pos + 1:len(fichero):].lower()

    return ext


if __name__ == '__main__':
    # Se controla el número de argumentos y que el tipo del fichero sea .txt
    try:
        if len(sys.argv) == 3 or len(sys.argv) == 4:
            extension = obtener_extension(sys.argv[1])
            if extension == 'txt':
                if len(sys.argv) == 3:
                    resultado = contar(sys.argv[1], sys.argv[2])
                else:
                    resultado = contar(sys.argv[1], sys.argv[2], sys.argv[3])
                for item, valor in resultado.items():
                    print(item + ":", valor)
            else:
                raise Exception("El primer argumento debe ser un fichero")
        else:
            raise Exception("Los argumentos deben ser dos o tres.")
    except Exception as error:
        print(error)
