#!/bin/sh

# VIM customizations
wget --quiet https://raw.githubusercontent.com/omtinez/initscripts/master/linux/basic.vim -O ~/.vimrc

# Bash profile (append to existing one)
sed -i '/### CUSTOM CONFIG STARTS HERE ###/Q' ~/.bashrc
wget --quiet https://raw.githubusercontent.com/omtinez/initscripts/master/linux/profile.bash -O - >> ~/.bashrc

# Create local bin dir and move some utils there
mkdir -p ~/bin
wget --quiet https://raw.githubusercontent.com/omtinez/initscripts/master/linux/switchip.sh -O ~/bin/switchip
wget --quiet https://raw.githubusercontent.com/omtinez/AP-Hotspot/master/ap-hotspot -O ~/bin/ap-hotspot
chmod +x ~/bin/*

# Output success
echo "Profile set. Run the following command to update your current shell:"
echo "exec bash"
