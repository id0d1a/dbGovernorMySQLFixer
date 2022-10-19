#!/bin/bash
echo " "
echo " cPanel Fix MySQL Governor for Cloudlinux Utility "
echo " "
yum -y remove mysql-community-server mysql-community-client
yum -y remove MariaDB-server MariaDB-client
rm -rf /var/lib/mysql
rm -rf /var/mysql
rm -rf /etc/my.cnf*
rm -rf ~/.my.cnf
wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
chmod +x mariadb_repo_setup
sudo ./mariadb_repo_setup --mariadb-server-version=10.3.36 --os-type=rhel --os-version=8
sudo yum install perl-DBI libaio libsepol lsof boost-program-options
yum clean packages
yum -y install --repo="mariadb-main" MariaDB-server
yum -y install governor-mysql
/usr/share/lve/dbgovernor/mysqlgovernor.py --mysql-version=mariadb103
systemctl enable mariadb
systemctl start mysqld
systemctl start mariadb.service
systemctl start mysqld.service
/usr/share/lve/dbgovernor/mysqlgovernor.py --install
mysql -e "DELETE FROM mysql.user WHERE User=''; FLUSH PRIVILEGES;"
mysql -e 'drop database test'
echo " "
echo " Done! Now update MySQL Root Password through WHM "
echo " "
