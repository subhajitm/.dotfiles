# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything

export PATH=/usr/local/bin:${PATH}
export PATH=${PATH}:~/bin
# Add GNU-ARM toolchain
export PATH=${PATH}:/opt/arm-gcc/bin

[ -z "$PS1" ] && return

export EDITOR=vim
set -o vi
if [[ $( shopt | grep 'autocd' ) ]]; then
   shopt -s autocd
fi
#HISTORY
HISTCONTROL=ignoredups:ignorespace

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

color_prompt=
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
   color_prompt=yes
fi

c_user='\[\e[34m\]'
c_host='\[\e[32m\]'
c_pwd='\[\e[36m\]'
c_oky='\[\e[33m\]'
c_bad='\[\e[31m\]'
c_reset='\[\e[00m\]'
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
if [ "$color_prompt" = yes ]; then
    PS1="[\$?:\`ret=\$?; if [ "\$\{ret\}" = "0" ]; then echo -E ${c_oky}; else echo -E ${c_bad}; fi\`\!${c_reset}] "${debian_chroot:+($debian_chroot)}${c_user}'\u'${c_reset}'@'${c_host}'\h'${c_reset}':'${c_pwd}'\W'${c_reset}':'${c_oky}'$(parse_git_branch)'${c_reset}'$ '
else
    PS1='[\!]${debian_chroot:+($debian_chroot)}\u:\W\$\a '

fi
tput sgr0
unset color_prompt force_color_prompt
unset c_user c_host c_pwd c_oky c_bad c_reset

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias tmux='tmux -2'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.term ]; then
   tput setaf 4
   cat ~/.term
   tput setaf 1
fi

if [ -f ~/bin/todo ]; then
   todo -p
   tput sgr0
fi

if [ -f ~/.xmodmap ]; then
   xmodmap ~/.xmodmap
fi

# useful aliases
alias cls=clear
alias agi="sudo apt-get install"
alias agr="sudo apt-get remove"
alias agu="sudo apt-get update"
alias acs="apt-cache search"

source ~/.git-complete.bash

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

SSH_ENV=$HOME/.ssh/environment
   
# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}
   
if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
