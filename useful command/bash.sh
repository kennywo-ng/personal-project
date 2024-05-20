#Largest 30 file in current directory
du -ah . | sort -rh | head -n 30


#Storage Increase
#https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html
lsblk
fdisk -l

#--after increase volume in aws--
growpart /dev/nvme0n1 1
df -hT
#(if xfs type)
xfs_growfs -d /


##installing php80 + laravel
amazon-linux-extras install epel
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php80
yum install php80 php80-php-common php80-php-fpm sudo yum install php80-php-mysql php80-php-pecl-memcache php80-php-pecl-memcached php80-php-gd php80-php-mbstring php80-php-mcrypt php80-php-xml php80-php-pecl-apc php80-php-cli php80-php-pear php80-php-pdo php80-php-bcmath

##composer
curl -sS https://getcomposer.org/installer -o composer-setup.php
php80 composer-setup.php --install-dir=/usr/local/bin --filename=composer
ln -s /usr/local/bin/composer /usr/bin/composer
rm composer-setup.php
php80 /usr/local/bin/composer update

#clear tmp file
tmpwatch 3 /tmp 

#clear journal log
journalctl --vacuum-time=7d

#mysqlbinlog records
mysqlbinlog --start-datetime="2024-01-29 12:00:00" --stop-datetime="2024-01-29 13:00:00" /var/lib/mysql/binlog.000532 | grep -i 'TRUNCATE'

#yum
yum repolist | grep php
yum-config-manager
yum list installed php

yum-config-manager --disable remi-php80
yum-config-manager --enable remi-php81

#screen
#start
screen -S screen-name
screen -ls
#reattach
screen -r screen_name

#crontab ui
vim /usr/lib/node_modules/crontab-ui/crontabs/crontab.db