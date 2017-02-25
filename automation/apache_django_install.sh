#!/bin/bash

echo "Installing Apache server..."
sudo yum -y install httpd

echo "Starting HTTP service..."
sudo systemctl enable httpd.service

echo "Starting Apache Server..."
sudo systemctl start httpd.service

echo "Beginning Django Web Framework install..."
echo "Current version of Python:"

python --version

echo "Installing virtualenv to give Django it's own version of Python..."

sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
sudo yum -y install python-pip

sudo pip install virtualenv
cd /opt

# we're going to install our django libs in /opt, often used for optional or add-on

# we want to make this env accessible to the GCloud user because we don't want to have to run it as root

sudo mkdir django
sudo chown -R ashand01 django
sleep 5
cd django
sudo virtualenv django-env

echo "Activating virtualenv..."

source /opt/django/django-env/bin/activate

echo "To switch out of virtualenv, type deactivate."

echo "Now using this version of Python:"

which python
sudo chown -R ashand01 /opt/django

echo "Installing Django"

pip install Django

echo "Django admin is version:"

django-admin --version
django-admin startproject project1

echo "Adjusting settings.py allowed_hosts..."
sed -i 's,ALLOWED_HOSTS = \[\],ALLOWED_HOSTS = \[\'*\'\],g' /opt/django/project1/project1/settings.py

echo "This is the new django project directory..."

sudo yum -y install tree
tree project1

echo "Go to https://docs.djangoproject.com/en/1.10/intro/tutorial01/ to begin first Django Project!"

echo "Starting Django server..."

sudo chmod 644 /opt/django/project1/manage.py
sudo setenforce 0

source /opt/django/django-env/bin/activate

cd /opt/django/project1

#echo "Migrating database files..."

#python manage.py migrate

echo "Django is now accessible from the web at [server IP]:8000..."
