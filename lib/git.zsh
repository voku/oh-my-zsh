# get the name of the branch we are on
git_prompt_info()
{
  local ref=''

  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) \
      || ref=$(command git rev-parse --short HEAD 2> /dev/null) \
      || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Checks if working tree is dirty
parse_git_dirty()
{
  local submodule_syntax=''
  local git_status=''

  if [[ "$(command git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
      submodule_syntax="--ignore-submodules=dirty"
    fi

    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
        git_status=$(command git status -s ${submodule_syntax} -uno 2> /dev/null | tail -n1)
    else
        git_status=$(command git status -s ${submodule_syntax} 2> /dev/null | tail -n1)
    fi

    if [[ -n $git_status ]]; then
      echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
      echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi

  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# get the difference between the local and remote branches
git_remote_status()
{
  local remote ahead behind

  remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
  if [[ -n ${remote} ]] ; then
    ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

    if [ $ahead -eq 0 ] && [ $behind -gt 0 ]; then
      echo "$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
    elif [ $ahead -gt 0 ] && [ $behind -eq 0 ]; then
      echo "$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
    elif [ $ahead -gt 0 ] && [ $behind -gt 0 ]; then
      echo "$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
    fi

  fi
}

# Checks if there are commits ahead from remote
git_prompt_ahead()
{
  if $(echo "$(command git log @{upstream}..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Gets the number of commits ahead from remote
git_commits_ahead()
{
  local commits=''

  if $(echo "$(command git log @{upstream}..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    commits=$(command git log @{upstream}..HEAD \
      | grep '^commit' \
      | wc -l \
      | tr -d ' ')
    echo "${ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX}${commits}${ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX}"
  fi
}

# Formats prompt string for current git commit short SHA
git_prompt_short_sha()
{
  SHA=$(command git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
git_prompt_long_sha()
{
  SHA=$(command git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Get the status of the working tree
git_prompt_status()
{
  local index=$(command git status --porcelain -b 2> /dev/null)
  local status=""

  if $(echo "$index" | grep -E '^\?\? ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_UNTRACKED$status"
  fi

  if $(echo "$index" | grep '^A  ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_ADDED$status"
  elif $(echo "$index" | grep '^M  ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_ADDED$status"
  fi

  if $(echo "$index" | grep '^ M ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_MODIFIED$status"
  elif $(echo "$index" | grep '^AM ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_MODIFIED$status"
  elif $(echo "$index" | grep '^ T ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_MODIFIED$status"
  fi

  if $(echo "$index" | grep '^R  ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_RENAMED$status"
  fi

  if $(echo "$index" | grep '^ D ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_DELETED$status"
  elif $(echo "$index" | grep '^D  ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_DELETED$status"
  elif $(echo "$index" | grep '^AD ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_DELETED$status"
  fi

  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    status="$ZSH_THEME_GIT_PROMPT_STASHED$status"
  fi

  if $(echo "$index" | grep '^UU ' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_UNMERGED$status"
  fi

  if $(echo "$index" | grep '^## .*ahead' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_AHEAD$status"
  fi

  if $(echo "$index" | grep '^## .*behind' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_BEHIND$status"
  fi

  if $(echo "$index" | grep '^## .*diverged' &> /dev/null); then
    status="$ZSH_THEME_GIT_PROMPT_DIVERGED$status"
  fi

  echo $status
}

#compare the provided version of git to the version installed and on path
#prints 1 if input version <= installed version
#prints -1 otherwise
git_compare_version()
{
  local input_git_version=$1;
  local installed_git_version

  input_git_version=(${(s/./)input_git_version});
  installed_git_version=($(command git --version 2>/dev/null));
  installed_git_version=(${(s/./)installed_git_version[3]});

  for i in {1..3}; do
    if [[ $installed_git_version[$i] -lt $input_git_version[$i] ]]; then
      echo -1
      return 0
    fi
  done
  echo 1
}

#this is unlikely to change so make it all statically assigned
POST_1_7_2_GIT=$(git_compare_version "1.7.2")
#clean up the namespace slightly by removing the checker function
unset -f git_compare_version


