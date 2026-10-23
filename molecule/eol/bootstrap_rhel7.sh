#!/bin/bash

sudo yum clean all
sudo yum makecache
sudo yum repolist
sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel wget make

cd /usr/src

sudo wget https://www.python.org/ftp/python/3.9.23/Python-3.9.23.tgz
sudo tar xzf Python-3.9.23.tgz

cd Python-3.9.23

sudo ./configure --enable-optimizations
sudo make altinstall
sudo ln -sf /usr/local/bin/python3.9 /usr/bin/python3
sudo ln -sf /usr/local/bin/pip3.9 /usr/bin/pip3

sudo yum install -y python-dnf
