" check if the given dir contains at least one system tiddler
function! s:HasSystemTiddlers(dir) 
  return len(globpath(a:dir, '$__*.tid', 1, 1)) > 0
endfunction

" Determine the dir containing all tiddlers
function! tiddlywiki#TiddlyWikiDir()
  if exists("s:tiddlywiki_dir")
    if s:tiddlywiki_dir == ''
      echom 'ERROR: tiddler dir could not be determined'
    endif
    return s:tiddlywiki_dir
  endif

  let candidates = []

  if exists("g:tiddlywiki_dir")
    let candidates = [g:tiddlywiki_dir, g:tiddlywiki_dir . '/tiddlers']
  else
    let candidates = ['.', './tiddlers', '~/wiki', '~/wiki/tiddlers']
  endif

  for candidate in candidates
    let abs = fnamemodify(candidate, ':p')
    if(s:HasSystemTiddlers(abs))
      silent echom "Tiddler dir = <"  abs  ">"
      let s:tiddlywiki_dir = abs
      return abs
    endif
  endfor

  echom 'ERROR: tiddler dir could not be determined'
  return ''
endfunction


" Get the name for the journal tiddler for right now
function! tiddlywiki#GetJournalTiddlerName()
  if exists('g:tiddlywiki_journal_format')
    let fmt = g:tiddlywiki_journal_format
  else
    let fmt = '%F'
  endif

  return trim(system("date +'" . fmt . "'"))
endfunction


" Completion func for tiddler names
function! tiddlywiki#CompleteTiddlerName(ArgLead, CmdLine, CursorPos)
  let dir = tiddlywiki#TiddlyWikiDir()
  let fqns = globpath(dir, a:ArgLead . '*.tid', 1, 1)
  let files = map(fqns, 'strpart(v:val, strridx(v:val, "/") +1)')
  return map(files, 'strpart(v:val, 0, strridx(v:val, "."))')
endfunction


function! tiddlywiki#FuzzyFindTiddler(sink)
  if exists('*fzf#run')
    call fzf#run({
          \ 'source':  tiddlywiki#CompleteTiddlerName('', '', 0),
          \ 'sink': a:sink,
          \ 'down': '40%'
          \ })
  else
    echom "no tiddler name given and no fzf available for fancy completion"
  endif
endfunction
