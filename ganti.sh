#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================

echo ""
echo " ========================================================== "
echo "                     Ganti Password                         "
echo " ========================================================== "
echo ""

read -p "          Isikan username: " username

egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
	read -p "          Isikan password baru akun [$username]: " password
	read -p "          Konfirmasi password baru akun [$username]: " password1
	echo ""
	if [[ $password = $password1 ]]; then
		echo $username:$password | chpasswd
		echo "          Penggantian password akun [$username] Sukses"
		echo ""
	else
		echo "          Penggantian password akun [$username] Gagal"
		echo "          [Password baru] & [Konfirmasi Password Baru] tidak cocok, silahkan ulangi lagi!"
	fi
else
	echo "          Username [$username] belum terdaftar!"
	exit 1
fi


