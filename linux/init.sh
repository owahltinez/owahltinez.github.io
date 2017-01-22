#!/bin/sh

# VIM customizations
wget https://raw.githubusercontent.com/omtinez/initscripts/master/linux/basic.vim -O ~/.vimrc

# Bash profile (append to existing one)
sed -i '/### CUSTOM CONFIG STARTS HERE ###/Q' ~/.bashrc
curl -sS https://raw.githubusercontent.com/omtinez/initscripts/master/linux/profile.bash >> ~/.bashrc

# Create local bin dir and move some utils there
mkdir -p ~/bin
wget https://raw.githubusercontent.com/omtinez/initscripts/master/linux/switchip.sh -O ~/bin/switchip
wget https://raw.githubusercontent.com/omtinez/initscripts/master/linux/gitsetup.sh -O ~/bin/gitsetup
wget https://raw.githubusercontent.com/omtinez/AP-Hotspot/master/ap-hotspot -O ~/bin/ap-hotspot
chmod +x ~/bin/*
