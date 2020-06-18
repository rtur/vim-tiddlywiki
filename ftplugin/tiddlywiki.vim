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
  let l:ts = system("date -u +'%Y%m%d%H%M%S'")[:-2] . "000"
  " on windows/powershell 'date' returns its result as UTF-16 and vim doesn't
  " automatically recognize it => we have to strip the "garbage"
  return substitute(l:ts, '\v[^0-9]', '', 'g')
endfunction

" Update the 'modified:' and 'modifier' values in the header
function! s:UpdateModifiedTime()
  let save_cursor = getcurpos()
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


" Get the [[link]] / WikiLink under the cursor or an empty string if there
" isn't any. Uses the syntax definitions.
function! s:GetLink()
  let cline = line('.')
  let ccol = col('.')
  let synid = synID(cline, ccol, 0)
  let synname = synIDattr(synid, "name")

  " if the cursor is not on a link, return empty string
  if (synname !=# 'twLink') && (synname !=# 'twCamelCaseLink')
    return ''
  endif

  " scan backward and forward in the line to find the link boundaries
  let startcol = ccol
  let endcol = ccol

  let c = ccol
  while synID(cline, c, 0) == synid
    let startcol = c
    let c = c - 1
  endwhile

  let c = ccol
  while synID(cline, c, 0) == synid
    let endcol = c
    let c = c + 1
  endwhile

  " extract the link token
  let linkstr = strpart(getline('.'), startcol - 1, (endcol - startcol) + 1)

  " ... and the link itself
  if synname == 'twLink'
    return strpart(linkstr, 2, strlen(linkstr) - 4)
  else
    return linkstr
  endif
endfunction




" Get the [[link]] / WikiLink under the cursor and open it
function s:OpenLinkUnderCursor()
  let link = s:GetLink()

  if link == ''
    return "echom 'Cursor is not on a link'"
  else
    return 'TiddlyWikiEditTiddler ' . link
  endif
endfunction


" Insert a link to the tiddler with the given name.
function! s:InsertLink(name)
  let tiddler_dir = tiddlywiki#TiddlyWikiDir()
  if tiddler_dir == ''
    return
  endif

  if a:name == '' 
    call tiddlywiki#FuzzyFindTiddler(function('s:InsertLink'))
    return
  endif

  let line = getline('.')
  let pos = col('.')-1
  let fqn = '[[' . a:name . ']]'
  let line = line[:pos-1] . fqn . line[pos:]
  call setline('.', line)
  call setpos('.', [0, line('.'), pos + strlen(fqn) + 1, 0])
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
command! -nargs=0 TiddlyWikiOpenLink execute <sid>OpenLinkUnderCursor()
command! -complete=customlist,tiddlywiki#CompleteTiddlerName
       \ -nargs=? TiddlyWikiInsertLink call <SID>InsertLink('<args>')

" Define some default mappings unless disabled
if !exists("g:tiddlywiki_no_mappings")
  nmap <Leader>tm :TiddlyWikiUpdateMetadata<Cr>
  nmap <Leader>tt :TiddlyWikiInitializeTemplate<Cr>
  nmap <Leader>to :TiddlyWikiOpenLink<Cr>
  nmap <Leader>tl :TiddlyWikiInsertLink<space>
endif



let &cpo = s:save_cpo
