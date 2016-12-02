#!/bin/bash
mkdir /git
chown ubuntu /git
git config --global user.email "nobody@example.com"
git config --global user.name "Somebody Nobody"
git clone https://github.com/stomplee/vagrant /git/vagrant
git clone https://github.com/stomplee/scripts /git/scripts
git clone https://github.com/stomplee/config /git/config
