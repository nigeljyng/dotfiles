# DO NOT PUT SENSITIVE INFO IN THIS FILE!
#
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/nigel/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zshmarks
)

source $ZSH/oh-my-zsh.sh

prompt_context() {}  # no username in prompt

export PYTHONDONTWRITEBYTECODE=1
eval "$(pyenv virtualenv-init -)"  # pyenv

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

# git aliases
alias gs='git status'
alias gd='git diff -w'
alias gp='git push origin HEAD'  # push the current branch to the same name on the remote
alias gc='git commit'
alias gbr='git branch | grep -v "master" | xargs git branch -D'  # deletes all local branches except master

#-----------------------------------------------------------------------------
# Monzo starter pack additions
#-----------------------------------------------------------------------------
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f $HOME/src/github.com/monzo/starter-pack/zshrc ] && source $HOME/src/github.com/monzo/starter-pack/zshrc
