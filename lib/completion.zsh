
############# ZSTYLE ######################################

# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:approximate:*' max-errors 1
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# cd directory stack menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# cd will never select the parent directory (e.g.: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Ignore completion functions for commands you don’t have:
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

#
zstyle ':completion::complete:*' '\\'

#
zstyle ':completion::complete:cd:' tag-order local-directories path-directories

# add colors to completions
# general completion
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format "No match in: %B%d%b"zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true

#
zstyle ':completion:*:options' description 'yes'

#
zstyle ':completion:*:options' auto-description '%d'

#
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'

#
zstyle ':completion:*:*:*:default' menu yes select

# This way you tell zsh comp to take the first part of the path to be
# exact, and to avoid partial globs. Now path completions became nearly
# immediate.
zstyle ':completion:*' accept-exact '*(N)'

#
zstyle ':completion:*:*:default' force-list always

# highlight matching part of available completions
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors  'reply=( "=(#b)(*$PREFIX)(?)*=00=$color[green]=$color[bg-green]" )'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %P Lines: %m
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:*:*:hosts' list-colors '=*=30;41'
zstyle ':completion:*:*:*:*:users' list-colors '=*=34;47'

# If the zsh/complist module is loaded, this style can be used to set
# color specifications. This mechanism replaces the use of the
# ZLS_COLORS and ZLS_COLOURS parameters.
# PIDs (bold red)
zstyle ':completion:*:processes' command ps --forest -A -o pid,cmd
zstyle ':completion:*:processes' list-colors '=(#b)( #[0-9]#)[^[/0-9a-zA-Z]#(*)=34=37;1=30;1'

# extra settings for the "kill"-command
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:(killall|pkill|kill):*' menu yes select
zstyle ':completion:*:(killall|pkill|kill):*' force-list always

# I'm bonelazy ;) Complete the hosts and - last but not least - the remote
# directories. Try it:
#  $ scp file username@<TAB><TAB>:/<TAB>
zstyle ':completion:*:(ssh|scp|ftp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp|ftp):*' users $users

# determine in which order the names (files) should be
# listed and completed when using menu completion.
# `size' to sort them by the size of the file
# `links' to sort them by the number of links to the file
# `modification' or `time' or `date' to sort them by the last modification time
# `access' to sort them by the last access time
# `inode' or `change' to sort them by the last inode change time
# `reverse' to sort in decreasing order
# If the style is set to any other value, or is unset, files will be
# sorted alphabetically by name.
zstyle ':completion:*' file-sort name

#
zstyle ':completion:*' auto-description 'specify: %d'

#
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

# how many completions switch on menu selection
# use 'long' to start menu compl. if list is bigger than screen
# or some number to start menu compl. if list has that number
# of completions (or more).
zstyle ':completion:*' menu select=long

# If there are more than 5 options, allow selecting from a menu with
# arrows (case insensitive completion!).
zstyle ':completion:*-case' menu select=5

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# filename suffixes to ignore during completion (except after rm
# command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns  '*?.(o|c~|old|pro|zwc)' '*~'

#
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

#
zstyle ':completion:*' use-compctl false

# history
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Some functions, like _apt and _dpkg, are very slow. You can use a cache in order to proxy the list of results (like the list of available debian packages) Use a cache:
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH/cache/

# If you end up using a directory as argument, this will remove the trailing slash (usefull in ln)
zstyle ':completion:*' squeeze-slashes true

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# Prevent CVS files/directories from being completed:
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

#
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

#
zstyle ':completion:*:*:*:*:*' menu select

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun www-run xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

