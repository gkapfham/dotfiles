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

# ﰌ gkapfham  ~/.zsh exa --long --header --git --classify --all
# Permissions Size User     Date Modified Name
# drwxrwxr-x     - gkapfham  8 Mar 20:20  fast-syntax-highlighting/
# drwxrwxr-x     - gkapfham  8 Mar 20:20  fzf-tab/
# drwxrwxr-x     - gkapfham  8 Mar 20:20  gitstatus/
# drwxrwxr-x     - gkapfham  8 Mar 20:20  zsh-autosuggestions/
# drwxrwxr-x     - gkapfham  8 Mar 20:20  zsh-git-prompt/
# drwxrwxr-x     - gkapfham  8 Mar 20:20  zsh-syntax-highlighting/

# NOTES:
# -- forked zsh-git-prompt is heavily modified
# -- forked gitstatus is heavily modified
# -- zsh-git-prompt is deprecated for gitstatus
# -- both fast-syntax-highlighting and zsh-syntax-highlighting
# are currently available, but the former is in current use

# Exports {{{

# Define the shell to always be zsh
export SHELL="/usr/sbin/zsh"

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

# indicate support for 24-bit true-color
# which is supported by neovim and pastel
export COLORTERM='truecolor'

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

# Set the browser to Firefox
export BROWSER=/usr/bin/firefox

# Path
# Strategy: place user-local binaries before system ones
# Includes setup for:
# --> Fuzzy finding with fzf
# --> Local binaries
# --> JavaScript npm
# --> Rust with cargo
# --> Go with .gocode
# --> Poetry with .poetry
export PATH="$HOME/.fzf/bin:$HOME/.local/bin:$HOME/bin:$HOME/.npm-global/bin::$HOME/.cargo/bin:$HOME/.gocode/bin:$HOME/.poetry/bin:/usr/bin/vendor_perl/:/usr/lib/lightdm/lightdm:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:"

# Add the bin directory for Ruby gems to the Path
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"

# Local pyenv home
export PYENV_ROOT="$HOME/.pyenv"

# Local Gem home
export GEM_HOME=$HOME/.gem

# No warning messages in Ruby
export RUBYOPT='-W0'

# Local Go program home
export GOPATH=$HOME/.gocode

# No Java tools
unset JAVA_TOOL_OPTIONS

# No color formatting with pre-commit
export PRE_COMMIT_COLOR='never'

# Get correct spacing in python virtualenv_prompt_info
export ZSH_THEME_VIRTUALENV_SUFFIX="] "

# Define a marker to display of a "partial line"
# Normally shown as a "%"
# May appear when using Tmuxinator to start tmux
export PROMPT_EOL_MARK='    '

# Define the TERMINAL variable for i3 window manager,
# which consults this for running the i3-sensible-terminal
export TERMINAL='alacritty'

# Configure bat to use a matching theme
export BAT_THEME='Vitamin-Onec'

# }}}

# System Aliases {{{

# MuPDF resolution
alias mupdf="mupdf -r 288"

# Htop
alias htop="htop -C"

# IPython
alias ipython="ipython --TerminalInteractiveShell.editing_mode=vi"

# Npm without non-Ubuntu packages
alias npm="npm --no-optional"

# More and cat are aliased to bat
alias more="bat"
alias cat="bat"

# Directory listing with a simple command
alias ka="exa --group-directories-first --grid --long --sort=name"

# Always run pacman as root
alias pacman="sudo pacman"

# }}}

# Git Aliases {{{

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

# Define functions and an alias for switching between git branches
# https://polothy.github.io/post/2019-08-19-fzf-git-checkout/
fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return
    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 75% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

# Run git checkout and call the previous function
# for display details about the branch
fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return
    local branch
    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi
    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchname --track origin/branchname
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}

# Define an alias that uses fzf to select git branches
alias gcob='fzf-git-checkout'

# }}}

# Oh-My-Zsh and Zsh Plugins/Scripts {{{

# Save startup time by disabling
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

# Configuration path
ZSH=$HOME/.oh-my-zsh

# Default theme
ZSH_THEME="vitamin-onec"

# Timestamps
HIST_STAMPS="mm/dd/yyyy"

# Use the zsh-defer to ensure that the
# sourcing of select scripts happens in the
# background, thus decreasing shell startup time
# source ~/.zsh/zsh-defer/zsh-defer.plugin.zsh

# NOTE: use this plugin as a backup in case alternate is unavailable
# Plugin: zsh-syntax-highlighting
# source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Plugin: fast-syntax-highlighting
# zsh-defer source $HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Plugin: Request all plugins from oh-my-zsh
# NOTE: these are all loaded in the .oh-my-zsh.sh script
# and some of these could be loaded through zsh-defer.
# However, not all of them work with zsh-defer and thus
# right now I am trading the extra startup cost for simplicity.
plugins=(colored-man-pages git git-extras shrink-path tmux tmuxinator vi-mode virtualenv)

# Reload all of the completion modules before
# sourcing the specialized Oh-My-Zsh script
# NOTE: this is needed to avoid errors
# shell startup and after typing each command
autoload -Uz compinit && compinit

# Load customized oh-my-zsh script
source $HOME/.oh-my-zsh.sh

# # Load the shrink-path plugin used in the prompt because
# # it cannot be loaded by zsh-defer source without error
# source $HOME/.oh-my-zsh/plugins/shrink-path/shrink-path.plugin.zsh

# # Load the vi-mode plugin used in the prompt because
# # it cannot be loaded by zsh-defer source without error
# source $HOME/.oh-my-zsh/plugins/vi-mode/vi-mode.plugin.zsh

# Plugin: Fast, git-stacular prompt with gitstatus
# Note: local modifications to this plugin
source $HOME/.zsh/gitstatus/gitstatus.prompt.zsh

# Plugin: fzf-tab
# Note: must be sourced after all other plugins to ensure
# that tab-completion binds to it and not to oh-my-zsh method
# zsh-defer source $HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh
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

# }}}

# FASD {{{

# create the FASD cache so that the terminal loads quickly
# but I still get all of the FASD features
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
# zsh-defer source "$fasd_cache"
source "$fasd_cache"
unset fasd_cache

# Use FZF to filter the output of FASD anywhere it is a command
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
# Color scheme: https://github.com/gkapfham/vim-vitamin-onec
# 256 Color reference: https://jonasjacek.github.io/colors/
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

# Set completion options for the fzf-tab script that
# supports tab completion with fzf in the shell
FZF_TAB_OPTS=(
    --ansi
    --expect='$FZF_TAB_CONTINUOUS_TRIGGER'
    --nth=2,3 --delimiter='\0'
    --layout=reverse --height='${FZF_TMUX_HEIGHT:=75%}'
    --tiebreak=begin -m --bind=tab:down,ctrl-j:accept,change:top,ctrl-space:toggle --cycle
    '--query=$query'
    '--header-lines=$#headers'
)

# Setup fzf, its auto-completions, and key bindings
# [ -f ~/.fzf.zsh ] && zsh-defer source ~/.fzf.zsh
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
  # NOTE: Use the /usr/sbin/ls command since "ls" is now aliased to use "exa" command
  session=$( /usr/sbin/ls -alg ~/.tmuxinator | awk '{print $8}' | cut -d'.' -f1 | sed 1,2d | \
    fzf --query="$1" --select-1 --exit-0 --cycle) &&
    tmuxinator "$session"
}

# Define the name of a tmux pane, display in the status-right
function workspace {
  readonly name=${1:?"Specify the name of the workspace."}
  tmux select-pane -T $name
}

# }}}

# Pyenv {{{

export PATH="$HOME/.pyenv/bin:$PATH"
# zsh-defer eval "$(command pyenv init - zsh --no-rehash)"
eval "$(command pyenv init - zsh --no-rehash)"

# }}}

# Pipenv {{{

# Ensure that Pipenv can find the version of Python
# that is managed by the Pyenv tool
export PIPENV_PYTHON="$HOME/.pyenv/shims/python"

# }}}

# Perl {{{

# Ensure that the user-install version of cpanm is
# available to neovim, enabling health checks to pass
if (command -v perl && command -v cpanm) >/dev/null 2>&1; then
  test -d "$HOME/perl5/lib/perl5" && eval $(perl -I "$HOME/perl5/lib/perl5" -Mlocal::lib)
fi

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

# Connect to the external monitor
function connect-external-monitor() {
  xrandr --output DP3 --above eDP1 --auto
}

# }}}

# Redefine Aliases {{{

# Already defined in oh-my-zsh, redefine to use exa
alias ls="exa --color=always"

# }}}

if [ -n "${NVIM_LISTEN_ADDRESS+x}" ]; then
  export COLORTERM="truecolor"
fi

# Benchmarking {{{

# Uncomment to enable
# zprof

# }}}
