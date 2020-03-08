This is a fork of http://www.vim.org/scripts/script.php?script_id=2705

For people who like the TiddlyWiki formatting syntax.

http://tiddlywiki.org/wiki/TiddlyWiki_Markup

It has since been highly customized and updated.

This plugin provides syntax highlighting for tiddlywiki files (`*.tid`) as well
as some helpers for editing TiddlyWiki files. It is probably best used in 
conjunction with [TiddlyWiki Bob](https://github.com/OokTech/TW5-Bob), since it 
is designed to smoothly handle tiddlers being changed both via TiddlyWiki as
well as directly on the file system.


# Usage


## Provided Commands

* `TiddlyWikiUpdateMetadata` : Update the 'modifier' and 'modified' fields in the current tiddler's metadata.
* `TiddlyWikiInitializeTemplate` : Insert tiddler metadata (timestamps, creator / modifier / title) at the top of the file
* `TiddlyWikiEditTiddler <name>` : Open the tiddler with that name (without '.tid' extension) or create it if it doesn't exist
* `TiddlyWikiEditJournal : Open the journal tiddler for today or create it if it doesn't exist

The `TiddlyWikiEdit...` commands look for tiddlers in the following locations (in that order):
* If `g:tiddlywiki_dir` is set:
  * `g:tiddlywiki_dir/`
  * `g:tiddlywiki_dir/tiddlers/`
* Otherwise:
  * `./`
  * `./tiddlers/`
  * `~/wiki/`
  * `~/wiki/tiddlers/`


## Default Mappings

```
nmap <Leader>tm :TiddlyWikiUpdateMetadata<Cr>
nmap <Leader>tt :TiddlyWikiInitializeTemplate<Cr>
nmap <Leader>te :TiddlyWikiEditTiddler<Space>
nmap <Leader>tE :vsplit<cr>:TiddlyWikiEditTiddler<Space>
nmap <Leader>tj :TiddlyWikiEditJournal<Cr>
nmap <Leader>tJ :vsplit<cr>:TiddlyWikiEditJournal<Cr>
```


## Configuration

```
" Explicitly set the username of the tiddler 'creator' and 'modifier'
" If not set, this defaults to `$USER` or `$LOGNAME` (in that order)
let g:tiddlywiki_author = 'thisisme'

" Specify the location of your tiddlers. The subdir "tiddlers" is appended 
" automatically if required.
let g:tiddlywiki_dir = '~/docs/notes/wiki'

" Set the date format to use for journal tiddlers, as in the format string of date(1).
" This does not have to be at 'day' granularity - you can also use 
" months / weeks / hours / whatever makes sense to you.
" Defaults to '%F' (ISO date = yyyy-mm-dd)
let g:tiddlywiki_journal_format = '%A, %F (Week %V)'

" Disable the default mappings
let g:tiddlywiki_no_mappings=1

" Automatically update tiddler metadata ('modified' timestamp, 'modifier' 
" username) on write
let g:tiddlywiki_autoupdate=1
```

