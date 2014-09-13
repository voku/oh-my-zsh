## Command history configuration

if [ -z $HISTFILE ]; then
  HISTFILE=$HOME/.zsh_history
fi

# info: You should be sure to set the value of HISTSIZE to a larger number than SAVEHIST in order to give you some room for the duplicated events
HISTSIZE=20000
SAVEHIST=10000

setopt \
    `# Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file ` \
    EXTENDED_HISTORY \
    `# Do not enter command lines into the history list if they are duplicates of the previous event ` \
    HIST_IGNORE_DUPS \
    `# If the internal history needs to be trimmed to add the current command line, setting this option will cause the oldest history event that has a duplicate to be lost before losing a unique event ` \
    HIST_EXPIRE_DUPS_FIRST \
    `# remove command lines from the history list when the first character on the line is a space` \
    HIST_IGNORE_SPACE \
    `# remove the history (fc -l) command from the history list when invoked` \
    HIST_NO_STORE \
    `# remove superfluous blanks from each command line being added to the history list` \
    HIST_REDUCE_BLANKS \
    `# whenever the user enters a line with history expansion, don’t execute the line directly ` \
    HIST_VERIFY \

  unsetopt \
    `# this option both imports new commands from the history file, and also causes your typed command ` \
    SHARE_HISTORY \
    `# do not beeep, please ` \
    HIST_BEEP

