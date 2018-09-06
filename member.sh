#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================
if [ -f /etc/debian_version ]; then
	UIDN=1000
elif [ -f /etc/redhat-release ]; then
	UIDN=500
else
	UIDN=500
fi

echo -e "\e[0m                                                   "
echo -e "\e[94m =========================================================="
echo -e "\e[0m                                                   "
echo -e "\e[93m           Username          Expired           \e[0m"
echo " "
while read expired
do
        Spacer="    "
        AKUN="$(echo $expired | cut -d: -f1)"
        ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
        exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
        if [[ $ID -ge $UIDN ]]; then
        printf "%-26s : %5s\n" "           $AKUN"    "$exp"
        fi
done < /etc/passwd

No_Users="$(awk -F: '$3 >= '$UIDN' && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo -e "\e[0m                                                   "
echo -e "\e[94m ==========================================================\e[0m"
echo -e "\e[0m                                                   "
echo -e "\e[93m              Number of Users: "$No_Users
echo -e "\e[0m                                                   "
echo -e "\e[94m ==========================================================\e[0m"
echo -e "\e[94m                    Original Script by                      "
echo -e "\e[94m            Jajan Online - Whats App 08994422537            "
echo -e "\e[94m ========================================================== "
