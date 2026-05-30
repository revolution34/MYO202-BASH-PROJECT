#!/bin/bash

# Devrim TEL
# 2420171049
# https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=NowfnZ4pNO
# https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=2NwcJGAOpm
# https://credsverse.com/credentials/47a12389-4198-49b0-8d38-655918060f52


dosya="report.log"


date +"%Y-%m-%dT%H:%M:%S%z" > $dosya

echo "--- DONANIM BİLGİLERİ ---" >> $dosya


echo "[İşlemci]" >> $dosya
wmic cpu get name 2>/dev/null >> $dosya

echo "[RAM]" >> $dosya
wmic os get TotalVisibleMemorySize,FreePhysicalMemory 2>/dev/null >> $dosya

echo "[Anakart]" >> $dosya
wmic baseboard get product,Manufacturer 2>/dev/null >> $dosya

echo "[Disk UUID]" >> $dosya
wmic diskdrive get serialnumber 2>/dev/null >> $dosya

echo "[MAC Adresi]" >> $dosya
getmac 2>/dev/null >> $dosya

echo "-------------------------" >> $dosya


echo "Lütfen parolayı giriniz (MYO+202):"
read -sp "Parola: " PAROLA
echo ""


echo "$PAROLA" | gpg --batch --yes --passphrase-fd 0 --cipher-algo AES256 -c $dosya


if [ -f "report.log.gpg" ]; then
    rm -f $dosya
    echo "İşlem başarılı, report.log.gpg oluşturuldu ve orijinal dosya silindi."
else
    echo "Hata: Şifreleme başarısız oldu!"
fi