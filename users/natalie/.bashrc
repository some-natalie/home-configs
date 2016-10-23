# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi


# # # # # # # #
# ANSI colors #  http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# # # # # # # #

RED="\[\033[0;31m\]"
YELLOW="\033[1;33m"
GREEN="\[\033[0;32m\]"
BLUE="\033[0;34m"
PURPLE="\[\033[0;35m\]"
LIGHT_GREY="\[\033[0;37m\]"
DARK_GREY="\[\033[1;30m\]"
NO_COLOR="\033[0m"


# # # # # # # # #
# Pretty colors #
# # # # # # # # #

PS1="\[\033[01;35m\]\u\[\033[00m\]\[\033[35m\]@\[\033[01;35m\]\h\[\033[00m\] \[\033[01;34m\]\$(pwd | sed 's/^.//g' | sed 's/\(.\)[^\/]*\//\1\//g' | sed 's/^\(.\)/\/\1/g' | sed 's/^$/\//')\[\033[00m\] \\$ "  # user
# PS1="\[\033[01;31m\]\u\[\033[00m\]\[\033[31m\]@\[\033[01;31m\]\h\[\033[00m\] \[\033[01;34m\]\$(pwd | sed 's/^.//g' | sed 's/\(.\)[^\/]*\//\1\//g' | sed 's/^\(.\)/\/\1/g' | sed 's/^$/\//')\[\033[00m\] \\$ "  # root


# # # # # #
# Exports #
# # # # # #

export PATH=$PATH:~/.packer
export EDITOR=/usr/bin/vim
export PAGER=/usr/bin/less
export HISTIGNORE="history;ls;w;date;man *;exit"
export HISTTIMEFORMAT="%d-%b-%y %H:%M   "
export HISTCONTROL="ignoreboth"


# # # # # # # # # # # # # #
# Aliases for general use #
# # # # # # # # # # # # # #

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'
alias c='clear'
alias df='df -h -x tmpfs -x devtmpfs'
alias dft='df -Tha --total'
alias dl='curl -OJL'
alias du='du -chs'
alias free='free -h'
alias ls='ls -lhaF --color'
alias ls-enabled='systemctl list-unit-files | grep enabled'
alias mkdir='mkdir -p'
alias myip='curl http://ipecho.net/plain; echo'
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias pip2-update="pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip2 install -U"
alias pip3-update="pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U"
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias psu="ps uxU ${1}"
alias pwgen='openssl rand -base64 12'
alias sshgen='ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)-$(date -I)"'
alias updates='dnf clean all && dnf update -y'
alias wget='wget -c'
alias youtube='youtube-dl --newline'


# # # # # # # # # # # # #
# Aliases for SaltStack #
# # # # # # # # # # # # #

alias highstate="salt -b 5 '*' state.highstate"
alias highstate-json="salt -b 5 '*' state.highstate --output=json --out-indent=2 --output-file=$(date +"%m_%d_%Y")-highstate.json"
alias salt-ping="salt '*' test.ping"
alias update-all="salt '*' state.sls pkg.updates"
alias reboot-all="salt -b 1 '*' system.reboot"
alias salt-ip="salt '*' network.ip_addrs"


# # # # # # # # # #
# Aliases for git #
# # # # # # # # # #

alias g="git"
alias ga="git add --all"
alias gb="git branch"
alias gc="git commit"
alias gco="git checkout"
alias gcol="git checkout live"
alias gcom="git checkout master"
alias gcos="git checkout stable"
alias gcou="git checkout upstream"
alias gd="git diff"
alias gl="git lg"
alias gm="git merge"
alias gp="git pull --ff"
alias gpol="git push origin live"
alias gpom="git push origin master"
alias gpos="git push origin stable"
alias gpou="git push origin upstream"
alias gs="git status"
alias gitgraph="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias git-yolo='git commit -am "`curl -s http://whatthecommit.com/index.txt`"'
alias git-friday-afternoon='git commit -a -m "obviously not a read-only friday"; git push --force'


# # # # # # # # # # # # # # #
# Aliases for Raspberry Pi  #
# # # # # # # # # # # # # # #

alias temp='/opt/vc/bin/vcgencmd measure_temp'
alias clock='for src in arm core h264 isp v3d uart pwm emmc pixel vec hdmi dpi ; do echo -e "$src:\t$(/opt/vc/bin/vcgencmd measure_clock $src | cut -d "=" -f2)" ; done'
alias volts='for id in core sdram_c sdram_i sdram_p ; do echo -e "$id:\t$(/opt/vc/bin/vcgencmd measure_volts $id)" ; done'


# # # # # # #
# Functions #
# # # # # # #

# Extract a file
function extract() {
  if [ "${1}" = "-h" ]; then
    echo "Usage: extract [filename]"
    echo "Extracts specified archive."
    return
  fi
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.tar.Z) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.jar) unzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *) echo "'$1' cannot be extracted." ;;
    esac
    else
      echo "'$1' is not a file."
  fi
}

# RTFM
function rtfm() {
  if [ "${1}" = "-h" ]; then
    echo "Usage: rtfm [command]"
    echo "Returns [command] -h, or then the man page, or then Google search results"
    return
  fi
  "$@" --help 2> /dev/null || man "$@" 2> /dev/null || open 'http://www.google.com/search?q="$@"';
}

# What processes are listening on what ports?
function listening {
  if [ "${1}" = "-h" ]; then
    echo "Usage: listening [t|tcp|u|udp] [ps regex]"
    return
  fi
  DISP="both"
  NSOPTS="tu"
  if [ "${1}" = "t" -o "${1}" = "tcp" ]; then
    DISP="tcp"
    NSOPTS="t"
    shift
  elif [ "${1}" = "u" -o "${1}" = "udp" ]; then
    DISP="udp"
    NSOPTS="u"
    shift
  fi
  FILTER="${*}"
  PORTS_PIDS=$(netstat -"${NSOPTS}"lnp | tail -n +3 | tr -s ' ' | sed -n 's/\(tcp\|udp\) [0-9]* [0-9]* \(::\|0\.0\.0\.0\|127\.[0-9]*\.[0-9]*\.[0-9]*\):\([0-9]*\) .* \(-\|\([0-9-]*\)\/.*\)/\3 \1 \5 \2/p' | sed 's/\(::\|0\.0\.0\.0\)/EXTERNAL/' | sed 's/127\.[0-9]*\.[0-9]*\.[0-9]*/LOCALHOST/' | sort -n | tr ' ' ':' | sed 's/::/:-:/' | sed 's/:$//' | uniq)
  PS=$(ps -eo pid,args)
  echo -e '   Port - Protocol - Interface - Program\n-----------------------------------------------'
  for PORT_PID in ${PORTS_PIDS}; do
    PORT=$(echo "${PORT_PID}" | cut -d':' -f1)
    PROTOCOL=$(echo "${PORT_PID}" | cut -d':' -f2)
    PID=$(echo "${PORT_PID}" | cut -d':' -f3)
    INTERFACE=$(echo "${PORT_PID}" | cut -d':' -f4)
    if [ "${PROTOCOL}" != "${DISP}" -a "${DISP}" != "both" ]; then
      continue
    fi
    if [ "${PID}" = "-" ]; then
      if [ "${FILTER}" != "" ]; then
        continue
      fi
      printf "%7s - %8s - %9s - -\n" "${PORT}" "${PROTOCOL}" "${INTERFACE}"
    else
      PROG=$(echo "${PS}" | grep "^ *${PID}" | grep -o '[0-9] .*' | cut -d' ' -f2-)
      if [ "${FILTER}" != "" ]; then
        echo "${PROG}" | grep -q "${FILTER}"
        if [ $? -ne 0 ]; then
          continue
        fi
      fi
      printf "%7s - %8s - %9s - %s\n" "${PORT}" "${PROTOCOL}" "${INTERFACE}" "${PROG}"
    fi
  done
}

# What processes have open files?
function openfiles {
  if [ "${1}" = "-h" ]; then
    echo -e "Usage: openfiles [r|w|m|R|W] regex\n    -r    opened for reading or read/write\n    -w    opened for writing or read/write\n    -m    accessed from memory (includes running command)\n    -R    opened for reading only\n    -W    opened for writing only"
    return
  fi
  if [ "$#" = "0" ]; then
    echo "Process signature/regex required."
    return
  fi
  MODE="(w|u)"
  ACTION="for writing"
  if [ "${1}" = "r" ]; then
    MODE="(r|u)"
    ACTION="for reading"
    shift
  elif [ "${1}" = "R" ]; then
    MODE="r"
    ACTION="for reading (only)"
    shift
  elif [ "${1}" = "W" ]; then
    MODE="w"
    ACTION="for writing (only)"
    shift
  elif [ "${1}" = "m" ]; then
    MODE="(txt|mem)"
    ACTION="in memory"
    shift
  elif [ "${1}" = "w" ]; then
    shift
  fi
  if [ "${MODE}" != "(txt|mem)" ]; then
    MODE="[0-9]+${MODE}"
  fi
  PIDS=$(pgrep -d "," -f "${@}")
  if [ "${PIDS}" = "" ]; then
    echo "No processes found matching '${@}'."
    return
  fi
  OPENFILES=$(lsof -PXn -p "${PIDS}" | egrep "${MODE}[A-Za-z]* +REG" | awk '{print $9}' | egrep -v "^\[" | sort | uniq);
  if [ "${OPENFILES}" = "" ]; then
    echo "No files opened ${ACTION}."
  else
    echo "Files opened ${ACTION}:"
    ls -ahl "$OPENFILES"
  fi
}

# Color man pages
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
      man "$@"
}

# IP info
ipif() {
    if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
  curl ipinfo.io/"$1"
    else
  ipawk=($(host "$1" | awk '/address/ { print $NF }'))
  curl ipinfo.io/${ipawk[1]}
    fi
    echo
}
