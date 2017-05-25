# Exports {{{

# 256 color mode
export TERM="screen-256color"

# Character encoding
export LANG="en_US.UTF8"

# Vim as editor
export EDITOR="vim"

# Large R history
export R_HISTSIZE="25000"

# Shell title
export DISABLE_AUTO_TITLE=true

# Path
export PATH="/opt/urserver:/opt/eclipse:/home/gkapfham/.fzf/bin:/home/gkapfham/.local/bin:/home/gkapfham/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/gkapfham/.git-radar/"

# No Java tools
unset JAVA_TOOL_OPTIONS

# }}}

# Aliases {{{

# Vim with a server
alias vim="vim --servername VIM"

# MuPDF resolution
alias mupdf="mupdf -r 288"

# Htop
alias htop="htop -C"

# }}}

# Oh-My-Zsh and Plugins {{{

# Configuration path
ZSH=$HOME/.oh-my-zsh

# Default theme
ZSH_THEME="norm-gkapfham"

# Timestamps
HIST_STAMPS="mm/dd/yyyy"

# Plugins
# plugins=(git git-extras gpg-agent ant sudo fasd tmux tmuxinator vi-mode zsh_reload)
plugins=(colored-man-pages fasd git git-extras tmux tmuxinator vi-mode )
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

# Z command for jumping
source /home/gkapfham/.oh-my-zsh/plugins/z/z.sh

# FZF in the shell
# source /home/gkapfham/.zsh/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
source /home/gkapfham/.zsh/fz/fz.plugin.zsh

# Autosuggestions
source /home/gkapfham/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
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
  --bind ctrl-f:page-down,ctrl-b:page-up
  --color fg:-1,bg:-1,hl:64,fg+:3,bg+:234,hl+:172
  --color info:110,prompt:110,spinner:109,pointer:172,marker:172
'

# Key bindings
source /home/gkapfham/.fzf/shell/key-bindings.zsh

# Source the files
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# }}}

# Bindkey {{{

bindkey -M viins 'jk' vi-cmd-mode

# }}}
#

# Tmux {{{

# Display all of the open tmux sessions with fzf
tms() {
  local session
  newsession=${1:-Work}
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
    tmux attach-session -t "$session" || tmux new-session -s $newsession
}

# Display all of the possible tmuxinators with fzf
tmm() {
  session=$( ls -alg ~/.tmuxinator | awk '{print $8}' | cut -d'.' -f1 | sed 1,2d | \
    fzf --query="$1" --select-1 --exit-0) &&
    mux "$session"
}

# }}}
