# Benchmarking {{{

# Uncomment to enable
# zmodload zsh/zprof

# }}}

# Reminders {{{

# Navigation Summary:
#
# cd <ctrl>-t        means "change to directory resulting from ...
#                           search from HOME directory using fd and fzf"
#
# cd **; <tab>       means "change to directory resulting from ...
#                           search from CURRENT directory using only fzf"
#
# <alt>-c            means "change to directory resulting from ...
#                           search from CURRENT directory with fzf"
#
# cd ,paper <ctrl>-b means "change to directory resulting from ...
#                           search through recent directories with fzf and fasd"
#
# }}}

# External Plugins {{{

#  gkapfham  ~/.zsh exa --long --header --git --classify --all
# Permissions Size User     Date Modified Name
# drwxrwxr-x     - gkapfham  7 Mar 14:15  fzf-tab/
# drwxrwxr-x     - gkapfham  7 Mar 14:15  gitstatus/
# drwxrwxr-x     - gkapfham  7 Mar 14:15  zsh-autosuggestions/
# drwxrwxr-x     - gkapfham  7 Mar 14:15  zsh-git-prompt/
# drwxrwxr-x     - gkapfham  7 Mar 14:15  zsh-syntax-highlighting/

# NOTES:
# -- zsh-git-prompt is heavily modified
# -- gitstatus is heavily modified
# -- zsh-git-prompt is deprecated for gitstatus

# Exports {{{

# Redefine the LS_COLORS so that:
# --> directories are not displayed as bold
export LS_COLORS="rs=0:di=0;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"

# Define the EXA_COLORS so that:
# --> user name is not displayed as bold
# --> group name is not displayed as bold
# --> read bit for user is not displayed as bold
# --> write bit for user is not displayed as bold
export EXA_COLORS="uu=0;33:gu=0;33:ur=0;33:uw=0;31"

# 256 color mode with bold and italics
# NOTE: Use of tmux-256color does not
# correctly set the title of terminal
export TERM="xterm-256color"

# Character encoding
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# NeoVim as editor
export EDITOR="nvim"

# Large R history
export R_HISTSIZE="25000"

# BibTeX inputs
export BIBINPUTS=.

# Shell title
export DISABLE_AUTO_TITLE=true

# Set the browser to Google Chrome
export BROWSER=/usr/bin/google-chrome

# Path
export PATH="/opt/urserver:/opt/eclipse:$HOME/.npm-global/bin:$HOME/.fzf/bin:$HOME/.local/bin:$HOME/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.local/kitty.app/bin:$HOME/.cargo/bin"

# Local Gem home
export GEM_HOME=$HOME/.gem

# Local Go program home
export GOPATH=$HOME/.gocode

# No Java tools
unset JAVA_TOOL_OPTIONS

# Get correct spacing in python virtualenv_prompt_info
export ZSH_THEME_VIRTUALENV_SUFFIX="] "

# Define a marker to display of a "partial line"
# Normally shown as a "%"
# May appear when using Tmuxinator to start tmux
export PROMPT_EOL_MARK='    '

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

# Npm without non-Ubuntu packages
alias npm="npm --no-optional"

# Bat with a special color scheme
alias bat="bat --theme=\"Tomorrow Night\""

# More and cat are aliased to bat
alias more="bat"
alias cat="bat"

# Directory listing with a simple command
alias ka="exa --group-directories-first --grid --long --sort=name"

# Use git through the hub interface
# Note that this does not change git's behavior
alias git="hub"

# Markdown pull request with hub
alias hubmdpr="hub -c core.commentChar='%' pull-request"

# Markdown issue with hub
alias hubmdis="hub -c core.commentChar='%' issue create"

# Reusable format strings for git aliases
GIT_PRETTY_FORMAT_AUTHOR="--pretty=\"%C(bold green)%h%Creset %C(yellow)%an%Creset%C(auto)%d%Creset %s\""

# Display colorize git output in blocks
alias gls="git slog"

# Display a colorized git log with authors in a graph
alias gla="git log --graph $GIT_PRETTY_FORMAT_AUTHOR"

# Display a colorized git log with all references and authors
alias glaa='gla --all'

# }}}

# Oh-My-Zsh and Plugin {{{

# Save startup time by disabling
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

# Configuration path
ZSH=$HOME/.oh-my-zsh

# Default theme
ZSH_THEME="norm-gkapfham"

# Timestamps
HIST_STAMPS="mm/dd/yyyy"

# Plugin: was fast-syntax-highlighting
# Plugin: now zsh-syntax-highlighting
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Plugin: Request all plugins from oh-my-zsh
plugins=(colored-man-pages git git-extras shrink-path tmux tmuxinator vi-mode virtualenv)

# Load customized oh-my-zsh script
source $HOME/.oh-my-zsh.sh

# Plugin: Fast, git-stacular prompt with gitstatus
# Note: local modifications to this plugin
source ~/.zsh/gitstatus/gitstatus.prompt.zsh

# source $HOME/.zsh/zsh-git-prompt/zshrc.sh
# GIT_PROMPT_EXECUTABLE="haskell"

# Plugin: fzf-tab
# Note: must be sourced after all other plugins to ensure
# that tab-completion binds to it and not to oh-my-zsh method
source $HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh

# Define the default fzf command used by fzf-tab
# Note: colors defined here because this plugin
# does not adopt the standard colors for fzf
# as defined later in this file
FZF_TAB_COMMAND=(
    fzf
    --ansi
    --expect='$continuous_trigger'
    --color='fg:#a9a9a9,bg:#1c1c1c,hl:#5f8700'
    --color='fg+:#afaf5f,bg+:#1c1c1c,hl+:#d78700'
    --color='info:#87afd7,prompt:#87afd7,pointer:#d78700'
    --color='marker:#d78700,spinner:#875f87,header:#875f87'
    --nth=2,3 --delimiter='\x00'
    --layout=reverse --height='${FZF_TMUX_HEIGHT:=75%}'
    --tiebreak=begin -m --bind=tab:down,ctrl-j:accept,change:top,ctrl-space:toggle --cycle
    '--query=$query'
    '--header-lines=$#headers'
)
zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND

# Plugin: zsh-autosuggestions
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
bindkey '^ ' autosuggest-accept

# # Toggle git cache
# function toggle_git() {
#     if [ -n "${ZSH_THEME_GIT_PROMPT_CACHE}" ]; then
#         unset ZSH_THEME_GIT_PROMPT_CACHE
#         echo "Cache  = ✘"
#     else
#         ZSH_THEME_GIT_PROMPT_CACHE="true"
#         echo "Cache  = ✔"
#     fi
# }
# alias tg=toggle_git

# # Echo git cache
# function echo_git() {
#     if [ -n "${ZSH_THEME_GIT_PROMPT_CACHE}" ]; then
#         echo "Cache  = ✔"
#     else
#         echo "Cache  = ✘"
#     fi
# }
# alias eg=echo_git

# }}}

# FASD {{{

# create the FASD cache so that the terminal loads quickly
# but I still get all of the FASD features
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

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
# Create a binding so that you can type "cd ,pract^B"
# (as an example) to trigger this integrated widget
zle     -N   fzf-fasd-widget
bindkey '^B' fzf-fasd-widget

# }}}

# FZF {{{

# Match the vim-vitamin-onec colorscheme
# https://github.com/gkapfham/vim-vitamin-onec
export FZF_DEFAULT_OPTS='
  --no-bold
  --cycle
  --bind ctrl-f:page-down,ctrl-b:page-up
  --color=fg:#a9a9a9,bg:#1c1c1c,hl:#5f8700
  --color=fg+:#afaf5f,bg+:#1c1c1c,hl+:#d78700
  --color=info:#87afd7,prompt:#87afd7,pointer:#d78700
  --color=marker:#d78700,spinner:#875f87,header:#875f87'

# Same colorscheme but in 256 colors,
# note that this does not use the HTML color
# codes and instead uses those available at:
# https://jonasjacek.github.io/colors/
#   export FZF_DEFAULT_OPTS='
#   --no-bold
#   --cycle
#   --bind ctrl-f:page-down,ctrl-b:page-up
#   --color=fg:243,bg:234,hl:64
#   --color=fg+:143,bg+:234,hl+:172
#   --color=info:110,prompt:110,pointer:172
#   --color=marker:172,spinner:96,header:96'

FZF_TAB_OPTS=(
    --ansi   # Enable ANSI color support, necessary for showing groups
    --expect='$FZF_TAB_CONTINUOUS_TRIGGER' # For continuous completion
    # '--color=hl:$(( $#headers == 0 ? 108 : 255 ))'
    --nth=2,3 --delimiter='\0'  # Don't search FZF_TAB_PREFIX
    --layout=reverse --height='${FZF_TMUX_HEIGHT:=75%}'
    --tiebreak=begin -m --bind=tab:down,ctrl-j:accept,change:top,ctrl-space:toggle --cycle
    '--query=$query'   # $query will be expanded to query string at runtime.
    '--header-lines=$#headers' # $#headers will be expanded to lines of headers at runtime
)

# Setup fzf, its auto-completions, and key bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Trigger fzf completion using the semi-colon key instead of **
export FZF_COMPLETION_TRIGGER=';'

# Configure fzf to work with fast-finder called fd
export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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
  # NOTE: Use the /bin/ls command since "ls" is now aliased to use "exa" command
  session=$( /bin/ls -alg ~/.tmuxinator | awk '{print $8}' | cut -d'.' -f1 | sed 1,2d | \
    fzf --query="$1" --select-1 --exit-0 --cycle) &&
    mux "$session"
}

# Display all of the recent directories -- matches search term
t() {
  fasdlist=$( fasd -d -l -r $1 | \
    fzf --query="$1 " --select-1 --exit-0 --height=25% --reverse --tac --no-sort --cycle) &&
    cd "$fasdlist"
}

# Define the name of a tmux pane, display in the status-right
function workspace {
  readonly name=${1:?"Specify the name of the workspace."}
  tmux select-pane -T $name
}

# }}}

# Travis {{{

# Lazy load completion of travis command after first call
# Note that this reduces startup time for a shell at the
# cost of making travis not available until run first time
travis() {
  unfunction "$0"
  [ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh
  travis "$@"
}

# }}}

# Pyenv {{{

# Lazy load completion of pyenv command after first call
# Note that this reduces startup time for a shell at the
# cost of making pyenv not available until run first time
export PATH="$HOME/.pyenv/bin:$PATH"
pyenv() {
  unfunction "$0"
  eval "$(command pyenv init -)"
  eval "$(command pyenv virtualenv-init -)"
  pyenv "$@"
}

# }}}

# Pipenv {{{

# Ensure that Pipenv can find the version of Python
# that is managed by the Pyenv tool
export PIPENV_PYTHON="$HOME/.pyenv/shims/python"

# }}}

# User Commands {{{

# Display disk usage in a friendly manner
usage() {
    du -h --max-depth="${2:-1}"\
      "${1:-.}" |\
        sort -h |\
        sed "s:\./::" |\
        sed "s:$HOME:~:"
}

# Run a benchmark for zsh startup time
benchmark() {
    for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
}

# Store the ssh passphrase for easy git use
secure() {
    /usr/bin/ssh-add -t 432000
}

# Always display directory contents after a change of directory
function chpwd() {
  emulate -L zsh
  exa --group-directories-first --grid --long --sort=name
}

# Display the palette of the 256 colors used in terminal
palette() {
    local -a colors
    for i in {000..255}; do
        colors+=("%F{$i}$i%f")
    done
    print -cP $colors
}

# }}}

# Redefine Aliases {{{

# Already defined in oh-my-zsh, redefine to use exa
alias ls="exa --color=always"

# }}}

# Benchmarking {{{

# Uncomment to enable
# zprof

# }}}
