#!/bin/bash
clear
sitedwn=bitbucket.org/nandoslayer/dtunnelinstall/downloads
IP=$(wget -qO- ipv4.icanhazip.com)
[[ $(crontab -l | grep -c "ecosystem.config.js") != '0' ]] && crontab -l | grep -v 'ecosystem.config.js' | crontab -
function os_system {
system=$(cat -n /etc/issue | grep 1 | cut -d ' ' -f6,7,8 | sed 's/1//' | sed 's/	  //')
distro=$(echo "$system" | awk '{print $1}')
case $distro in
Debian) vercion=$(echo $system | awk '{print $3}' | cut -d '.' -f1) ;;
Ubuntu) vercion=$(echo $system | awk '{print $2}' | cut -d '.' -f1,2) ;;
esac
}
function install_start {
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install unzip -y > /dev/null 2>&1
sudo apt-get install npm -y > /dev/null 2>&1
npm install pm2 -g > /dev/null 2>&1
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=21
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nodejs -y > /dev/null 2>&1
[[ ! -d /etc/paineldtunnel ]] && mkdir /etc/paineldtunnel
cd /etc/paineldtunnel || exit
wget $sitedwn/paineldtunnel.zip > /dev/null 2>&1
unzip -o paineldtunnel.zip > /dev/null 2>&1
rm paineldtunnel.zip > /dev/null 2>&1
cd || exit
chmod 777 -R /etc/paineldtunnel > /dev/null 2>&1
secret1=$(node -e "console.log(require('crypto').randomBytes(256).toString('base64'));")
secret2=$(node -e "console.log(require('crypto').randomBytes(256).toString('base64'));")
secret3=$(node -e "console.log(require('crypto').randomBytes(256).toString('base64'));")
sed -i "s;secret1;$secret1;g" /etc/paineldtunnel/.env > /dev/null 2>&1
sed -i "s;secret2;$secret2;g" /etc/paineldtunnel/.env > /dev/null 2>&1
sed -i "s;secret3;$secret3;g" /etc/paineldtunnel/.env > /dev/null 2>&1
[[ $(crontab -l | grep -c "ecosystem.config.js") = '0' ]] && (
crontab -l 2>/dev/null
echo "@reboot cd /etc/paineldtunnel || exit && pm2 start ecosystem.config.js && cd || exit"
) | crontab -
service cron restart > /dev/null 2>&1
cd /etc/paineldtunnel || exit
npm install
npx prisma generate
npx prisma migrate deploy
cd || exit
cd /etc/paineldtunnel || exit && pm2 start ecosystem.config.js && cd || exit
clear
echo -e "\033[1;32mPAINEL INSTALADO COM SUCESSO!\033[0m"
echo ""
echo -e "\033[1;36m SEU PAINEL:\033[1;37m http://$IP\033[0m"
echo ""
echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mao prompt! \033[0m"; read
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1
rm install* > /dev/null 2>&1
clear
}
os_system
[[ "$(whoami)" != "root" ]] && {
clear
echo -e "\n\033[1;33m[\033[1;31m ERRO\033[1;33m] \033[1;37m- \033[1;33mVOCÊ PRECISA EXECUTAR COMO ROOT! \033[0m"
echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mao prompt! \033[0m"; read
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1
rm install* > /dev/null 2>&1
clear
}
if [[ "$distro" != "Ubuntu" ]]; then
clear
echo -e "\n\033[1;33m[\033[1;31m ERRO\033[1;33m] \033[1;37m- \033[1;33mSISTEMA NÃO COMPATIVEL! FAVOR INSTALAR O UBUNTU 20.04 OU 22.04! \033[0m"
echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mao prompt! \033[0m"; read
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1
rm install* > /dev/null 2>&1
clear
else
if [[ "$vercion" == "20.04" ]]; then
install_start
elif [[ "$vercion" == "22.04" ]]; then
install_start
else
clear
echo -e "\n\033[1;33m[\033[1;31m ERRO\033[1;33m] \033[1;37m- \033[1;33mSISTEMA NÃO COMPATIVEL! FAVOR INSTALAR O UBUNTU 20.04 OU 22.04! \033[0m"
echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mao prompt! \033[0m"; read
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1
rm install* > /dev/null 2>&1
clear
fi
fi 
