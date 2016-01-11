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

function! s:UpdateModifiedTime()
  let save_cursor = getcurpos()
  let time = system("date -u +'%Y%m%d%H%M%S'")[:-2]
  silent 0,/^\s*$/global/^modified: / delete
  call append(0, "modified: " . time)
  call setpos('.', save_cursor)
endfunction

augroup tiddlywiki
  if !exists("g:tiddlywiki_no_modified")
    au BufWrite, *.tid  call <SID>UpdateModifiedTime()
  endif
augroup END

let &cpo = s:save_cpo
