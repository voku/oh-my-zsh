
# smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# set default options
setopt \
  `# please no beeeeeeps` \
  NO_BEEP \
  `# list jobs in the long format by default` \
  LONG_LIST_JOBS

