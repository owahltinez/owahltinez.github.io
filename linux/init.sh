#!/bin/sh

# Hardcode the Gitlab username
USERNAME="omtinez"

# Use wget or curl, whichever is available (but prefer curl)
if command -v curl > /dev/null 2>&1; then DL='curl -sSL' ; else DL='wget -O -' ; fi
command -v $DL > /dev/null 2>&1 || { echo >&2 "wget or curl not available"; exit 1; }

# VIM customizations
$DL https://gitlab.com/$USERNAME/initscripts/raw/master/linux/basic.vim > ~/.vimrc

# Download bash profile into separate file
$DL https://gitlab.com/$USERNAME/initscripts/raw/master/linux/profile.bash >> ~/.profile.bash

# Bash RC is different in OSX
BASH_RC="$HOME/.bashrc"
if [[ "$OSTYPE" == "darwin"* ]]; then
    BASH_RC=".bash_profile"
fi

# Bash profile (add ref to existing one)
PROFILE_REF='source ~/.profile.bash'
if ! grep -q "$PROFILE_REF" ~/.bashrc; then 
    cp $HOME/.bashrc $HOME/.bashrc-$(date --iso-8601)-$(date +%s)
    echo $PROFILE_REF >> ~/.bashrc
fi

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
$DL https://gitlab.com/$USERNAME/initscripts/raw/master/linux/letsencrypt.sh > ~/bin/letsencrypt
$DL https://gitlab.com/$USERNAME/initscripts/raw/master/linux/pipi.sh > ~/bin/pipi
chmod +x ~/bin/*

# Output success
echo "Profile set. Run the following command to update your current shell:"
echo "exec bash"
