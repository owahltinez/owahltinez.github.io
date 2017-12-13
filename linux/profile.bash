### CUSTOM CONFIG STARTS HERE ###

# Aliases
alias ll='ls -halF'
alias cd..='cd ..'
alias apti='sudo -E apt-get -yq --no-install-suggests --no-install-recommends install'
alias sudosu='sudo bash --init-file ~/.bashrc'
alias sudovi='sudo vi -u ~/.vimrc'

# Define functions
update() {
    sudo apt-get update && \
    sudo DEBIAN_FRONTEND=noninteractive \
        apt-get -yq --no-install-suggests --no-install-recommends \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" dist-upgrade && \
    sudo apt-get -yq autoremove && \
    wget -q -O - https://linux.omtinez.com | sh
}
lsipv6() {
    ip -6 addr | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^::1 | grep -v ^fe80
}
ssh_key_gen() {
    mkdir -p ~/.ssh && ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
}
ssh_key_push() {
    cat ~/.ssh/id_rsa.pub | ssh $@ "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
}
ssh_key_pull() {
    scp $@:~/.ssh/id_rsa.pub /tmp/$@.pub
    cat /tmp/$@.pub >> ~/.ssh/authorized_keys
    rm /tmp/$@.pub
}
ssh_pwd_disable() {
    # https://gist.github.com/parente/0227cfbbd8de1ce8ad05
    sudo sh -c '\
        grep -q "ChallengeResponseAuthentication" /etc/ssh/sshd_config && \
        sed -i "/^[^#]*ChallengeResponseAuthentication[[:space:]]yes.*/c\ChallengeResponseAuthentication no" /etc/ssh/sshd_config || echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config; \
        grep -q "^[^#]*PasswordAuthentication" /etc/ssh/sshd_config && \
        sed -i "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config; \
        service ssh restart'
}
install_node() {
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && apti nodejs
}
install_chrome() {
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -  && \
        echo "deb [arch=$(arch)] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list && \
        update && apti google-chrome-stable
}
install_nginx() {
    apti software-properties-common && sudo add-apt-repository ppa:nginx/stable && update && apti nginx
}
install_acme() {
    sudo wget -q https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh -O /usr/local/bin/acme && sudo chmod +x /usr/local/bin/acme
}
install_docker() {
    wget -q -O - https://get.docker.com | sudo sh && \
    sudo wget -q https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    (sudo groupadd docker || true) && sudo usermod -aG docker $USER
}
git_setup() {
    git config --global credential.helper 'cache --timeout=999999999'
    git config --global user.name "omtinez"
    git config --global user.email "omtinez@gmail.com"
    git config --global push.default simple
    git config --global core.excludesfile ~/.gitignore_global
}

# Export defined functions
export -f update
export -f lsipv6
export -f ssh_key_gen
export -f ssh_key_push
export -f ssh_key_pull
export -f ssh_pwd_disable
export -f install_node
export -f install_chrome
export -f install_acme
export -f install_docker
export -f git_setup

# Handy exports
export GH='https://github.com/omtinez'
export GL='https://gitlab.com/omtinez'
export GT='https://github.gatech.edu/omartinez8'

# Paths
export PATH=$PATH:~/bin
