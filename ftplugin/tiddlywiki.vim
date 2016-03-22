" Vim filetype plugin for TiddlyWiki
" Language: tiddlywiki
" Maintainer: Devin Weaver <suki@tritarget.org>
" License: http://www.apache.org/licenses/LICENSE-2.0.txt

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo-=C

function! TiddlyWikiTime()
  return system("date -u +'%Y%m%d%H%M%S'")[:-2] . "000"
endfunction

function! s:UpdateModifiedTime()
  if &modified
    let save_cursor = getcurpos()
    silent 0,/^\s*$/global/^modified: / delete
    call append(0, "modified: " . TiddlyWikiTime())
    call setpos('.', save_cursor)
  endif
endfunction

if !exists("g:tiddlywiki_no_modified")
  augroup tiddlywiki
    au BufWrite, *.tid  call <SID>UpdateModifiedTime()
  augroup END
endif

if !exists("g:tiddlywiki_no_maps")
  nmap <Leader>tm :call <SID>UpdateModifiedTime()<Cr>
endif

let &cpo = s:save_cpo
