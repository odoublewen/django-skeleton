#!/usr/bin/env bash
PROJECTNAME=mysite
APPNAME=$PROJECTNAME\_app

## SYSTEM
apt-get update
apt-get install -y postgresql python-psycopg2 python3-dev python3-pip python3-setuptools
apt-get install -y git postgresql-9.3 postgresql-server-dev-9.3
apt-get install -y emacs24-nox byobu htop
apt-get autoremove -y

## POSTGRES
echo '# "local" is for Unix domain socket connections only
local   all             all                                  trust
# IPv4 local connections:
host    all             all             0.0.0.0/0            trust
# IPv6 local connections:
host    all             all             ::/0                 trust' > /etc/postgresql/9.3/main/pg_hba.conf

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.3/main/postgresql.conf

/etc/init.d/postgresql restart
su - postgres -c 'createuser -s vagrant'
su - vagrant -c "createdb $PROJECTNAME"

pip3 install virtualenv

su - vagrant -c "virtualenv-3.5 /home/vagrant/venv
source /home/vagrant/venv/bin/activate
pip install -r /vagrant/provision/requirements.txt
"

#su - vagrant -c "source /home/vagrant/venv/bin/activate
#django-admin startproject $PROJECTNAME /vagrant
#cd /vagrant
#/vagrant/manage.py startapp $APPNAME
#"

echo "You've been provisioned"
