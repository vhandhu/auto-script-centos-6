#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================

echo -e "\e[0m                                                            "
echo -e "\e[94m =========================================================="
echo -e "\e[94m           Original Script by JAJAN ONLINE                 "
echo -e "\e[94m                Whats App - 08994422537                    "
echo -e "\e[0m                                                            "
echo -e "\e[93m            [1]  Buat"
echo -e "\e[93m            [2]  Tambah"
echo -e "\e[93m            [3]  Ganti"
echo -e "\e[93m            [4]  Hapus"
echo -e "\e[93m            [5]  Expired"
echo -e "\e[93m            [6]  Listxp"
echo -e "\e[93m            [7]  Hapusxp"
echo -e "\e[93m            [8]  Member"
echo -e "\e[93m            [9]  Cek"
echo -e "\e[93m            [x]  Exit"
echo -e "\e[0m                                                            "       
read -p "          Select From Options [1-9 or x] :  " Menu
echo -e "\e[0m                                                            "
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
		ganti
		exit
		;;
		4)
		hapus
		exit
		;;
		5)
		expired
		exit
		;;
		6)
		listxp
		exit
		;;
		7)
		hapusxp
		exit
		;;
		8)
		member
		exit
		;;
		9)
		cek
		exit
		;;
		x)
		exit
		;;
	esac