#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#

GREP_OPTIONS="--color=auto"

# avoid VCS folders (if the necessary grep flags are available)
grepFlagAvailable()
{
  echo | grep $1 "" >/dev/null 2>&1
}

if grepFlagAvailable --exclude-dir=.cvs; then
  for pattern in .cvs .git .hg .svn; do
    GREP_OPTIONS+=" --exclude-dir=$PATTERN"
  done
elif grepFlagAvailable --exclude=.cvs; then
  for pattern in .cvs .git .hg .svn; do
    GREP_OPTIONS+=" --exclude=$PATTERN"
  done
fi

unset pattern
unset -f grepFlagAvailable

export GREP_OPTIONS="$GREP_OPTIONS"
export GREP_COLOR='1;32'
