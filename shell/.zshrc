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
# cd ** <tab>       means "change to directory resulting from ...
#                           search from CURRENT directory using only fzf"
#
# <alt>-c            means "change to directory resulting from ...
#                           search from CURRENT directory with fzf"
#
# }}}

# Exports {{{

# Define the shell to always be zsh
export SHELL="zsh"

# Redefine the LS_COLORS so that:
# --> directories are not displayed as bold
export LS_COLORS="rs=0:di=0;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"

# Define the EZA_COLORS so that:
# --> user name is not displayed as bold
# --> group name is not displayed as bold
# --> read bit for user is not displayed as bold
# --> write bit for user is not displayed as bold
export EZA_COLORS="uu=0;33:gu=0;33:ur=0;33:uw=0;31"

# 256 color mode with bold and italics
# NOTE: Use of tmux-256color does not
# correctly set the title of terminal
export TERM="xterm-256color"

# Indicate support for 24-bit true-color
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
export BROWSER=brave

# Path
# Strategy: place user-local binaries before system ones
# Includes setup for:
# --> Contained Python with pipx
# --> Fuzzy finding with fzf
# --> Local binaries
# --> JavaScript npm
# --> Rust with cargo
# --> Go with .gocode
# --> User paths before Nix paths
export PATH="$HOME/.local/pipx/bin:$HOME/.fzf/bin:$HOME/.local/bin:$HOME/bin:$HOME/.npm-global/bin::$HOME/.cargo/bin:$HOME/.gocode/bin:$HOME/.poetry/bin:/run/wrappers/bin:/home/gkapfham/.nix-profile/bin:/nix/profile/bin:/home/gkapfham/.local/state/nix/profile/bin:/etc/profiles/per-user/gkapfham/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin/vendor_perl/:/usr/lib/lightdm/lightdm:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:"

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
export PROMPT_EOL_MARK=' 󰜎   '

# Define the TERMINAL variable for i3 window manager,
# which consults this for running the i3-sensible-terminal
export TERMINAL='kitty'

# Define the pager used for manual pages to be Neovim,
# making it possible to then use "gO" to populate and load the
# location list and then navigate the sections in the man page.
# Note that after population of the location list it is possible
# to view sections again by using <Leader>c instead of "gO".
export MANPAGER='nvim +Man!'

# Configure bat to use a matching theme;
# note that there are times when this theme
# may need to be reintroduced to bat by
# using the command "bat cache --build"
export BAT_THEME='Vitamin-Onec'

# Configure less to use lesspipe.sh so that it is possible
# to perform conversion of files to plaintext. For instance,
# using "less file.pdf" will now show file.pdf's text in the terminal
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

# Run kitty in a single instance;
# may reduce startup time
alias kitty="kitty --single-instance"

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
alias ka="eza --group-directories-first --grid --long --sort=name"

# Use the eza command to display a tree,
# ensuring better color scheme
alias tree="eza --tree --level=2 --long --icons"

# Use nix switch with a configuration in user account
alias kix="sudo nixos-rebuild switch -I nixos-config=/home/gkapfham/configure/nixos/configuration.nix"

# }}}

# Git Aliases {{{

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

# Znap Setup {{{

# Download znap, if it's not there yet
[[ -r ~/.zsh/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
# Start znap so that it can later install plugins
source ~/.zsh/zsh-snap/znap.zsh

# Oh-My-Zsh and Zsh Configuration {{{

# # Save startup time by disabling
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

# Default theme
ZSH_THEME="vitamin-onec"

# Timestamps
HIST_STAMPS="mm/dd/yyyy"

# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# Set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Preview directory's content with eza when completing cd,
# thereby showing a preview window with Fzf to the right
# of the cd command that shows the contents of current directory
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'

# Preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap --color='fg:#8a8a8a,bg:#1c1c1c,hl:#5f8700' --color='fg+:#afaf5f,bg+:#1c1c1c,hl+:#d78700' --color='info:#87afd7,prompt:#87afd7,pointer:#d78700' --color='marker:#d78700,spinner:#875f87,header:#875f87'

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

# }}}

# FZF {{{

# Setup fzf, its auto-completions, and key bindings
if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

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
	echo " $file"
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
  # NOTE: Use the /usr/sbin/ls command since "ls" is now aliased to use "eza" command
  session=$( /run/current-system/sw/bin/ls -alg ~/.tmuxinator | awk '{print $8}' | cut -d'.' -f1 | sed 1,2d | \
    fzf --query="$1" --select-1 --exit-0 --cycle --no-separator) &&
    tmuxinator "$session"
}

# Define the name of a tmux pane, display in the status-right
function workspace {
  readonly name=${1:?"Specify the name of the workspace."}
  tmux select-pane -T $name
}

# }}}

# Rtx (drop-in replacement for asdf) {{{

# # Setup rtx as a drop-in replacement for asdf
# eval "$(rtx activate -s zsh)"
# export RTX_FETCH_REMOTE_VERSIONS_TIMEOUT="1s"
# alias rtt="rtx"

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
    ssh-add -t 432000
}

# Always display directory contents after a change of directory
function chpwd() {
  emulate -L zsh
  eza --group-directories-first --grid --long --sort=name --icons
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

# Fancy Directory Movement with Zoxide {{{

# Initialize zoxide
znap eval zoxide "zoxide init zsh"

# Create a fuzzy search alias for zoxide
alias zz='zi'

# }}}

# Redefine Aliases {{{

# Already defined in oh-my-zsh, redefine to use eza
alias ls="eza --color=always --icons"

# }}}

# Prompt with Starship {{{

# Prompt source; see the starship.toml file
# in the ~/.config/ directory for details
znap eval starship 'starship init zsh'
znap prompt

# }}}

# History with Atuin {{{

# History source and keybindings;
# note using znap is not possible and
# a standard source is also not possible.
zvm_after_init_commands+=(eval "$(atuin init zsh)")
bindkey '^p' _atuin_search_widget

# }}}

# Znap Plugins {{{

# Use znap source to start plugins from oh-my-zsh
znap source ohmyzsh/ohmyzsh \
  plugins/git \
  plugins/tmux \
  plugins/tmuxinator

# Use znap source to start plugins
znap source zsh-users/zsh-completions
znap source zsh-users/zsh-autosuggestions
znap source jeffreytse/zsh-vi-mode
znap source Aloxaf/fzf-tab

# Configure the zsh-autosuggestions plugin
bindkey '^ ' autosuggest-accept
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585858"

# }}}

# Ssh Agent {{{

# ssh-agent setup
if [ -f ~/.ssh/agent.env ] ; then
  . ~/.ssh/agent.env > /dev/null
  if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
    # stale agent, start a new one
    eval `ssh-agent | tee ~/.ssh/agent.env` > /dev/null 2>&1
  fi
else
  # start an agent
  eval `ssh-agent | tee ~/.ssh/agent.env` > /dev/null 2>&1
fi

# add all private keys found in ~/.ssh
for filename in ~/.ssh/*; do
  type=`file "$filename" | awk -F ": " '{print $2}'`
  if [[ $type == "PEM RSA private key" ]]; then
    ssh-add $filename >/dev/null 2>&1
  fi
done

# }}}

# Benchmarking {{{

# Uncomment to enable
# zprof

# }}}
