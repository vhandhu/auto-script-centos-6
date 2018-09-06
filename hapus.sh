#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================

echo " ========================================================== "
echo "                        Hapus Akun                        "
echo " ========================================================== "
echo ""
read -p "         Hapus user : " username

egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
        userdel -f $username
        echo -e "User $username telah dihapus."
else
        echo -e "GAGAL: User $username tidak ada."
fi
