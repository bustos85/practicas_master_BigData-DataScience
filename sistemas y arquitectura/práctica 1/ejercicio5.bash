#!/bin/bash

echo "La información sobre el procesador es la siguiente: "
cat /proc/cpuinfo

echo -e "\nLa cantidad de memoria libre en GB: "
free -g

echo -e "\nLa cantidad de disco libre en GB para la partición /: "
df -h /
