#!/bin/bash

#Colores
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

function ctrl_c(){
    echo -e "\n\n${green}[!] Saliendo...${end}"
    tput cnorm; exit 1
}

trap ctrl_c INT

# Comprobamos si el usuario es root

if [ $(id -u) -ne 0 ]; then
    echo -e "\n${red}[!] Debes ejecutar el script como root...${end}\n"
    exit 1
fi

echo -e "\n${green}[+]${end} ${gray}Instalando requerimientos necesarios...${end}\n"
sleep 1
echo -e "\n${green}[+]${end} ${gray}Instalando Virtualbox...${end}\n"
apt install virtualbox -y &>/dev/null
echo -e "\n${green}[+]${end} ${gray}Instalando adb...${end}\n"
apt install adb -y &>/dev/null
echo -e "\n${green}[+]${end} ${gray}Instalando Genymotion...${end}\n"
wget https://dl.genymotion.com/releases/genymotion-3.5.0/genymotion-3.5.0-linux_x64.bin &>/dev/null
sleep 0.5
chmod +x genymotion-3.5.0-linux_x64.bin
sleep 0.5
./genymotion-3.5.0-linux_x64.bin -y &>/dev/null
echo -e "\n${green}[+]${end} ${gray}Instalando Openssl...${end}\n"
apt install openssl -y &>/dev/null
echo -e "\n${green}[+]${end} ${gray}Instalando Frida...${end}\n"
pip install frida-tools &>/dev/null
sleep 1
echo -e "\n\n${green}[!]${end} ${gray}Instalacion completada. ./AndroidEnv.sh para montar entorno.${end}"
echo -e "${yellow}Recuerda tener Burpsuite abierto y Genymotion con un movil corriendo, usa Google Pixel 3 XL.${end}"
rm genymotion-3.5.0-linux_x64.bin
