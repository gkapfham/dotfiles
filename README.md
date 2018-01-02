# dotfiles

This repository contains the configuration files (i.e., "dotfiles") used to
configure the programs regularly used by [Gregory M.
Kapfhammer](http://www.cs.allegheny.edu/sites/gkapfham). Please note that all of
the dotfiles in this repository are, at least to some extent, "hard-coded" to
work for my development environment and projects. For instance, I created these
configuration files under the assumption that the developer will use Ubuntu
16.04. Even though they are heavily customized, my hope is that they are largely
reusable and, additionally, will give examples of how to configure various
programs such as `nvim`, `vim`, `zsh`, `mutt`, and `tmux`.

This is a summary of the dotfiles that I currently provide:

- `.Rprofile`: initializations for the R programming language
- `.Xresources`: configuration for the Rofi for displaying menus
- `.bibtoolrsc`: configuration for the `bibtool` program's BibTeX management
- `.ctags`: extensions for `exuberant-ctags` to handle new languages
- .gitignore_global
- .gtkrc-2.0
- .gvimrc
- .inputrc
- .latexmkrc
- .mailcap
- .minivimrc
- .msmtprc
- .muttprintrc
- .muttrc
- .signature
- .tmux.conf
- .vimrc
- .zshrc

## Installation Instructions

You can type the following command if you want to clone this repository:

```shell
git clone https://github.com/gkapfham/dotfiles.git
```

Now, you can type `cd dotfiles` and start to browse the configuration files that
are available. I suggest that you make symbolic links from your home directory
to this repository if you want to create and use these configuration files in a
disciplined fashion.

## Problems or Praise?

If you have any problems with downloading or understanding these configuration
files, then please create an issue associated with this Git repository using the
"Issues" link at the top of this site. As the sole contributor to the `dotfiles`
repository, I will do everything possible to resolve your issue and ensure that
all of the configurations are clear and, potentially, best suited to working in
your development environment. Remember, this repository is being made publicly
available so as to provide examples of how to write configurations for programs
like `vim`. If you find that these files help you in preparing your own
configurations, then I also encourage you to "star" and "watch" this project!
