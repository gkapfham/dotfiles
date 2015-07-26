utils::loadhistory()

options(menu.graphics=FALSE)

library(colorout)
setOutputColors256(normal = 250, negnum = 237, zero = 237,
                   number = 214, date = 110, string = 143,
                   const = 172, false = 96, true = 96,
                   infinite = 39, stderror = 173,
                   warn = 173, error = 173,
                   verbose = FALSE, zero.limit = NA)
if(interactive()){
       # Get startup messages of three packages and set Vim as R pager:
       options(setwidth.verbose = 1,
               colorout.verbose = 1,
               vimcom.verbose = 1,
               pager = "vimrpager")
       # Use the text based web browser w3m to navigate through R docs:
       if(Sys.getenv("TMUX") != "")
           options(browser="~/bin/vimrw3mbrowser",
                   help_type = "html")
       # Use either Vim or GVim as text editor for R:
       if(nchar(Sys.getenv("DISPLAY")) > 1)
           options(editor = 'gvim -f -c "set ft=r"')
       else
           options(editor = 'vim -c "set ft=r"')

       # Load the colorout library:
       library(colorout)
       if(Sys.getenv("TERM") != "linux" && Sys.getenv("TERM") != ""){
         setOutputColors256(normal = 250, negnum = 237, zero = 237,
                            number = 214, date = 110, string = 143,
                            const = 172, false = 96, true = 96,
                            infinite = 39, stderror = 173,
                            warn = 173, error = 173,
                            verbose = FALSE, zero.limit = NA)
       }
       # Load the setwidth library:
       library(setwidth)
       # Load the vimcom library only if R was started by Vim:
       if(Sys.getenv("VIMRPLUGIN_TMPDIR") != ""){
           library(vimcom)
           # See R documentation on Vim buffer even if asking for help in R Console:
           if(Sys.getenv("VIM_PANE") != "")
               options(help_type = "text", pager="vimrpager")
       }
   }
