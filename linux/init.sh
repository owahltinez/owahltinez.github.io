#!/bin/sh

# Hard code the username
USERNAME="omtinez"

# VIM customizations
wget --quiet https://gitlab.com/$USERNAME/initscripts/raw/master/linux/basic.vim -O ~/.vimrc

# Bash profile (append to existing one)
sed -i '/### CUSTOM CONFIG STARTS HERE ###/Q' ~/.bashrc
wget --quiet https://gitlab.com/$USERNAME/initscripts/raw/master/linux/profile.bash -O - >> ~/.bashrc

# Global .gitignore
wget --quiet https://gitlab.com/$USERNAME/initscripts/raw/master/git/.gitignore_global -O - > ~/.gitignore_global

# Deploy SSH keys
mkdir -p ~/.ssh
wget --quiet https://gitlab.com/$USERNAME.keys -O - >> ~/.ssh/authorized_keys
echo "" >> ~/.ssh/authorized_keys

# Create local bin dir and move some utils there
mkdir -p ~/bin
wget --quiet https://gitlab.com/$USERNAME/initscripts/raw/master/linux/switchip.sh -O ~/bin/switchip
wget --quiet https://raw.githubusercontent.com/omtinez/AP-Hotspot/master/ap-hotspot -O ~/bin/ap-hotspot
wget --quiet https://gitlab.com/$USERNAME/initscripts/raw/master/linux/letsencrypt.sh -O ~/bin/letsencrypt.sh
chmod +x ~/bin/*

# Output success
echo "Profile set. Run the following command to update your current shell:"
echo "exec bash"
