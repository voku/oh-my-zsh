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

