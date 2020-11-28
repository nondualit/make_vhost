#!/bin/bash
#set -x
################################################################################
# Author     : Anibal Enrique Ojeda Gonzalez
# name       : make_vhost.sh
# Version    : 1.0
# Date       : 29-11-2020
# Description: Add and remove VirtualHost to Apache Webserver on Ubuntu Server for AppLab Aruba to ise with AWS
################################################################################
#Placeholders
sites=/etc/apache2/sites-available


# Options
while [ -n "$1" ]; do # while loop starts

case "$1" in

-a)

echo -n "Domain Name: "
read -r var1


mkdir /var/www/$var1
chmod -R 775 /var/www/$var1
chown -R www-data:www-data /var/www/$var1

cat > $sites/$var1.conf << EOF
<VirtualHost *:80>
        ServerName  www.$var1
        ServerAlias $var1
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/$var1

        ErrorLog /var/log/apache2/error-$var1.log

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn
        
       <Directory "/var/www/$var1">
        Options All
        AllowOverride All
        Require all granted
       </Directory>


        CustomLog /var/log/apache2/access-$var1.log combined

</VirtualHost>
EOF


a2ensite $var1.conf
systemctl reload apache2


;;
-d)

echo -n "Domain Name: "
read -r var1

a2dissite $var1.conf
rm -rf /var/www/$var1
rm $sites/$var1.conf
systemctl reload apache2

;;
-h)
   echo "make_vhost.sh options
This script add or delete VirtualHosts to the Apache2 Webserver on Ubuntu server
-a to add a VirtualHost
-d to delete a VirtualHost
-v to view all VirtualHost";;

-v)
   apache2ctl -S | grep namevhost;;

 *) echo "Option $1 not recognized. Use -h for help" ;; # In case you typed a different option other than a,d,h,v

  esac

    shift

done
