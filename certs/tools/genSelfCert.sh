#!/bin/bash
######################################################################
### Author: Arthur
######################################################################
#set -x

if [[ $# -lt 1 ]]; then
  echo "$0 <short server name> <Altertive Subject Name 1> ..."
  exit $LINENO
fi 

domainName=goweekend.ca
shortServerName=$1
numberOfAlias=$#
allAlias=$*
echo $allAlias
templateFile=http-cert.cfg
certConfigFile=${shortServerName}/${shortServerName}-certs.cfg

mkdir -p $shortServerName
cp $templateFile $certConfigFile

echo "
1,$ s/__SERVERNAME__/${shortServerName}/g
.
wq
" | ed $certConfigFile

echo "[alt_names]" >>  $certConfigFile
sanString="SAN:"
i=1
for j in $allAlias
do
	echo "DNS.$i = $j.${domainName}" >> $certConfigFile
	if [ $i -gt 1 ]; then
		sanString="${sanString}&DNS=$j.${domainName}"
	else
		sanString="${sanString}DNS=$j.${domainName}"
	fi
	i=`expr $i + 1`
done

encryptedKeyDB=${shortServerName}/${shortServerName}.key.encrypted
certFileName=${shortServerName}/${shortServerName}.crt
csrFile=${shortServerName}/${shortServerName}.csr
decryptedKeyDB=${shortServerName}/${shortServerName}.key

### Self-Signed Cert
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout $encryptedKeyDB -out $certFileName -config $certConfigFile -extensions 'v3_req'

# Decrypted KeyDB
openssl rsa -in $encryptedKeyDB -out $decryptedKeyDB
