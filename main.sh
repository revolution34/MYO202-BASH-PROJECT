#!/bin/bash

# Devrim TEL
# 2420171049
# https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=NowfnZ4pNO
# https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=2NwcJGAOpm
# https://credsverse.com/credentials/47a12389-4198-49b0-8d38-655918060f52


LOG_FILE="report.log"


echo "=== MYO202 BASH PROJESI DONANIM RAPORU ===" > $LOG_FILE
echo "Rapor Tarihi: $(date '+%Y-%m-%d %H:%M:%S')" >> $LOG_FILE


echo -e "\n[1] ANAKART UUID BILGISI" >> $LOG_FILE
wmic path win32_computersystemproduct get uuid 2>/dev/null | grep -v "UUID" | tr -d '\r\n ' >> $LOG_FILE
echo "" >> $LOG_FILE


echo -e "\n[2] DISK BILGILERI (SSD/HDD)" >> $LOG_FILE
wmic diskdrive get model,size 2>/dev/null | grep -v -e '^[[:space:]]*$' >> $LOG_FILE


echo -e "\n[3] DIGER DONANIM VE KIMLIK BILGILERI" >> $LOG_FILE
echo "CPU: $(wmic cpu get name | grep -v Name | tr -d '\r\n')" >> $LOG_FILE
echo "RAM (Byte): $(wmic os get TotalVisibleMemorySize | grep -v TotalVisibleMemorySize | tr -d '\r\n ')" >> $LOG_FILE

echo "MAC Adresleri (getmac):" >> $LOG_FILE
getmac 2>/dev/null | grep -v -e '^[[:space:]]*$' >> $LOG_FILE


echo "--------------------------------------------------"
echo "Donanim bilgileri toplandi. Sifreleme adimina geciliyor."
echo "Hocanin belirledigi sifreyi (MYO+202) girip Enter'a basin."
echo "--------------------------------------------------"


read -s -p "Kripto Sifresini Giriniz: " PAROLA
echo ""


echo "$PAROLA" | gpg --batch --yes --passphrase-fd 0 -c --cipher-algo AES256 -o report.log.gpg $LOG_FILE

if [ $? -eq 0 ]; then
    echo -e "\n[BAŞARILI] Raporlandırma ve Kriptolama tamamlandi!"
    echo "report.log.gpg dosyasi güncellendi."
    # Orijinal report.log dosyasının otomatik silinmesi
    rm -f $LOG_FILE
else
    echo -e "\n[HATA] Sifreleme sirasinda bir sorun olustu."
fi