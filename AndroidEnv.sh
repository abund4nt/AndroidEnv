#!/bin/bash

green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

echo -e "\t${green}     ┌─┐      ┌─┐${end}"
echo -e "\t${green}     │┼│      │┼│${end}"
echo -e "\t${green}     ├─┼─┬──┬─┼─┤${end}"
echo -e "\t${green}     │ └─┘  └─┘ │${end}"
echo -e "\t${green}     │          │${end}"
echo -e "\t${green}   ┌─┴──────────┴─┐${end}"
echo -e "\t${green}┌──┤              ├──┐${end}"
echo -e "\t${green}│  │   Android    │  │${end}"
echo -e "\t${green}│  │  Enviroment  │  │${end}"
echo -e "\t${green}│  │      By      │  │${end}"
echo -e "\t${green}│  │   abund4nt   │  │${end}"
echo -e "\t${green}└──┤              ├──┘${end}"
echo -e "\t${green}   │              │${end}"
echo -e "\t${green}   └┬─────┬┬─────┬┘${end}"
echo -e "\t${green}    │     ││     │${end}"
echo -e "\t${green}    └─────┴┴─────┘${end}"
echo -e "\n${green}[+]${end} ${gray}Extrayendo certificado...${end}\n"
curl localhost:8080/cert -o cert.der &>/dev/null
sleep 1
echo -e "\n${green}[+]${end} ${gray}Configurando certificado...${end}\n"
openssl x509 -inform der -in cert.der -out burp.pem &>/dev/null
sleep 0.5
openssl x509 -inform PEM -subject_hash_old -in burp.pem &>/dev/null
mv burp.pem 9a5ba575
adb shell << EOF
mount -o remount,rw /
exit
exit
EOF
adb push 9a5ba575 /system/etc/security/cacerts/ &>/dev/null
echo -e "\n${green}[+]${end} ${gray}Configurando proxy...${end}\n"
sleep 1
adb shell settings put global http_proxy $(ifconfig | grep eth0 -A 1 | grep inet | awk '{print $2}' | sed 's/ //g'):8080
echo -e "\n${green}[+]${end} ${gray}Configurando Frida...${end}\n"
sleep 0.5
wget https://github.com/frida/frida/releases/download/16.1.4/frida-server-16.1.4-android-x86_64.xz &>/dev/null
7z x frida-server-16.1.4-android-x86_64.xz &>/dev/null
mv frida-server-16.1.4-android-x86_64 frida-server
adb push frida-server /data/local/tmp &>/dev/null
adb shell "chmod 755 /data/local/tmp/frida-server"
adb shell "/data/local/tmp/frida-server &"
echo -e "\n${gray}Entorno configurado correctamente y servidor Frida desplegado. Ctrl+C para cancelar.${end}\n"
rm 9a5ba575
rm frida-server*
rm cert.der
exit 0

