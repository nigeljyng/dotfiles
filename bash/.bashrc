# Note: Make sure you update bash to version 4.x using brew! Run `brew install bash`

#-----------------------------------------------------------------------------
# aliases
#-----------------------------------------------------------------------------
alias mvim='mvim --remote-silent' # Open in mvim remote by default
alias tmux="TERM=screen-256color-bce tmux"  # colourful tmux!
alias o='open .'  # open current directory
alias ls='ls -GFh'
alias todo='grep "TODO" -rin > TODO.txt *'
alias rmds='find . -name '.DS_Store' -type f -delete'  # remove .DS_Store
alias cf1='caffeinate -t 3600 &'  # caffeinate for an hour
alias cf2='caffeinate -t 7200 &'  # caffeinate for two hours
alias jupyter_notebook='jupyter notebook > /dev/null 2>&1'  # no output
eval $(thefuck --alias fuck)

#-----------------------------------------------------------------------------
# General shell settings
#-----------------------------------------------------------------------------
# colors
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# How much history to save
HISTFILESIZE=2000
SHELL_SESSION_HISTORY=0  # Don't save bash sessions

# Ignore duplicates in history (makes navigating faster)
export HISTCONTROL=ignoreboth:erasedups

# colourful tabs!
if [ -f ~/Documents/iterm2_rainbow_tabs/iterm2_rainbow_tabs.sh ];
 then . ~/Documents/iterm2_rainbow_tabs/iterm2_rainbow_tabs.sh
fi

# git aware prompt
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
export PS1="\[\033[36m\]\W \[\033[33;1m\]\$git_branch\[\033[33;1m\]\$git_dirty\[$txtrst\]\$ "

# Bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

# git completion
source ~/.git-completion.bash

# automatic yubikey integration
eval "$(monzo-yubi shellinit)"
yubi init > /dev/null

#-----------------------------------------------------------------------------
# Colorized man pages
#-----------------------------------------------------------------------------
man() {
    	env \
    		LESS_TERMCAP_mb=$(printf "\x1b[38;2;255;200;200m") \
    		LESS_TERMCAP_md=$(printf "\x1b[38;2;255;100;200m") \
    		LESS_TERMCAP_me=$(printf "\x1b[0m") \
    		LESS_TERMCAP_so=$(printf "\x1b[38;2;60;90;90;48;2;40;40;40m") \
    		LESS_TERMCAP_se=$(printf "\x1b[0m") \
    		LESS_TERMCAP_us=$(printf "\x1b[38;2;150;100;200m") \
    		LESS_TERMCAP_ue=$(printf "\x1b[0m") \
    		man "$@"
    }

#-----------------------------------------------------------------------------
# transfer.sh 
#-----------------------------------------------------------------------------
transfer() { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }

#-----------------------------------------------------------------------------
# Apparix (bookmarking directories)
#-----------------------------------------------------------------------------
function to () {
  if test "$2"; then
    cd "$(apparix --try-current-first -favour rOl "$1" "$2" || echo .)"
  elif test "$1"; then
    if test "$1" == '-'; then
      cd -
    else
      cd "$(apparix --try-current-first -favour rOl "$1" || echo .)"
    fi
  else
    cd $HOME
  fi
}
function bm () {
  if test "$2"; then
    apparix --add-mark "$1" "$2";
  elif test "$1"; then
    apparix --add-mark "$1";
  else
    apparix --add-mark;
  fi
}
function portal () {
  if test "$1"; then
    apparix --add-portal "$1";
  else
    apparix --add-portal;
  fi
}
# function to generate list of completions from .apparixrc
function _apparix_aliases ()
{ cur=$2
  dir=$3
  COMPREPLY=()
  nullglobsa=$(shopt -p nullglob)
  shopt -s nullglob
  if let $(($COMP_CWORD == 1)); then
    # now cur=<apparix mark> (completing on this) and dir='to'
    # Below will not complete on subdirectories. swap if so desired.
    # COMPREPLY=( $( cat $HOME/.apparix{rc,expand} | grep "j,.*$cur.*," | cut -f2 -d, ) )
    COMPREPLY=( $( (cat $HOME/.apparix{rc,expand} | grep "\<j," | cut -f2 -d, ; ls -1p | grep '/$' | tr -d /) | grep "\<$cur.*" ) )
  else
    # now dir=<apparix mark> and cur=<subdirectory-of-mark> (completing on this)
    dir=`apparix --try-current-first -favour rOl $dir 2>/dev/null` || return 0
    eval_compreply="COMPREPLY=( $(
      cd "$dir"
      \ls -d $cur* | while read r
      do
        [[ -d "$r" ]] &&
        [[ $r == *$cur* ]] &&
          echo \"${r// /\\ }\"
      done
    ) )"
  eval $eval_compreply
  fi
  $nullglobsa
  return 0
}
# command to register the above to expand when the 'to' command's args are
# being expanded
complete -F _apparix_aliases to
