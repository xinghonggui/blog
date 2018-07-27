#!/bin/bash
user=www  
group=www  
#create group if not exists  
egrep "^$group" /etc/group >& /dev/null  
if [ $? -ne 0 ]; then
    groupadd $group  
fi  
  
#create user if not exists
egrep "^$user" /etc/passwd >& /dev/null
if [ $? -ne 0 ];then
	useradd -g $group -M $user
fi

phpPath=/usr/local/php7
nginxPath=/usr/local/nginx

tar zxvf nginx-1.10.3.tar.gz
cd nginx-1.10.3
./configure --prefix=${nginxPath} --pid-path=${nginxPath}/run/nginx.pid --conf-path=${nginxPath}/conf/nginx.conf --with-http_ssl_module --user=www --group=www --with-pcre
make && make install
cd ..

yum -y install libxml2 libxml2-devel openssl openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libmcrypt-devel openldap openldap-devel

cp -frp /usr/lib64/libldap* /usr/lib/

tar -zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure
make && make install 

cd ..
tar -zxvf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9
./configure && make && make install

cd ..
tar -zxvf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8
LD_LIBRARY_PATH=/usr/local/lib ./configure
make && make install

cp -frp /usr/lib64/libldap* /usr/lib/

cd ..
tar -zxvf php-7.1.9.tar.gz
cd php-7.1.9

./configure --prefix=${phpPath} \
--with-config-file-path=${phpPath}/etc \
--with-config-file-scan-dir=${phpPath}/etc/php.d \
--with-mcrypt=/usr/local/lib \
--enable-mysqlnd \
--with-mysqli \
--with-pdo-mysql \
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www \
--with-gd \
--with-iconv \
--with-zlib \
--enable-xml \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--enable-mbregex \
--enable-mbstring \
--enable-gd-native-ttf \
--with-openssl \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--without-pear \
--with-gettext \
--enable-session \
--with-curl \
--with-jpeg-dir \
--with-freetype-dir \
--enable-opcache

make clean && make && make install

cd ..
tar -zxvf mongodb-1.2.10.tgz
cd mongodb-1.2.10
/usr/local/php7/bin/phpize
./configure --with-php-config=${phpPath}/bin/php-config
make && make install

cd ..
tar -zxvf redis-3.0.0.tgz
cd redis-3.0.0
/usr/local/php7/bin/phpize
./configure --with-php-config=${phpPath}/bin/php-config
make && make install

cd ..

if [ ! -d "${phpPath}/var/log/www" ]; then 
	mkdir -p ${phpPath}/var/log/www
fi
chown -R www:www ${nginxPath}/logs/

if [ ! -d "/data/wwwroot" ]; then 
	mkdir -p /data/wwwroot
fi
chown -R www:www /data/wwwroot

mv ${nginxPath}/conf/nginx.conf ${nginxPath}/conf/nginx.conf.bak

if [ ! -d "${nginxPath}/conf/vhosts" ]; then 
	mkdir -p ${nginxPath}/conf/vhosts
fi

cp -f php_etc/php.ini ${phpPath}/etc/
cp -f php_etc/php-fpm.conf ${phpPath}/etc/
cp -f php_etc/www.conf ${phpPath}/etc/php-fpm.d/
cp -f php_etc/php-fpm /etc/init.d/
chmod 775 /etc/init.d/php-fpm

cp -f nginx_etc/nginx.conf ${nginxPath}/conf/
cp -f nginx_etc/default.conf ${nginxPath}/conf/vhosts/
cp -fR nginx_etc/ssl ${nginxPath}/conf/

echo "请修改 ${nginxPath}/conf/vhosts/default.conf "
echo "可能需要修改:"
echo "${phpPath}/etc/php.ini "
echo "${phpPath}/etc/php-fpm.d/www.conf "

echo "启动命令:"
echo "/etc/init.d/php-fpm start | restart "
echo "/usr/local/nginx/sbin/nginx "
