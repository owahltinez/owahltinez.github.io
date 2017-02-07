### CUSTOM CONFIG STARTS HERE ###

# Aliases
alias ll='ls -halF'
alias cd..='cd ..'
alias apti='sudo -E apt-get -yq --no-install-suggests --no-install-recommends --force-yes install'
alias update='sudo apt-get update && sudo apt-get -yq --no-install-suggests --no-install-recommends --force-yes dist-upgrade && sudo apt-get -yq autoremove'
alias sudosu='sudo bash --init-file ~/.bashrc'
alias sudovi='sudo vi -u ~/.vimrc'

# Define functions
lsipv6() {
    ip -6 addr | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^::1 | grep -v ^fe80
}
addsshkey() {
    cat ~/.ssh/id_rsa.pub | ssh $@ "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
}
gitsetup() {
    git config --global credential.helper 'cache --timeout=999999999'
    git config --global user.name "omtinez"
    git config --global user.email "omtinez@gmail.com"
    git config --global push.default simple
}

# Export defined functions
export -f lsipv6
export -f addsshkey
export -f gitsetup

# Handy exports
export GH='https://github.com/omtinez'
export GL='https://gitlab.com/omtinez'
export GT='https://github.gatech.edu/omartinez8'

# Paths
export PATH=$PATH:~/bin
