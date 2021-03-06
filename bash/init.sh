#!/bin/sh

# Hardcode the Github username
USERNAME="owahltinez"
BASE_URL="https://$USERNAME.github.io"

# Use wget or curl, whichever is available (but prefer curl)
if command -v curl > /dev/null 2>&1; then DL='curl -sSL' ; else DL='wget -O -' ; fi
command -v $DL > /dev/null 2>&1 || { echo >&2 "wget or curl not available"; exit 1; }

# VIM customizations
mkdir -p ~/.vim/autoload ~/.vim/bundle
$DL https://tpo.pe/pathogen.vim > ~/.vim/autoload/pathogen.vim
$DL $BASE_URL/basic.vim > ~/.vimrc

# Download bash profile into separate file
$DL $BASE_URL/bash/profile.bash > ~/.profile.bash

# Bash RC is different in OSX
BASH_RC="$HOME/.bashrc"
if [ "$(uname -s)" = "Darwin" ]; then
    BASH_RC=".bash_profile"
fi

# Bash profile (add ref to existing one)
PROFILE_REF='source ~/.profile.bash'
if ! grep -q "$PROFILE_REF" ~/.bashrc; then 
    cp $BASH_RC ${BASH_RC}-$(date --iso-8601)-$(date +%s)
    echo $PROFILE_REF >> $BASH_RC
fi

# Global .gitignore
$DL $BASE_URL/git/.gitignore_global > ~/.gitignore_global

# Deploy SSH keys
mkdir -p ~/.ssh
$DL https://github.com/$USERNAME.keys >> ~/.ssh/authorized_keys
echo "" >> ~/.ssh/authorized_keys

# Create local bin dir and move some utils there
mkdir -p ~/bin
$DL $BASE_URL/bash/apti.sh > ~/bin/apti
$DL $BASE_URL/bash/dl.sh > ~/bin/dl
$DL $BASE_URL/bash/fakesudo.sh > ~/bin/fakesudo
$DL $BASE_URL/bash/pipi.sh > ~/bin/pipi
$DL $BASE_URL/bash/update.sh > ~/bin/update
chmod +x ~/bin/*

# Output success
echo "Profile set. Run the following command to update your current shell:"
echo "exec bash"
