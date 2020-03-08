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

" Update the 'modified:' and 'modifier' values in the header
function! s:UpdateModifiedTime()
  let save_cursor = getcurpos()
  "silent 0,/^\s*$/global/^modified: / delete
  "call append(0, "modified: " . TiddlyWikiTime())
  silent execute "0,7s/\\vmodified.*$/modified: " . TiddlyWikiTime() . "/"
  silent execute "0,7s/\\vmodifier.*$/modifier: " . s:TiddlyWikiUser() . "/"
  call setpos('.', save_cursor)
endfunction

" Get the username to use as 'creator' and/or 'modifier'
" Uses the 'g:tiddlywiki_author' variable if present or the system username
" otherwise
function! s:TiddlyWikiUser()
  if exists('g:tiddlywiki_author')
    return g:tiddlywiki_author
  elseif $USER !=# ''
    " Fall back to OS username
    return $USER
  else
    " Contains the username in termux/android (among other systems probably)
    return $LOGNAME
  endif
endfunction

function! s:AutoUpdateModifiedTime()
  if &modified
    call <SID>UpdateModifiedTime()
  endif
endfunction

function! s:InitializeTemplate(tags)
  let timestamp = TiddlyWikiTime()
  call append(0, "created: " . timestamp)
  call append(1, "creator: " . s:TiddlyWikiUser())
  call append(2, "modified: " . timestamp)
  call append(3, "modifier: " . s:TiddlyWikiUser())
  " Title defaults to filename without extension
  call append(4, "title: " . expand('%:t:r')) 
  call append(5, "tags: " . join(a:tags, ' '))
  call append(6, "type: text/vnd.tiddlywiki")
  call append(7, "")
endfunction




if exists("g:tiddlywiki_autoupdate")
  augroup tiddlywiki
    au BufWrite, *.tid call <SID>AutoUpdateModifiedTime()
  augroup END
endif





" Define commands, allowing the user to define custom mappings
command! -nargs=0 TiddlyWikiUpdateMetadata call <SID>UpdateModifiedTime()
command! -nargs=0 TiddlyWikiInitializeTemplate call <SID>InitializeTemplate([])
command! -nargs=0 TiddlyWikiInitializeJournal call <SID>InitializeTemplate(['Journal'])

" Define some default mappings unless disabled
if !exists("g:tiddlywiki_no_mappings")
  nmap <Leader>tm :TiddlyWikiUpdateMetadata<Cr>
  nmap <Leader>tt :TiddlyWikiInitializeTemplate<Cr>
endif



let &cpo = s:save_cpo
