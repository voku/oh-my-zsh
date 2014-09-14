# web_search from terminal

web_search()
{
  # get the open command
  local open_cmd
  if [[ "$OSTYPE" = darwin* ]]; then
    open_cmd='open'
  elif [[ "$OSTYPE" = cygwin ]]; then
    open_cmd='cygstart'
  else
    open_cmd='xdg-open'
  fi

  # check whether the search engine is supported
  if [[ ! $1 =~ '(google|bing|yahoo|duckduckgo|yandex)' ]]; then
    echo "Search engine $1 not supported."
    return 1
  fi

  local url="http://www.$1.com"

  # no keyword provided, simply open the search engine homepage
  if [[ $# -le 1 ]]; then
    $open_cmd "$url"
    return
  fi

  if [[ $1 == 'duckduckgo' ]]; then
    # slightly different search syntax for DDG
    url="${url}/?q="
  elif [[ $1 == 'yandex' ]]; then
    url="http://yandex.ru/yandsearch?text="
  else
    url="${url}/search?q="
  fi

  shift   # shift out $1

  while [[ $# -gt 0 ]]; do
    url="${url}$1+"
    shift
  done

  url="${url%?}" # remove the last '+'
  nohup $open_cmd "$url" &>/dev/null </dev/null &
}


alias bing='web_search bing'
alias google='web_search google'
alias yandex='web_search yandex'
alias ya='web_search yandex'
alias yahoo='web_search yahoo'
alias ddg='web_search duckduckgo'
#add your own !bang searches here
alias wiki='web_search duckduckgo \!w'
alias news='web_search duckduckgo \!n'
alias youtube='web_search duckduckgo \!yt'
alias map='web_search duckduckgo \!m'
alias image='web_search duckduckgo \!i'
alias ducky='web_search duckduckgo \!'

