# run the bash shell in 256 color mode, better for vim!
export TERM="screen-256color"

# exporting the LANG environment variable so that the character coding is correct
export LANG="en_US.UTF8"

# say that I will always use vim when the operating system calls for an editor
export EDITOR="vim"

# always run vim with the internal server as it help for running R and Tmux
alias vim="vim --servername VIM"

# always run mupdf at the largest possible size that it supports; this is not
# really big enough for a HIDPI screen but it is pretty good overall
alias mupdf="mupdf -r 288"

# setting the R history size to be a very large value
export R_HISTSIZE="25000"

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="norm-gkapfham"

# Make it faster to load the todo.txt file used for my todo list.
alias vt="vim ~/working/todo/todo.txt"
alias gvt="gvim ~/working/todo/todo.txt"

# make it easier to run htop in monochrome mode
alias htop="htop -C"

# create an alias that allows for loading a large fill screen terminal designed for text editing
alias mt="gnome-terminal --profile=Vim  --working-directory=$PWD --maximize"

# create an alias that runs the hubic sync program
# alias hs="hubic synchronize"

# bindkey '^k' up-line-or-beginning-search
# bindkey '^j' down-line-or-beginning-search
# autoload -U history-search-end

# # zle -N history-beginning-search-backward-end history-search-end
# # zle -N history-beginning-search-forward-end history-search-end
# #
# bindkey "\e[A" history-beginning-search-backward-end
# bindkey "\e[B" history-beginning-search-forward-end
#
# Note that you can use CTRL-R and CTRL-S to do this if not using vi-mode

# bindkey "^R" history-incremental-search-backward
# bindkey "^[[A" history-search-backward
# bindkey "^[[B" history-search-forward

# Uncomment following line if you want red dots to be displayed while waiting for completion
# And, make sure that you rebind the tab key so that this feature does not conflict with vi-mode
COMPLETION_WAITING_DOTS="true"
bindkey "^I" expand-or-complete-with-dots

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git git-extras ant sudo vundle zsh-syntax-highlighting fasd tmux tmuxinator ubuntu vi-mode zsh_reload)
. /home/gkapfham/.oh-my-zsh/plugins/z/z.sh
source $ZSH/oh-my-zsh.sh

# load the special plugin that is needed to create the git-stacular prompt showing status
source ~/.zsh/git-prompt/zshrc.sh

# create the FASD cache so that the terminal loads quickly but I still get all of the FASD features
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# unset the option of Java tools, avoiding the strange debugging message in Ubuntu 15.04
unset JAVA_TOOL_OPTIONS

# Adding these lines of code enables the searching of partially completed commands with the arrow keys
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search
autoload -U history-search-end
bindkey "^k" history-incremental-search-backward
bindkey "^j" history-incremental-search-backward

# this was the first way that I tried to load fasd and it works, but it might be a little too slow
# eval "$(fasd --init auto)"
# bindkey '^k' up-line-or-beginning-search
# bindkey '^k' up-line-or-beginning-search
# bindkey '^j' down-line-or-beginning-search
# autoload -U history-search-end
# bindkey '^j' down-line-or-beginning-search
# autoload -U history-search-end

# allow for the editing of the command-line in vim by pressing the "v" key in the terminal window
# export KEYTIMEOUT=1
# autoload edit-command-line
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line

# User configuration
export DISABLE_AUTO_TITLE=true

export PATH="/opt/eclipse:/home/gkapfham/working/software/TweetComplete/run:/usr/local/texlive/2011/bin/i386-linux:/opt/processing-1.2.1:/home/gkapfham/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

man() {
  vim -c "SuperMan $*"

  if [ "$?" != "0" ]; then
    echo "No manual entry for $*"
  fi
}
