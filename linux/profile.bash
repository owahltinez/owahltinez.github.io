### CUSTOM CONFIG STARTS HERE ###

# Aliases
alias ll='ls -halF'
alias cd..='cd ..'
alias apti='sudo apt-get -yq --no-install-suggests --no-install-recommends install'
alias sudosu='sudo bash --init-file ~/.bashrc'
alias sudovi='sudo vi -u ~/.vimrc'

# Fake sudo for devices that do not have it
if [[ $(id -u) = 0 ]] ; then
    alias sudo=''
else
    alias sudo='sudo '
fi

# Binary used for downloads
if command -v curl > /dev/null 2>&1; then alias dl='curl -sSL' ; else alias dl='wget -O -' ; fi

# Define functions
function update() {
    DEBIAN_FRONTEND=noninteractive \
        sudo apt-get update && \
        sudo apt-get -yq --no-install-suggests --no-install-recommends \
            -o Dpkg::Options::="--force-confdef" \
            -o Dpkg::Options::="--force-confold" dist-upgrade && \
        sudo apt-get -yq autoremove && \
        dl https://gitlab.com/omtinez/initscripts/raw/master/linux/init.sh | sh
}
export -f update

function ssh_key_gen() {
    mkdir -p ~/.ssh && ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
}
export -f ssh_key_gen

function ssh_key_push() {
    ssh-copy-id -i ~/.ssh/id_rsa $@
}
export -f ssh_key_push

function ssh_key_pull() {
    scp $@:~/.ssh/id_rsa.pub /tmp/$@.pub
    cat /tmp/$@.pub >> ~/.ssh/authorized_keys
    rm /tmp/$@.pub
}
export -f ssh_key_pull

function ssh_pwd_disable() {
    # https://gist.github.com/parente/0227cfbbd8de1ce8ad05
    sudo sh -c '\
        grep -q "ChallengeResponseAuthentication" /etc/ssh/sshd_config && \
        sed -i "/^[^#]*ChallengeResponseAuthentication[[:space:]]yes.*/c\ChallengeResponseAuthentication no" /etc/ssh/sshd_config || echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config; \
        grep -q "^[^#]*PasswordAuthentication" /etc/ssh/sshd_config && \
        sed -i "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config; \
        service ssh restart'
}
export -f ssh_pwd_disable

function ssh_add_all() {
    mkdir -p ~/.ssh
    grep -slR "PRIVATE" ~/.ssh/ | xargs ssh-add
}
export -f ssh_add_all

function ssh_start_agent() {
    mkdir -p ~/.ssh
    ssh-add -l &>/dev/null
    if [ "$?" == 2 ]; then
        test -r ~/.ssh/agent && \
            eval "$(<~/.ssh/agent)" >/dev/null
    
        ssh-add -l &>/dev/null
        if [ "$?" == 2 ]; then
            (umask 066; ssh-agent > ~/.ssh/agent)
            eval "$(<~/.ssh/agent)" >/dev/null
            ssh_add_all
        fi
    fi
}
export -f ssh_start_agent

function ssh_screen() {
    ssh $@ -t screen -DR
}
export -f ssh_screen

function ssh_tunnel() {
    ssh -D 1080 -q -C -N $@
}
export -f ssh_tunnel

function install_node() {
    sudo curl -sL https://deb.nodesource.com/setup_8.x | bash - && apti nodejs
}
export -f install_node

function install_chrome() {
    dl https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -  && \
        echo "deb [arch=$(dpkg --print-architecture)] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list && \
        update && apti google-chrome-stable
}
export -f install_chrome

function install_nginx() {
    sudo apti software-properties-common && \
        sudo add-apt-repository ppa:nginx/stable && \
        update && apti nginx
}
export -f install_nginx

function install_acme() {
    dl https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh | sudo tee /usr/local/bin/acme > /dev/null && sudo chmod +x /usr/local/bin/acme
}
export -f install_acme

install_docker() {
    dl https://get.docker.com | sudo sh && \
    dl https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null && \
    sudo chmod +x /usr/local/bin/docker-compose && \
    (sudo groupadd docker || true) && usermod -aG docker $USER
}
export -f install_docker

function install_dotnet() {
    dl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
    echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/microsoft-ubuntu-bionic-prod bionic main" | sudo tee -a /etc/apt/sources.list.d/microsoft.list && \
    update && apti dotnet-sdk-2.1
}
export -f install_dotnet

function install_vscode() {
    dl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
    echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/vscode stable main" | sudo tee -a /etc/apt/sources.list.d/microsoft.list && \
    update && apti libxss1 libasound2 code
}
export -f install_vscode

function git_setup() {
    git config --global credential.helper 'cache --timeout=999999999'
    git config --global user.name "omtinez"
    git config --global user.email "omtinez@gmail.com"
    git config --global push.default simple
    git config --global core.excludesfile ~/.git/.gitignore
}
export -f git_setup

function git_new_project() {
    if [[ ! $GITLAB_TOKEN ]] ; then echo "Env variable GITLAB_TOKEN has not been set" && return 1; fi
    CURR_DIR=${PWD##*/}
    PROJECT_NAME=${1:-$CURR_DIR}
    if [[ -f ~/.git ]] ; then rm -rfi .git ; fi && \
        curl -H "Content-Type:application/json" https://gitlab.com/api/v4/projects?private_token=$GITLAB_TOKEN -d "{ \"name\": \"$PROJECT_NAME\" }" && \
        git init && \
        git remote add origin "https://oauth2:$GITLAB_TOKEN@gitlab.com/omtinez/$PROJECT_NAME.git"
}
export -f git_new_project

# Start SSH agent
ssh_start_agent

# Import other scripts / envs
if [[ -f ~/.env ]] ; then source ~/.env ; fi
if [[ -f ~/.bash_aliases ]] ; then source ~/.bashrc_aliases ; fi

# Paths
export PATH=$PATH:~/bin