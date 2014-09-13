#!/bin/bash

# Enable simple aliases to be sudo'ed. ("sudone"?)
# http://www.gnu.org/software/bash/manual/bashref.html#Aliases says: "If the
# last character of the alias value is a space or tab character, then the next
# command word following the alias is also checked for alias expansion."
alias sudo='sudo '

# Super user
alias _='sudo'
alias please='sudo'

# use vim
if which vim >/dev/null 2>&1; then
  alias vi="vim"
fi

# Confirm before overwriting
# -----------------------------------------------------------------------------
# I know it is bad practice to override the default commands, but this is for
# my own safety. If you really want the original "instakill" versions, you can
# use "command rm", "\rm", or "/bin/rm" inside your own commands, aliases, or
# shell functions. Note that separate scripts are not affected by the aliases
# defined here.
#alias cp='cp -i'
#alias mv='mv -i'
#alias ln='ln -i'

alias rm='rm -I'                    # 'rm -i' prompts for every file

# safety features
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# personal shortcuts (add something like thin in ~/.extra)
#alias d="cd ~/Documents/Dropbox"
#alias dl="cd ~/Downloads"
#alias dt="cd ~/Desktop"
#alias p="cd ~/projects"

# global shortcuts
alias g="git"
alias h="history"
alias j="jobs"

# dmesg with readable time
alias dmesg='dmesg -T'

# command with color
if [ "$TERM" != "dumb" ]; then

  # dircolors
  if [ -s "$HOME/.dircolors" ]; then
    eval "$(dircolors -b $HOME/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi

  # Use "colordiff" or "highlight" to colour diffs.
  if command -v colordiff > /dev/null; then
    alias difflight='colordiff | less -XFIRd'
  elif command -v highlight > /dev/null; then
    alias difflight='highlight --dark-red ^-.* | highlight --dark-green ^+.* | highlight --yellow ^Only.* | highlight --yellow ^Files.*differ$ | less -XFIRd'
  else
    alias difflight='less -XFIRd'
  fi

  # colorize these commands if possible
  if which grc >/dev/null 2>&1; then
    alias colour='grc -es --colour=auto'
    alias configure='colour ./configure'
    alias diff='colour diff'
    alias make='colour make'
    alias gcc='colour gcc'
    alias g++='colour g++'
    alias ld='colour ld'
    alias netstat='colour netstat'
    alias ping='colour ping'
    alias traceroute='colour traceroute'
    alias tail='colour tail'
    alias ps='colour ps'
    alias syslog='sudo colour tail -f -n 100 /var/log/syslog'
  fi

  # replace top with htop
  if command -v htop >/dev/null; then
    alias top_orig='/usr/bin/top'
    alias top='htop'
  fi

  # Colorize the grep command output for ease of use (good for log files)
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'

  # list all files colorized in long format
  alias l="ls -lhF --color=auto"
  # Show hidden files
  alias l.="ls -dlhF .* --color=auto"
  # use colors
  alias ls="ls -F --color=auto"
  # displays all files and directories in detail
  alias la="ls -laFh --color=auto"
  alias lsa="la"
  # displays all files and directories in detail with newest-files at bottom
  alias lr="ls -laFhtr --color=auto"
  # show last 10 recently changed files
  alias lt="ls -altr | grep -v '^d' | tail -n 10"
  # show files and directories (also in sub-dir) that was touched in the last hour
  alias lf='find ./* -ctime -1 | xargs ls -ltr --color'
  # displays files and directories in detail
  alias ll="ls -lFh --color=auto --group-directories-first"
  # shows the most recently modified files at the bottom of
  alias llr="ls -lartFh --color=auto --group-directories-first"
  # list only directories
  alias lsd="ls -lFh --color=auto | grep --color=never '^d'"
  # displays files and directories
  alias dir="ls --color=auto --format=vertical"
  # displays more information about files and directories
  alias vdir="ls --color=auto --format=long"
else
  # only some default-"ls"-commands as fallback
  alias l='ls -lFh'
  alias l.='ls -dlFh .*'
  alias la='ls -laFh'
  alias lr='ls -laFhtr'
  alias lsa='la'
  alias ll='ls -lFh'
fi

# Clipboard access. I created these aliases to have the same command on
# Cygwin, Linux and OS X.
if command -v pbpaste >/dev/null; then
  alias getclip="pbpaste"
  alias putclip="pbcopy"
elif command -v xclip >/dev/null; then
  alias getclip="xclip -o"
  alias putclip="xclip -i"
fi

# the load-avg
alias loadavg="cat /proc/loadavg"

# show all partitions
alias partitions="cat /proc/partitions"

# speedtest: get a 100MB file via wget
alias speedtest="wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip"

# search in files
alias afind='ack-grep -iH'

# displays a directory tree
alias tree="tree -Csu"

# displays a directory tree - paginated
alias ltree="tree -Csu | less -R"

# Gzip-enabled `curl`
alias gurl='curl --compressed'

# date
alias date_iso_8601='date "+%Y%m%dT%H%M%S"'
alias date_clean='date "+%Y-%m-%d"'
alias date_year='date "+%Y"'
alias date_month='date "+%m"'
alias date_week='date "+%V"'
alias date_day='date "+%d"'
alias date_hour='date "+%H"'
alias date_minute='date "+%M"'
alias date_second='date "+%S"'

# stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# decimal to hexadecimal value
alias dec2hex='printf "%x\n" $1'

# mkdir: always create parent-dirs, if needed
alias mkdir="mkdir -p"

# create a dir with date from today
alias mkdd='mkdir $(date +%Y%m%d)'

# get / check for updates
# TODO: check for debian-based
alias updates='sudo apt-get update'

# external ip address
alias myip_dns="dig +short myip.opendns.com @resolver1.opendns.com"
alias myip_http="GET http://ipecho.net/plain && echo"

# becoming root + executing last command
# TODO: check if we use "zsh" and "SHARE_HISTORY"?
alias sulast='su -c $(history -p !-1) root'

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# urldecode - url http network decode
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'

# urlencode - url encode network http
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# empty the your trash-dir
alias emptytrash="rm -rfv ~/.local/share/Trash/*"

# ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"

# intuitive map function
#
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# one of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

# make Grunt print stack traces by default
command -v grunt > /dev/null && alias grunt="grunt --stack"

# pass options to free
alias meminfo='free -m -l -t'

# get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

# get top process eating cpu
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# Get server cpu info
alias cpuinfo='lscpu'
# older system use /proc/cpuinfo
#alias cpuinfo='less /proc/cpuinfo'

# shows the corresponding process to ...
alias psx='ps auxwf | grep '

# shows the process structure to clearly
alias pst='pstree -Alpha'

# shows all your processes
alias psmy='ps -ef | grep $USER'

# displays the ports that use the applications
alias lsport='sudo lsof -i -T -n'

# shows more about the ports on which the applications use
alias llport='netstat -nape --inet --inet6'

# show only active network listeners
alias netlisteners='sudo lsof -i -P | grep LISTEN'

# shows the disk usage of a directory legibly
alias du='du -kh'

# show the biggest files in a folder first
alias du_overview='du -h | grep "^[0-9,]*[MG]" | sort -hr | less'

# shows the complete disk usage to legibly
alias df='df -kTh'

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# faster npm for europeans
command -v npm > /dev/null && alias npme="npm --registry http://registry.npmjs.eu"

# php - package-manager - composer
alias composer-install="composer install --optimize-autoloader"

# add ssh-key to clipboard
alias sshkey="cat ~/.ssh/id_rsa.pub | putclip && echo 'Copied to clipboard.'"

# add ssh-key to ssh-agent when key exist
if [ "$SSH_AUTH_SOCK" != "" ] && [ -f ~/.ssh/id_rsa ] && [ -x /usr/bin/ssh-add  ]; then
  ssh-add -l >/dev/null || alias ssh='(ssh-add -l >/dev/null || ssh-add) && unalias ssh; ssh'
fi
