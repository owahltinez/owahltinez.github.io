# Aliases
alias ll='ls -halF'
alias cd..='cd ..'
alias apti='sudo apt-get install'

# Define functions
lsipv6() {
    ip -6 addr | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^::1 | grep -v ^fe80
}

# Export defined functions
export -f lsipv6

# Handy exports
export GH='https://github.com/omtinez'
export GT='https://github.gatech.edu/omartinez8'

# Paths
export PATH=$PATH:~/bin
