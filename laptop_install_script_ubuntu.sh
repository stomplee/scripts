#!/bin/bash
apt-get update && apt-get upgrade -y
apt-get install jq wget curl terminator vim git youtube-dl shutter keepassx vim vlc audacious audacity python python-pip -y

# sublime 3 stuff
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt-get update
apt-get install sublime-text -y

# aws cli
pip install --upgrade pip
pip install --upgrade awscli

# fix nvidia
apt-get purge nvidia* -y
apt-get install nvidia-331 -y
