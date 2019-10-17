#!/usr/bin/python3

import sys


def mezcla(text):
    """ Función que coge la cadena pasada y pone primero los caracteres de
    posiciones pares y posteriormente los situados en posiciones impares,
    separados por un guión  """
    return text[::2] + "-" + text[1::2]


def nombre_propio(text):
    """ Función que capitaliza la cadena pasada, poniendo en mayúscula
    el primer caracter """
    return text[:1:].upper() + text[1::].lower()


def normaliza_nombre_fichero(text):
    """ Función que normaliza el nombre del fichero pasado. Primero cambiamos los
    espacios del nombre por guiones bajos, y luego se obtiene la extensión del
    fichero y se pone en minúsculas. """
    textNew = text.replace(" ", "_")
    textNew2 = textNew.rfind(".")

    return textNew[:textNew2:] + textNew[textNew2:len(textNew):].lower()


def dejar_igual(text):
    """ Función que usa split y join para dejar la cadena pasada igual que estaba.
    Primero separamos con split, por lo que si pasáramos un texto tendríamos
    trozos con cada palabra, y luego los juntamos de nuevo con join, por lo que
    al final tendriamos el mismo texto que al inicio. """
    textSeparado = text.split()
    textoJunto = " ".join(textSeparado)

    return textoJunto


def decorar(text, num=80):
    """ Función que decora una cadena a izquierda y derecha con '>' y '<'
    respectivamente. Obtenemos dos cadenas, una con el texto decorado con '>'
    a la izquierda, y otra con el texto decorado a la derecha con '<'.
    Luego las juntamos eliminando de una de ellas el texto para que no esté
    repetido en la cadena final. Por último, vemos si la longitud de la cadena
    no es la que se ha pasado (u 80 por defecto) para añadir un caracter a
    derecha, o dos uno a izquierda y otro a derecha. """
    longitud = len(text)
    mitadLong = longitud // 2
    numMitad = int(num) // 2

    textoIzq = text.rjust(numMitad + mitadLong, ">")
    textoDer = text.ljust(numMitad + mitadLong, "<")
    posicionCaracter = textoDer.find("<")
    text = textoIzq + textoDer[posicionCaracter::]

    if int(num) - len(text) > 1:
        text = ">" + text + "<"
    elif int(num) - len(text) == 1:
        text = text + "<"

    return text


def limpiar(c, e):
    """ Función que le pasamos dos cadenas, y elimina de la primera los
    caracteres que contiene la segunda. Almacenamos los caracteres de la
    segunda en una lista. Recorremos la primera, y por cada caracter vemos
    si está en la lista de caracteres a eliminar, si no está se añade a la
    salida. """
    lista = []
    final = []

    for item in e:
        lista.append(item)

    for item in c:
        bandera = 0
        for elem in lista:
            if item == elem:
                bandera = 1
        if bandera == 0:
            final.append(item)

    return "".join(final)


def poner_mayuscula(text, num):
    """ Función a la que se le pasa un texto y un número, y debe capitalizar
    todas las palabras que tengan longitud igual o mayor al número pasado.
    Además debe devolver el acrónimo. Partimos con split el texto para
    almacenar cada palabra, y se recorre capitalizando aquellas que tienen
    mayor o igual número de caracteres al número pasado. Además se va
    almacenando el primer caracter de cada palabra para obtener el acrónimo."""
    trozos = text.split(" ")
    dos = []
    acronimo = []

    for item in trozos:
        if len(item) >= int(num):
            dos.append(item.capitalize())
            acronimo.append(item[0:1:].capitalize())
        else:
            dos.append(item.lower())
            acronimo.append(item[0:1:].lower())

    return "La frase capitalizada quedaría así: " + " ".join(dos) + "\nEl acrónimo sería: " + "".join(acronimo)


if __name__ == '__main__':

    print("Opciones(Introducir el número correspondiente a la opción elegida)\n1.- Ejercicio 1\n2.- Ejercicio 2\n3.- Ejercicio 3\n4.- Ejercicio 4\n5.- Ejercicio 5\n6.- Ejercicio 6\n7.- Ejercicio 7")

    operaciones = {'1': mezcla, '2': nombre_propio, '3': normaliza_nombre_fichero, '4': dejar_igual, '5': decorar, '6': limpiar, '7': poner_mayuscula}
    seleccion = input('Escoge una opción: ')
    try:
        llamada = operaciones[seleccion]
        unaopcion = ["1", "2", "3", "4"]
        dosopciones = ["6", "7"]
        if seleccion in unaopcion:
            resultado = llamada(sys.argv[1])
        elif seleccion in dosopciones:
            resultado = llamada(sys.argv[1], sys.argv[2])
        elif seleccion == "5" and len(sys.argv) == 2:
            resultado = llamada(sys.argv[1])
        elif seleccion == "5" and len(sys.argv) == 3:
            resultado = llamada(sys.argv[1], sys.argv[2])

        print("El resultado de la función utilizada es: \n" + resultado)
    except:
        print("Ha ocurrido algún error. Asegúrate de introducir bien las opciones que van del 1 al 7.")
