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

# Define the theme to use my own derivative of the "norm" theme
ZSH_THEME="norm-gkapfham"

# make it easier to run htop in monochrome mode
alias htop="htop -C"

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
# plugins=(git git-extras gpg-agent ant sudo fasd tmux tmuxinator vi-mode zsh_reload)
plugins=(gpg-agent ant sudo fasd tmux tmuxinator vi-mode zsh_reload)
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

bindkey -M viins 'jk' vi-cmd-mode

# User configuration
export DISABLE_AUTO_TITLE=true

# Set the PATH environment variable for finding programs
export PATH="/opt/urserver:/opt/eclipse:/home/gkapfham/.fzf/bin:/home/gkapfham/.local/bin:/home/gkapfham/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

man() {
  vim -c "SuperMan $*"

  if [ "$?" != "0" ]; then
    echo "No manual entry for $*"
  fi
}

# Configure the autosuggestions plugin that allows command history to display interactively
source /home/gkapfham/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
bindkey '^ ' autosuggest-accept

# FZF {{{

# Default options
export FZF_DEFAULT_OPTS='
  --no-bold
  --bind ctrl-f:page-down,ctrl-b:page-up
  --color fg:-1,bg:-1,hl:64,fg+:3,bg+:234,hl+:172
  --color info:110,prompt:110,spinner:109,pointer:172,marker:172
'

# Key bindings
source /home/gkapfham/.fzf/shell/key-bindings.zsh

# Source the files
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# }}}

# zplug {{{

# # Check if installed
# if [[ ! -d ~/.zplug ]];then
#     git clone https://github.com/zplug/zplug ~/.zplug
# fi

# Initialize zplug
source ~/.zplug/init.zsh

# Declare plugins

zplug "changyuheng/fz", from:github, defer:0
zplug "changyuheng/zsh-interactive-cd", from:github, defer:0
zplug "mafredri/zsh-async", from:github, defer:0
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/git-extras", from:oh-my-zsh
zplug "zdharma/fast-syntax-highlighting", from:github, defer:0
zplug "zsh-users/zsh-autosuggestions", from:github, defer:0

# # Install plugins
# if ! zplug check --verbose; then
#     printf "Install? [y/N]: "
#     if read -q; then
#         echo; zplug install
#     fi
# fi

# Source plugins
zplug load

# }}}
