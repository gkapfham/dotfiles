# Exports {{{

# 256 color mode with bold and italics
export TERM="xterm-256color"

# Character encoding
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# Vim as editor
export EDITOR="nvim"

# Large R history
export R_HISTSIZE="25000"

# BibTeX inputs
export BIBINPUTS=.

# Shell title
export DISABLE_AUTO_TITLE=true

# Set the browser to Firefox
export BROWSER=/usr/bin/firefox

# Path
export PATH="/opt/urserver:/opt/eclipse:/home/gkapfham/.fzf/bin:/home/gkapfham/.local/bin:/home/gkapfham/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# No Java tools
unset JAVA_TOOL_OPTIONS

# Get correct spacing in python virtualenv_prompt_info
export ZSH_THEME_VIRTUALENV_SUFFIX="] "

# }}}

# Aliases {{{

# Vim with a server
alias vim="vim --servername VIM"

# MuPDF resolution
alias mupdf="mupdf -r 288"

# Htop
alias htop="htop -C"

# IPython
alias ipython="ipython --TerminalInteractiveShell.editing_mode=vi"

# Twitter
alias twitter="/usr/local/bin/t"

# }}}

# Oh-My-Zsh and Plugins {{{

# Configuration path
ZSH=$HOME/.oh-my-zsh

# Default theme
ZSH_THEME="norm-gkapfham"

# Timestamps
HIST_STAMPS="mm/dd/yyyy"

# Plugins
plugins=(colored-man-pages git git-extras tmux tmuxinator vi-mode virtualenv)
source /home/gkapfham/.oh-my-zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH/oh-my-zsh.sh

# Git-stacular prompt
source /home/gkapfham/.zsh/zsh-git-prompt/zshrc.sh
GIT_PROMPT_EXECUTABLE="haskell"

# Toggle git cache
function toggle_git() {
    if [ -n "${ZSH_THEME_GIT_PROMPT_CACHE}" ]; then
        unset ZSH_THEME_GIT_PROMPT_CACHE
        echo "Cache  = ✘"
    else
        ZSH_THEME_GIT_PROMPT_CACHE="true"
        echo "Cache  = ✔"
    fi
}
alias tg=toggle_git

# Echo git cache
function echo_git() {
    if [ -n "${ZSH_THEME_GIT_PROMPT_CACHE}" ]; then
        echo "Cache  = ✔"
    else
        echo "Cache  = ✘"
    fi
}
alias eg=echo_git

# Autosuggestions
source /home/gkapfham/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
bindkey '^ ' autosuggest-accept

# }}}

# FASD {{{

# create the FASD cache so that the terminal loads quickly but I still get all of the FASD features
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# }}}

# FZF {{{

# Default options
export FZF_DEFAULT_OPTS='
  --no-bold
  --cycle
  --bind ctrl-f:page-down,ctrl-b:page-up
  --color fg:-1,bg:-1,hl:64,fg+:3,bg+:234,hl+:172
  --color info:110,prompt:110,spinner:109,pointer:172,marker:172
'

# Key bindings
source /home/gkapfham/.fzf/shell/key-bindings.zsh

# Source the files
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Trigger fzf completion using the TAB key instead of **
export FZF_COMPLETION_TRIGGER=';'

# }}}

# Bindkey {{{

# Configure the shell so that it uses jk for escape
bindkey -M viins 'jk' vi-cmd-mode

# }}}

# Tmux {{{

# Display all of the open tmux sessions with fzf
tms() {
  local session
  newsession=${1:-Work}
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0 --cycle) &&
    tmux attach-session -t "$session" || tmux new-session -s $newsession
}

# Display all of the possible tmuxinators with fzf
tmm() {
  session=$( ls -alg ~/.tmuxinator | awk '{print $8}' | cut -d'.' -f1 | sed 1,2d | \
    fzf --query="$1" --select-1 --exit-0 --cycle) &&
    mux "$session"
}

# Display all of the recent directories -- matches search term
t() {
  fasdlist=$( fasd -d -l -r $1 | \
    fzf --query="$1 " --select-1 --exit-0 --height=25% --reverse --tac --no-sort --cycle) &&
    cd "$fasdlist"
}

# Use FZF to filter the output of FASD anywhere is a command
autoload -U modify-current-argument
fzf-fasd-widget() {
  # divide the commands buffer into words
  local words i beginword start
  i=0
  start=1
  beginword=0
  words=("${(z)BUFFER}")
  while (( beginword <= CURSOR )); do
          (( i++ ))
          (( beginword += ${#words[$i]}+1 ))
  done
  # extract the first and current words
  # extract the first letter as a potential trigger
  FIRSTWORD="$words[$start]"
  CURRENTWORD="$words[$i]"
  TRIGGERLETTER=${CURRENTWORD:0:1}
  # the trigger of "," was used, so start
  # the use of FASD and FZF with this word
  if [ "$TRIGGERLETTER" = "," ]; then
    unset 'words[${#words[@]}]'
    PASTWORDS=${words[@]}
    CURRENTWORD="${CURRENTWORD:1:${#CURRENTWORD}}"
    LBUFFER="${PASTWORDS}$(fasd -d -l -r $CURRENTWORD | \
      fzf --query="$CURRENTWORD" --select-1 --exit-0 --height=25% --reverse --tac --no-sort --cycle)"
  # the trigger of "," was not used, so
  # search interactively based on user input
  else
    PASTWORDS=${words[@]}
    CURRENTWORD=""
    LBUFFER="${PASTWORDS} $(fasd -d -l -r $CURRENTWORD | \
      fzf --query="$CURRENTWORD" --select-1 --exit-0 --height=25% --reverse --tac --no-sort --cycle)"
  fi
  # update the prompt with the result of using FASD and FZF
  local ret=$?
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}
# create a binding so that you can type "cd ,pract^B"
# (as an example) to trigger this integrated widget
zle     -N   fzf-fasd-widget
bindkey '^B' fzf-fasd-widget

# }}}

# Commands {{{

usage() {
    du -h --max-depth="${2:-1}"\
      "${1:-.}" |\
        sort -h |\
        sed "s:\./::" |\
        sed "s:$HOME:~:"
}

# }}}

# Travis {{{

[ -f /home/gkapfham/.travis/travis.sh ] && source /home/gkapfham/.travis/travis.sh

# }}}
