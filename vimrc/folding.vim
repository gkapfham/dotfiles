" Folding {{{

function! FancyFoldText()
  let l:line = getline(v:foldstart)
  let l:nucolwidth = &foldcolumn + &number * &numberwidth
  let l:windowwidth = winwidth(0) - l:nucolwidth - 3
  let l:foldedlinecount = v:foldend - v:foldstart
  let l:onetab = strpart('          ', 0, &tabstop)
  let l:line = substitute(l:line, '\t', l:onetab, 'g')
  let l:line = strpart(l:line, 0, l:windowwidth - 2 -len(l:foldedlinecount))
  let l:fillcharcount = l:windowwidth - len(l:line) - len(l:foldedlinecount)
  return l:line . ' ' . repeat(' ',l:fillcharcount-8) . l:foldedlinecount . ' lines ' . ' '
endfunction
set foldtext=FancyFoldText()

" }}}
