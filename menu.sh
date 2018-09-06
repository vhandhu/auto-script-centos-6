#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================

echo -e "\e[0m                                                   "
echo -e "\e[94m =========================================================="
echo -e "\e[94m           AutoScriptVPS by JAJAN ONLINE                   "
echo -e "\e[94m              Whats App - 08994422537                      "
echo -e "\e[0m                                                   "
echo -e "\e[93m            [1]  Buat"
echo -e "\e[93m            [2]  Tambah"
echo -e "\e[93m            [3]  Hapus"
echo -e "\e[93m            [4]  Cek"
echo -e "\e[93m            [5]  Member"
echo -e "\e[93m            [6]  Expired"
echo -e "\e[93m            [x]  Exit"
echo -e "\e[0m                                                   "
read -p "                 Select From Options [1-6 or x] :  " Menu
echo -e "\e[0m                                                   "
echo -e "\e[94m ==========================================================\e[0m"

case $Menu in
		1)
		buat
		exit
		;;
		2)
		tambah
		exit
		;;
		3)
		hapus
		exit
		;;
		4)
		cek
		exit
		;;
		5)
		member
		exit
		;;
		6)
		expired
		exit
		;;
		7)
		reboot
		exit
		;;
		x)
		exit
		;;
	esac