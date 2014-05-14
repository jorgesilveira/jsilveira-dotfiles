#
# ALIAS
#
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


#
# DEFAULTS
#
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

export HISTCONTROL=erasedups
export HISTFILESIZE=100000
export HISTSIZE=${HISTFILESIZE}
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi


#
# GIT
#
alias gs="git status"
alias go="git checkout"


#
# COLORS
#
export BLUE="\[\033[0;34m\]"
export NO_COLOR="\[\e[0m\]"
export GRAY="\[\033[1;30m\]"
export GREEN="\[\033[0;32m\]"
export LIGHT_GRAY="\[\033[0;37m\]"
export LIGHT_GREEN="\[\033[1;32m\]"
export LIGHT_RED="\[\033[1;31m\]"
export RED="\[\033[0;31m\]"
export WHITE="\[\033[1;37m\]"
export YELLOW="\[\033[0;33m\]"


#
# CUSTOM PROMPT
#
rails_version() {
  rails=$(rails --version | grep '^Rails [0-9]')
  if [ "$?" == "0" ]; then
    echo ${rails:6}
  else
    echo "No rails"
  fi
}

ruby_version() {
  ruby='ruby -e "puts RUBY_VERSION"'
  echo ruby
}

custom_prompt () {
  local BRANCH=`git branch 2> /dev/null | grep \* | sed 's/* //'`

  if [[ "$BRANCH" = "" ]]; then
    BRANCH=`git status 2> /dev/null | grep "On branch" | sed 's/# On branch //'`
  fi

  local STATUS=`git status 2>/dev/null`
  local PROMPT_COLOR=$GREEN
  local STATE=" "
  local NOTHING_TO_COMMIT="# Initial commit"
  local BEHIND="# Your branch is behind"
  local AHEAD="# Your branch is ahead"
  local UNTRACKED="# Untracked files"
  local DIVERGED="have diverged"
  local CHANGED="# Changed but not updated"
  local TO_BE_COMMITED="# Changes to be committed"
  local LOG=`git log -1 2> /dev/null`
  local RUBY_VERSION=`ruby -e "puts RUBY_VERSION"`

  if [ "$STATUS" != "" ]; then
    if [[ "$STATUS" =~ "$NOTHING_TO_COMMIT" ]]; then
      PROMPT_COLOR=$RED
      STATE=""
    elif [[ "$STATUS" =~ "$DIVERGED" ]]; then
      PROMPT_COLOR=$RED
      STATE="${STATE}${RED}↕${NO_COLOR}"
    elif [[ "$STATUS" =~ "$BEHIND" ]]; then
      PROMPT_COLOR=$RED
      STATE="${STATE}${RED}↓${NO_COLOR}"
    elif [[ "$STATUS" =~ "$AHEAD" ]]; then
      PROMPT_COLOR=$RED
      STATE="${STATE}${RED}↑${NO_COLOR}"
    elif [[ "$STATUS" =~ "$CHANGED" ]]; then
      PROMPT_COLOR=$RED
      STATE=""
    elif [[ "$STATUS" =~ "$TO_BE_COMMITED" ]]; then
      PROMPT_COLOR=$RED
      STATE=""
    else
      PROMPT_COLOR=$GREEN
      STATE=""
    fi

    if [[ "$STATUS" =~ "$UNTRACKED" ]]; then
      STATE="${STATE}${YELLOW}*${NO_COLOR}"
    fi

    PS1="\n[${GREEN}\t${NO_COLOR} > \u@\h] ${YELLOW}\w\a${NO_COLOR} (${PROMPT_COLOR}${BRANCH}${NO_COLOR}${STATE}) (${YELLOW}$(rails_version)|${RUBY_VERSION}${NO_COLOR})\n$ "
  else
    PS1="\n[${GREEN}\t${NO_COLOR} > \u@\h] ${YELLOW}\w\a${NO_COLOR} (${YELLOW}$(rails_version)|${RUBY_VERSION}${NO_COLOR})\n\$ "
  fi
}

PROMPT_COMMAND=custom_prompt


#
# RVM
#
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
source $HOME/.rvm/scripts/rvm

#
# JAVA
#
export JAVA_HOME=/usr/lib/jvm/java-7-oracle

#
# PROMPT
#
cd ~/Codes