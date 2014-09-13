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

# Confirm before overwriting
# ----------------------------------------------------------------------------
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

# dmesg with readable time
alias dmesg='dmesg -T'

# Show history
if [ "$HIST_STAMPS" = "mm/dd/yyyy" ]; then
  alias history='fc -fl 1'
elif [ "$HIST_STAMPS" = "dd.mm.yyyy" ]; then
  alias history='fc -El 1'
elif [ "$HIST_STAMPS" = "yyyy-mm-dd" ]; then
  alias history='fc -il 1'
else
  alias history='fc -l 1'
fi

# List direcory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

alias afind='ack-grep -iH'

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
fi

