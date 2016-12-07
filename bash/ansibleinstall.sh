#!/bin/bash
add-apt-repository ppa:ansible/ansible -y
cp /vagrant/ansible-ubuntu-ansible-yakkety.list /etc/apt/sources.list.d/
apt-get update
apt-get install ansible python-pip dos2unix -y
apt-get upgrade -y
pip install  --upgrade pip
pip install  --upgrade pysphere
mkdir /ansible
chown ubuntu /ansible
hostname AnsibleControl
mkdir -p /ansible/inventories/production/group_vars
mkdir -p /ansible/inventories/production/host_vars
mkdir -p /ansible/inventories/staging/group_vars
mkdir -p /ansible/inventories/staging/host_vars
mkdir -p /ansible/inventories/qa/group_vars
mkdir -p /ansible/inventories/qa/host_vars
mkdir -p /ansible/inventories/dev/group_vars
mkdir -p /ansible/inventories/dev/host_vars
mkdir -p /ansible/library
mkdir -p /ansible/filter_plugins
mkdir -p /ansible/roles/common
chown -R ubuntu /ansible
