### CUSTOM CONFIG STARTS HERE ###

# Aliases
alias ll='ls -halF'
alias cd..='cd ..'
alias apti='sudo -E apt-get -yq --no-install-suggests --no-install-recommends install'
alias update='sudo apt-get update && sudo apt-get -yq --no-install-suggests --no-install-recommends dist-upgrade && sudo apt-get -yq autoremove'
alias sudosu='sudo bash --init-file ~/.bashrc'
alias sudovi='sudo vi -u ~/.vimrc'

# Define functions
lsipv6() {
    ip -6 addr | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^::1 | grep -v ^fe80
}
sshkeygen() {
    mkdir -p ~/.ssh && ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
}
sshkeypush() {
    cat ~/.ssh/id_rsa.pub | ssh $@ "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
}
sshkeypull() {
    scp $@:~/.ssh/id_rsa.pub /tmp/$@.pub
    cat /tmp/$@.pub >> ~/.ssh/authorized_keys
    rm /tmp/$@.pub
}
install_node() {
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && apti nodejs
}
install_chrome() {
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -  && \
        echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list && \
        update && apti google-chrome-stable
}
install_nginx() {
    sudo add-apt-repository ppa:nginx/stable && update && apti nginx
}
gitsetup() {
    git config --global credential.helper 'cache --timeout=999999999'
    git config --global user.name "omtinez"
    git config --global user.email "omtinez@gmail.com"
    git config --global push.default simple
    git config --global core.excludesfile ~/.gitignore_global
}

# Export defined functions
export -f lsipv6
export -f sshkeygen
export -f sshkeypush
export -f sshkeypull
export -f install_node
export -f install_chrome
export -f gitsetup

# Handy exports
export GH='https://github.com/omtinez'
export GL='https://gitlab.com/omtinez'
export GT='https://github.gatech.edu/omartinez8'

# Paths
export PATH=$PATH:~/bin
