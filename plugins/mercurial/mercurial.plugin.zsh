# Mercurial
alias hgc='hg commit'
alias hgb='hg branch'
alias hgba='hg branches'
alias hgbk='hg bookmarks'
alias hgco='hg checkout'
alias hgd='hg diff'
alias hged='hg diffmerge'
# pull and update
alias hgi='hg incoming'
alias hgl='hg pull -u'
alias hglr='hg pull --rebase'
alias hgo='hg outgoing'
alias hgp='hg push'
alias hgs='hg status'
alias hgsl='hg log --limit 20 --template "{node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\n" '
# this is the 'git commit --amend' equivalent
alias hgca='hg qimport -r tip ; hg qrefresh -e ; hg qfinish tip'
# list unresolved files (since hg does not list unmerged files in the status command)
alias hgun='hg resolve --list'

in_hg()
{
  if [[ -d .hg ]] || $(hg summary > /dev/null 2>&1); then
    echo 1
  fi
}

hg_get_branch_name()
{
  if [ $(in_hg) ]; then
    echo $(hg branch)
  fi
}

hg_prompt_info()
{
  if [ $(in_hg) ]; then
    local display=$(hg_get_branch_name)
    echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_HG_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR$display$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_HG_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR$(hg_dirty)$ZSH_PROMPT_BASE_COLOR"
  fi
}

hg_dirty_choose()
{
  if [ $(in_hg) ]; then
    hg status 2> /dev/null | grep -Eq '^\s*[ACDIM!?L]'
    if [ $pipestatus[-1] -eq 0 ]; then
      # Grep exits with 0 when "One or more lines were selected", return "dirty".
      echo $1
    else
      # Otherwise, no lines were found, or an error occurred. Return clean.
      echo $2
    fi
  fi
}

hg_dirty()
{
  hg_dirty_choose $ZSH_THEME_HG_PROMPT_DIRTY $ZSH_THEME_HG_PROMPT_CLEAN
}

hgic()
{
  hg incoming "$@" | grep "changeset" | wc -l
}

hgoc()
{
  hg outgoing "$@" | grep "changeset" | wc -l
}
