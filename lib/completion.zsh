
############# SETOPT ######################################

setopt \
    `# please no beeeeeeps` \
    NO_BEEP \
    `# automatically list choices on an ambiguous completion` \
    AUTO_LIST \
    `# automatically use menu completion after the second consecutive request for completion` \
    AUTO_MENU \
    `# when listing files that are possible completions, show the type of each file with a trailing identifying mark` \
    LIST_TYPES \
    `# all unquoted arguments of the form identifier=expression appearing after the command name have file expansion` \
    MAGIC_EQUAL_SUBST \
    `# don’t push multiple copies of the same directory onto the directory stack` \
    PUSHD_IGNORE_DUPS \
    `# if unset, the cursor is set to the end of the word if completion is started. Otherwise it stays there and completion is done from both ends` \
    COMPLETE_IN_WORD \
    `# when the current word has a glob pattern, do not insert all the words resulting from the expansion but generate matches as for completion and cycle through them` \
    GLOB_COMPLETE \
    `# more patterns for filename generation` \
    EXTENDED_GLOB \
    `# do not require a leading ‘.’ in a filename to be matched explicitly` \
    GLOB_DOTS \
    `# list jobs in the long format by default` \
    LONG_LIST_JOBS \
    `# append a trailing ‘/’ to all directory names resulting from filename generation` \
    MARK_DIRS \
    `# don’t push multiple copies of the same directory onto the directory stack` \
    PUSHD_IGNORE_DUPS \
    `# remove any right prompt from display when accepting a command line. This may be useful with terminals with other cut/paste methods` \
    TRANSIENT_RPROMPT \
    `# allow comments even in interactive shells` \
    INTERACTIVE_COMMENTS \
    `# if a completion is performed with the cursor within a word, and a full completion is inserted, the cursor is moved to the end of the word` \
    ALWAYS_TO_END

unsetopt \
    `# do not autoselect the first completion entry ` \
    MENU_COMPLETE \
    `# do not freezes output to the terminal until you type ^q `\
    FLOWCONTROL \
    `# do not print the directory stack after pushd or popd` \
    PUSHD_SILENT \
    `# if a command is not in the hash table, and there exists an executable directory by that name, perform the cd command to that directory` \
    AUTO_CD


############# AUTOLOAD ######################################

autoload -Uz promptinit
promptinit
prompt walters

autoload colors ; colors
autoload -Uz compinit
compinit -C


############# ZSTYLE ######################################

WORDCHARS=''

zmodload -i zsh/complist

compdef pkill=kill
compdef pkill=killall

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
autoload -U colors ; colors
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

############# BINDKEY ######################################

bindkey -M menuselect '^o' accept-and-infer-next-history

bindkey -e
bindkey '^i' expand-or-complete-prefix                  # Tab
bindkey "^[[2~" yank                                    # Insert
bindkey "^[[3~" delete-char                             # Del
bindkey "^[[5~" history-beginning-search-backward       # PageUp
bindkey "^[[6~" history-beginning-search-forward        # PageDown
bindkey "^[e" expand-cmd-path                           # Alt-e
bindkey "^[[A" up-line-or-search                        # up arrow
bindkey "^[[B" down-line-or-search                      # down arrow
bindkey " " magic-space                                 # history expansion on space

if [ "x$COMPLETION_WAITING_DOTS" = "xtrue" ]; then
  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
fi
