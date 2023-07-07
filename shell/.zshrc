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

# Neovim as editor
export EDITOR="nvim"

# Large R history
export R_HISTSIZE="25000"

# BibTeX inputs
export BIBINPUTS=.

# Shell title
export DISABLE_AUTO_TITLE=true

# Set the browser to Brave
export BROWSER=/usr/sbin/brave

# Path
# Strategy: place user-local binaries before system ones
# Includes setup for:
# --> Contained Python with pipx
# --> Fuzzy finding with fzf
# --> Local binaries
# --> JavaScript npm
# --> Rust with cargo
# --> Go with .gocode
export PATH="$HOME/.local/pipx/bin:$HOME/.fzf/bin:$HOME/.local/bin:$HOME/bin:$HOME/.npm-global/bin::$HOME/.cargo/bin:$HOME/.gocode/bin:$HOME/.poetry/bin:/usr/bin/vendor_perl/:/usr/lib/lightdm/lightdm:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:"

# Add the bin directory for Ruby gems to the Path
# --> Ruby gems as managed by Ruby installed by operating system
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
# --> Ruby gems as managed by Ruby installed by asdf-vm
export PATH="$HOME/.gem/bin:$PATH"

# Local Poetry home
export POETRY_HOME=$HOME/.poetry

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

# Define the pager used for manual pages to be Neovim,
# making it possible to then use "gO" to populate and load the
# location list and then navigate the sections in the man page.
# Note that after population of the location list it is possible
# to view sections again by using <Leader>c instead of "gO".
export MANPAGER='nvim +Man!'

# Configure bat to use a matching theme
export BAT_THEME='Vitamin-Onec'

# Configure less to use lesspipe.sh so that it is possible
# to perform conversion of files to plaintext. For instance,
# using "less file.pdf" will now file.pdf's text in the terminal
export LESSOPEN="|lesspipe.sh %s"

# Configure pipx to install itself and other managed
# Python programs to a directory only for pipx. Note
# that this ensures that pipx and other programs are
# not installed to ~./local/bin/ which is a directory
# that the Makefile in this repository overwrites
export PIPX_BIN_DIR="$HOME/.local/pipx/bin"

# Set the home for the pipx program, using the default
# value that would be used without setting here. Note
# that setting this variable makes the default explicit.
export PIPX_HOME="$HOME/.local/pipx"

# }}}

# System Aliases {{{

# alias kitty="kitty --single-instance"

# MuPDF resolution
alias mupdf="mupdf -r 288"

# Htop
alias htop="htop -C"

# IPython
alias ipython="ipython --TerminalInteractiveShell.editing_mode=vi"

# More and cat are aliased to bat
alias more="bat"
alias cat="bat"

# Directory listing with a simple command
alias ka="exa --group-directories-first --grid --long --sort=name"

# Use the exa command to display a tree,
# ensuring better color scheme
alias tree="exa --tree --level=2 --long --icons"

# Always run pacman as root
alias pacman="sudo pacman"

# Alias to search for packages in yay (which includes non-AUR)
# and 1) then display details about the package in an fzf preview and
# 2) display the details about the package in shell after selection
alias yaysearch="yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -Si"

# Alias the go-t command to t
alias t="go-t"

# Alias to correct a mistaken command
# in the .zsh_history file with hist
alias fix="hist fix -1"

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

# Define a function to support checking out local branches
fzf-git-branch-simple() {
  git branch --sort=-committerdate |
        grep -v HEAD |
        fzf --height 75% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

# Run git checkout and call the previous function
# for display details about the branch; this works
# for local and remote branches but right now is
# only using the "simple" function with local branches
fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return
    local branch
    branch=$(fzf-git-branch-simple)
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

# Quickly checkout a branch based on its diff
fzf-git-branch-diff() {
  git branch --sort=-committerdate | fzf --preview "git diff --color=always {1}" | xargs git checkout
}

# Define aliases that use fzf to select git branches
alias ffgb='fzf-git-checkout'
alias ffgbd='fzf-git-branch-diff'

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

# NOTE: use this plugin as a backup in case alternate is unavailable
# Plugin: zsh-syntax-highlighting
# source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Plugin: modify and query the zsh history
source $HOME/.zsh/zsh-hist/zsh-hist.plugin.zsh

# Plugin: fast-syntax-highlighting
source $HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Plugin: zsh-vi-mode
source $HOME/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Plugin: Request all plugins from oh-my-zsh
#
# NOTE: these are all loaded in the .oh-my-zsh.sh script
# and some of these could be loaded through zsh-defer.
#
# However, not all of them work with zsh-defer and some
# benchmarking suggests that there is not any/much improvement
# in performance. As such, they are all being included here!
plugins=(git git-extras shrink-path tmux tmuxinator virtualenv)

# Reload all of the completion modules before
# sourcing the specialized Oh-My-Zsh script
# NOTE: this is needed to avoid errors
# shell startup and after typing each command
autoload -Uz compinit && compinit

# Load customized oh-my-zsh script
source $HOME/.oh-my-zsh.sh

# Plugin: Fast, git-stacular prompt with gitstatus
# Note: local modifications to this plugin
source $HOME/.zsh/gitstatus/gitstatus.prompt.zsh

# Plugin: fzf-tab
# Note: must be sourced after all other plugins to ensure
# that tab-completion binds to it and not to oh-my-zsh method
source $HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh

# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# Set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Preview directory's content with exa when completing cd,
# thereby showing a preview window with Fzf to the right
# of the cd command that shows the contents of current directory
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always --icons $realpath'

# Preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap --color='fg:#8a8a8a,bg:#1c1c1c,hl:#5f8700' --color='fg+:#afaf5f,bg+:#1c1c1c,hl+:#d78700' --color='info:#87afd7,prompt:#87afd7,pointer:#d78700' --color='marker:#d78700,spinner:#875f87,header:#875f87'

# Preview the status of different daemons controlled by systemctl
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# Preview the contents of environment variables
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# Preview the search for commands or use information for commands
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
  ¦ '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'

# Switch group using `,` and `.` (note that different
# groups might include different types of branches when
# tab completing a git checkout command)
zstyle ':fzf-tab:*' switch-group ',' '.'

# Set the default color to be the color 245 out of
# the 256 colors available in the terminal window the color 245 out of
# the 256 colors available in the terminal window
zstyle ':fzf-tab:*' default-color $'\033[38;5;245m'

# Set that when groups are available (i.e., there are different
# types of completions that are possible) the names of the
# groups should be visible at the top of the Fzf-Tab menu
zstyle ':fzf-tab:*' show-group full

# Do not show a symbol to the left of a file or a directory
zstyle ':fzf-tab:*' prefix ''

# Enable the continuous completion of using fzf; basic usage
# is that you pick a current choice from the fzf menu and then
# you press the '/' key to start a new completion
zstyle ':fzf-tab:*' continuous-trigger '/'

# Pass commands to the Fzf program that defines the colors. These
# colors are the same as those used to configure Fzf when it runs
# otherwise in the terminal window or in a text editor like Vim or Neovim
zstyle ":fzf-tab:*" fzf-flags --color='fg:#8a8a8a,bg:#1c1c1c,hl:#5f8700' --color='fg+:#afaf5f,bg+:#1c1c1c,hl+:#d78700' --color='info:#87afd7,prompt:#87afd7,pointer:#d78700' --color='marker:#d78700,spinner:#875f87,header:#875f87'

# Plugin: zsh-autosuggestions
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set a light grey color as the foreground color for the suggestion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# Disable autosuggestions for buffers longer than the specified length
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Perform autosuggestions in an async fashion
ZSH_AUTOSUGGEST_USE_ASYNC=1

# First type to find a suggestion from the history and, if
# a match is not found, suggest one from the zsh completion engine
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Use CTRL-<Space> to accept a specific auto suggestion
bindkey '^ ' autosuggest-accept

# }}}

# FZF {{{

# Setup fzf, its auto-completions, and key bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Match the vim-vitamin-onec colorscheme
# Color scheme: https://github.com/gkapfham/vim-vitamin-onec
# 256 Color reference: https://jonasjacek.github.io/colors/
export FZF_DEFAULT_OPTS='
  --no-bold
  --cycle
  --no-separator
  --no-scrollbar
  --bind tab:down,shift-tab:up
  --bind ctrl-f:page-down,ctrl-b:page-up
  --color=fg:#8a8a8a,bg:#1c1c1c,hl:#5f8700
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

# Trigger fzf completion using the semi-colon key instead of **
export FZF_COMPLETION_TRIGGER='**'

# Configure fzf to work with fast-finder called fd
# export FZF_DEFAULT_COMMAND="fd . $PWD"
export FZF_DEFAULT_COMMAND="fd"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Use ripgrep and ripgrep-all in combination with fzf
# to search all below directories (both text and binary files)
search() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="up,40%:wrap"
	)" &&
	echo "✨ $file"
}

# Search with ripgrep and get a nice bat preview, but requires
# that you specifics the name of the pattern immediately
searchnow() {
	rg  \
	--column \
	--line-number \
	--no-column \
	--no-heading \
	--fixed-strings \
	--ignore-case \
	--hidden \
	--follow \
	--glob '!.git/*' "$1" \
	| awk -F  ":" '/1/ {start = $2<5 ? 0 : $2 - 5; end = $2 + 5; print $1 " " $2 " " start ":" end}' \
	| fzf --preview 'bat --wrap character --color always {1} --highlight-line {2} --line-range {3}' --preview-window="up,40%:wrap"
}

# }}}

# Zsh-Vi-Mode {{{

# Run all of the code in this function after
# initializing the zsh-vi-mode plugin. Note that
# many of these steps are needed because of the
# fact that the zsh-vi-mode plugin overwrites
# keybindings, making it necessary to run again
function zvm_after_init() {

  # Re-source the use of fzf in zsh after starting zsh-vi-mode
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  # Re-Source and configure the zsh-auto-suggestions plugin
  source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  ZSH_AUTOSUGGEST_USE_ASYNC=1
  bindkey '^ ' autosuggest-accept

  # Create a binding so that you can type "cd ,pract^B"
  # (as an example) to trigger this integrated widget
  zle     -N   fzf-fasd-widget
  bindkey '^B' fzf-fasd-widget
  # Use FZF to filter the output of z.lua anywhere it is a command
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
    # the use of z.lua and FZF with this word
    if [ "$TRIGGERLETTER" = "," ]; then
      unset 'words[${#words[@]}]'
      PASTWORDS=${words[@]}
      CURRENTWORD="${CURRENTWORD:1:${#CURRENTWORD}}"
      # LBUFFER="${PASTWORDS}$(z -l $CURRENTWORD | cut -d' ' -f2- | sed -e 's/^[ 	]*//' | \
      LBUFFER="${PASTWORDS}$(z | grep $CURRENTWORD | cut -d' ' -f2- | sed -e 's/^[ 	]*//' | \
        fzf --query="$CURRENTWORD" --select-1 --exit-0 --height=25% --reverse --tac --no-sort --cycle)"
    # the trigger of "," was not used, so
    # search interactively based on user input
    else
      PASTWORDS=${words[@]}
      CURRENTWORD=""
      LBUFFER="${PASTWORDS}$(z -l $CURRENTWORD | cut -d' ' -f2- | sed -e 's/^[ 	]*//' | \
        fzf --query="$CURRENTWORD" --select-1 --exit-0 --height=25% --reverse --tac --no-sort --cycle)"
    fi
    # update the prompt with the result of using z.lua and FZF
    echo $BUFFER
    local ret=$?
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
  }

  # Create a binding so that you can type "cd ,pract^B"
  # (as an example) to trigger this integrated widget
  zle     -N   fzf-fasd-widget
  bindkey '^B' fzf-fasd-widget

}

# Configure the shell so that it uses jk for escape
# --> when currently in insert mode
ZVM_VI_INSERT_ESCAPE_BINDKEY="jk"
# --> when currently in visual mode
ZVM_VI_VISUAL_ESCAPE_BINDKEY="jk"

# Customize the background color of highlights in
# the terminal window when in visual mode. Note that
# you cannot change the foreground color so it is
# important to pick a background color that is suitable
# for the standard text colors used in the terminal
ZVM_VI_HIGHLIGHT_BACKGROUND="#303030"

# Define a slightly faster timeout delay for key
# pressed in the zsh-vi-mode plugin
ZVM_KEYTIMEOUT=0.2

# Disable the cursor mode because using terminals
# and Neovim in tmux will cause this value to
# change depending on the mode for Neovim
ZVM_CURSOR_STYLE_ENABLED=false

# Run this function every time that the
# zsh-vi-mode plugin detects that the
# mode changes, ultimately giving the
# opportunity to define the right-side
# prompt to give an indicator of the mode
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
     RPROMPT="%{$fg_bold[red]%}%{$reset_color%}"
     zle reset-prompt
    ;;
    $ZVM_MODE_INSERT)
     RPROMPT=""
     zle reset-prompt
    ;;
    $ZVM_MODE_VISUAL)
     RPROMPT="%{$fg_bold[red]%}%{$reset_color%}"
     zle reset-prompt
    ;;
    $ZVM_MODE_VISUAL_LINE)
     RPROMPT="%{$fg_bold[red]%}%{$reset_color%}"
     zle reset-prompt
    ;;
    $ZVM_MODE_REPLACE)
     RPROMPT="%{$fg_bold[red]%}%{$reset_color%}"
     zle reset-prompt
    ;;
  esac
}

# }}}

# Tmux {{{

# Display all of the open tmux sessions with fzf
tms() {
  local session
  newsession=${1:-Work}
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0 --cycle --no-separator) &&
    tmux attach-session -t "$session" || tmux new-session -s $newsession
}

# Display all of the possible tmuxinators with fzf
tmm() {
  # NOTE: Use the /usr/sbin/ls command since "ls" is now aliased to use "exa" command
  session=$( /usr/sbin/ls -alg ~/.tmuxinator | awk '{print $8}' | cut -d'.' -f1 | sed 1,2d | \
    fzf --query="$1" --select-1 --exit-0 --cycle --no-separator) &&
    tmuxinator "$session"
}

# Define the name of a tmux pane, display in the status-right
function workspace {
  readonly name=${1:?"Specify the name of the workspace."}
  tmux select-pane -T $name
}

# }}}

# Asdf-vm {{{

# Setup asdf-vm so that shims are available for all installed plugins
# Currently using asdf-vm to manage:
# --> Python
. /opt/asdf-vm/asdf.sh

# Setup rtx as a drop-in replacement for asdf
eval "$(rtx activate zsh)"
alias rtt="rtx"

# }}}

# DEPRECATED Pyenv {{{

# # Local pyenv home
# export PYENV_ROOT="$HOME/.pyenv"

# # Fast load of pyenv immediately upon shell startup
# export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(command pyenv init - zsh --no-rehash)"

# }}}

# DEPRECATED nvm {{{

# Lazy load nvm to avoid slow shell startup times
# Note that this requires you to type one of these
# commands before they will initially work

# if [ -s "$HOME/.nvm/nvm.sh" ]; then
#   export NVM_DIR="$HOME/.nvm"
#   [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
#   alias nvm='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && nvm'
#   alias node='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && node'
#   alias npm='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && npm'
# fi

# }}}

# Pipenv {{{

# Ensure that Pipenv can find the version of Python
# that is managed by the Pyenv tool; note that
# this is used infrequently for Python development
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
  exa --group-directories-first --grid --long --sort=name --icons
}

# Create a timer for work/rest sessions
declare -A focus_options
focus_options["Work"]="45"
focus_options["Rest"]="10"

# Define a function that will create the focus
# status bar and then echo message when finished
start_focus() {
  if [ -n "$1" -a -n "${focus_options["$1"]}" ]; then
  val=$1
  echo $val
  timer ${focus_options["$val"]}m
  notify-send " $val session done!"
  fi
}

# Define the function that offers the command that can
# be invoked in the shell
focus() {
  if [ -n "$1" ] && [ -n "$2" ]; then
    focus_options["$1"]="$2"
    echo "$1 for $2 minutes"
    start_focus "$1"
  else
    echo "Invalid parameters: focus [Work/Rest] [time_in_minutes]"
  fi
}

# }}}

# Color Commands {{{

# Print the 256 color palette
# Online version available at:
# https://jonasjacek.github.io/colors/
palette() {
    local -a colors
    for i in {000..255}; do
        colors+=("%F{$i}$i%f")
    done
    print -cP $colors
}

# Print the zsh color code for a 256 color number.
# This command is useful because it yields the
# color code used with Fzf-Tab and with LS_COLORS.
printcolor() {
    local color="%F{$1}"
    echo -E ${(qqqq)${(%)color}}
}

# }}}

# Neovim {{{

# Make sure that Neovim uses full 24-bit color
if [ -n "${NVIM_LISTEN_ADDRESS+x}" ]; then
  export COLORTERM="truecolor"
fi

# }}}

# z.lua {{{

# Define the color scheme for FZF, which zoxide uses
# when allowing the selection of directories; this
# color scheme matches (but not exactly, not sure
# why) the one used with the fzf-tab tool.

# export _ZO_FZF_OPTS="--no-bold --no-separator --cycle
#   --bind ctrl-f:page-down,ctrl-b:page-up
#   --color=fg:#8a8a8a,bg:#1c1c1c,hl:#5f8700
#   --color=fg+:#afaf5f,bg+:#1c1c1c,hl+:#d78700
#   --color=info:#87afd7,prompt:#87afd7,pointer:#d78700
#   --color=marker:#d78700,spinner:#875f87,header:#875f87"

# set configuration for fzf when using z -I
export _ZL_FZF_FLAG="--no-bold --no-separator --cycle --bind ctrl-f:page-down,ctrl-b:page-up --color=fg:#8a8a8a,bg:#1c1c1c,hl:#5f8700 --color=fg+:#afaf5f,bg+:#1c1c1c,hl+:#d78700 --color=info:#87afd7,prompt:#87afd7,pointer:#d78700 --color=marker:#d78700,spinner:#875f87,header:#875f87"

# Source the z.lua plugin
eval "$(lua /usr/share/z.lua/z.lua --init zsh enhanced once fzf)"
source $HOME/.zsh/czmod/czmod.zsh

# Create a fuzzy search alias for z.lua
alias zz='z -I .'

# Breaks the use of the fzf-tab plugin
# alias cd="z"

# }}}

# Redefine Aliases {{{

# Already defined in oh-my-zsh, redefine to use exa
alias ls="exa --color=always --icons"

# }}}

# Benchmarking {{{

# Uncomment to enable
# zprof

# }}}

