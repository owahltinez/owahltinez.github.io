#!/bin/sh

# VIM customizations
wget https://raw.githubusercontent.com/omtinez/initscripts/master/linux/basic.vim -O ~/.vimrc

# Bash profile
wget https://raw.githubusercontent.com/omtinez/initscripts/master/linux/profile.bash -O ~/.bashrc

# Create local bin dir and move some utils there
mkdir -p ~/bin
wget https://raw.githubusercontent.com/omtinez/initscripts/master/linux/gitsetup.sh -O ~/bin/gitsetup
chmod +x ~/bin/*
