#!/bin/sh

# Hard code the username
USERNAME="omtinez"

# Use wget or curl, whichever is available (but prefer curl)
command -v wget && DL="wget --quiet -O -"
command -v curl && DL="curl -sSL"
command -v $DL || { echo >&2 "wget or curl not available"; exit 1; }

# VIM customizations
$DL https://gitlab.com/$USERNAME/initscripts/raw/master/linux/basic.vim > ~/.vimrc

# Bash profile (append to existing one)
sed -i '/### CUSTOM CONFIG STARTS HERE ###/Q' ~/.bashrc
$DL https://gitlab.com/$USERNAME/initscripts/raw/master/linux/profile.bash >> ~/.bashrc

# Global .gitignore
$DL https://gitlab.com/$USERNAME/initscripts/raw/master/git/.gitignore_global > ~/.gitignore_global

# Deploy SSH keys
mkdir -p ~/.ssh
$DL https://gitlab.com/$USERNAME.keys >> ~/.ssh/authorized_keys
echo "" >> ~/.ssh/authorized_keys

# Create local bin dir and move some utils there
mkdir -p ~/bin
$DL https://gitlab.com/$USERNAME/initscripts/raw/master/linux/switchip.sh > ~/bin/switchip
$DL https://raw.githubusercontent.com/omtinez/AP-Hotspot/master/ap-hotspot > ~/bin/ap-hotspot
$DL https://gitlab.com/$USERNAME/initscripts/raw/master/linux/letsencrypt.sh > ~/bin/letsencrypt.sh
chmod +x ~/bin/*

# Output success
echo "Profile set. Run the following command to update your current shell:"
echo "exec bash"
