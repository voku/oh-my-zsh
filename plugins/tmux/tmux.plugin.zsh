#
# aliases
#

alias ta='tmux attach -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'

# only run if tmux is actually installed
if which tmux &> /dev/null; then
  # configuration variables
  #
  # automatically start tmux
  [[ -n "$ZSH_TMUX_AUTOSTART" ]] || ZSH_TMUX_AUTOSTART=false
  # Only autostart once. If set to false, tmux will attempt to
  # autostart every time your zsh configs are reloaded.
  [[ -n "$ZSH_TMUX_AUTOSTART_ONCE" ]] || ZSH_TMUX_AUTOSTART_ONCE=true
  # automatically connect to a previous session if it exists
  [[ -n "$ZSH_TMUX_AUTOCONNECT" ]] || ZSH_TMUX_AUTOCONNECT=true
  # automatically close the terminal when tmux exits
  [[ -n "$ZSH_TMUX_AUTOQUIT" ]] || ZSH_TMUX_AUTOQUIT=$ZSH_TMUX_AUTOSTART
  # set term to screen or screen-256color based on current terminal support
  [[ -n "$ZSH_TMUX_FIXTERM" ]] || ZSH_TMUX_FIXTERM=true
  # Set '-CC' option for iTerm2 tmux integration
  [[ -n "$ZSH_TMUX_ITERM2" ]] || ZSH_TMUX_ITERM2=false
  # Extra options to pass through to tmux
  [[ -n "$ZSH_TMUX_OPTIONS" ]] || ZSH_TMUX_OPTIONS=""
  # The TERM to use for non-256 color terminals.
  # Tmux states this should be screen, but you may need to change it on
  # systems without the proper terminfo
  [[ -n "$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR" ]] || ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="screen"
  # The TERM to use for 256 color terminals.
  # Tmux states this should be screen-256color, but you may need to change it on
  # systems without the proper terminfo
  [[ -n "$ZSH_TMUX_FIXTERM_WITH_256COLOR" ]] || ZSH_TMUX_FIXTERM_WITH_256COLOR="screen-256color"


  # get the absolute path to the current directory
  local zsh_tmux_plugin_path="$(cd "$(dirname "$0")" && pwd)"

  # determine if the terminal supports 256 colors
  if [[ `tput colors` == "256" ]]; then
    export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITH_256COLOR
  else
    export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR
  fi

  # Set the correct local config file to use.
  if [[ "$ZSH_TMUX_ITERM2" == "false" ]] && [[ -f $HOME/.tmux.conf || -h $HOME/.tmux.conf ]]; then
    #use this when they have a ~/.tmux.conf
    export _ZSH_TMUX_FIXED_CONFIG="$zsh_tmux_plugin_path/tmux.extra.conf"
  else
    # use this when they don't have a ~/.tmux.conf
    export _ZSH_TMUX_FIXED_CONFIG="$zsh_tmux_plugin_path/tmux.only.conf"
  fi

  # wrapper function for tmux
  _zsh_tmux_plugin_run()
  {
    # construct options
    tmux_options=($ZSH_TMUX_OPTIONS)
    [[ "$ZSH_TMUX_ITERM2"  == "true" ]] && tmux_options+=("-CC")
    [[ "$ZSH_TMUX_FIXTERM" == "true" ]] && tmux_options+=("-f" "$_ZSH_TMUX_FIXED_CONFIG")

    # we have other arguments, just run them
    if [[ -n "$@" ]]; then
      \tmux $@
    # try to connect to an existing session
    elif [[ "$ZSH_TMUX_AUTOCONNECT" == "true" ]]; then
      \tmux $tmux_options attach || \tmux $tmux_options new-session
      [[ "$ZSH_TMUX_AUTOQUIT" == "true" ]] && exit
    # just run tmux, fixing the TERM variable if requested
    else
      \tmux $tmux_options
      [[ "$ZSH_TMUX_AUTOQUIT" == "true" ]] && exit
    fi
  }

  # use the completions for tmux for our function
  compdef _tmux _zsh_tmux_plugin_run

  # alias tmux to our wrapper function
  alias tmux=_zsh_tmux_plugin_run

  # autostart if not already in tmux and enabled
  if [[ ! -n "$TMUX" && "$ZSH_TMUX_AUTOSTART" == "true" ]]; then
    # Actually don't autostart if we already did and multiple autostarts are disabled.
    if [[ "$ZSH_TMUX_AUTOSTART_ONCE" == "false" || "$ZSH_TMUX_AUTOSTARTED" != "true" ]]; then
      export ZSH_TMUX_AUTOSTARTED=true
      _zsh_tmux_plugin_run
    fi
  fi
else
  print "zsh tmux plugin: tmux not found. Please install tmux before using this plugin."
fi

