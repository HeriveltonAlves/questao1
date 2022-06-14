#/bin/bash
# Script para monitorar particoes

# Remove arquivo temporario
rm /tmp/usohd.txt

echo "Script de monitoramento de particoes e memoria!";

# Verifica o uso, ordena as particoes e salva em arquivo temp
df -h | grep /dev/sdb | sort > /root/hd/df.txt

# Verifica se as partições estão acima de 90 % e envia e-mail com o conteúdo
while read linha
do
PARTICAO=`echo $linha | awk '{ print $1 }'`
USO=`echo $linha | awk '{ print $5 }' | sed "s/%//g"` # Removendo o símbolo %
DIRETORIO=`echo $linha | awk '{ print $6 }'`
if [ "$USO" -gt "90" ]; then
echo "A partição "$PARTICAO", do diretório "$DIRETORIO" no Servidor "$HOSTNAME" esta com "$USO"% de uso! Favor verificar!!!" >> /tmp/usohd.txt
else touch /tmp/usohd.txt
fi
done < /root/hd/df.txt

# Envia alerta caso o arquivo nao esteja vazio
if [ ! -s /tmp/usohd.txt ] ;then
echo "Arquivo vazio"
echo "teste de particao"
# cat /tmp/usohd.txt | mail -s '[Utilizacao do HD]' herivelt@gmail.com
else
echo "Enviar alerta de particao acima do limite"
fi

# Verifica a memoria
MaxUseMem=90
totalMem=$(free | grep "Mem:" | awk '{print $2}')
free=$(free | grep "Mem:" | awk '{print $4}')
now=$(echo "scale=0;100-$free * 100 / $totalMem" | bc -l)
     if [ $now -gt $MaxUseMem ]
          then
          echo $' Alto consumo de memoria:' \ $now"%";
          echo $' Alto consumo de memoria:' \ $now"%" >> /tmp/usomemoria.txt;
     else
          echo $' Memoria ok:' \ $now"%";
          echo $' Memoria ok:' \ $now"%">> /tmp/usomemoria.txt;
     fi    
     df -h | grep /dev/sdb
