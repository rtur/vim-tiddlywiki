" Vim syntax file for TiddlyWiki
" Language: tiddlywiki
" Last Change: 2009-07-06 Mon 10:15 PM IST
" Maintainer: Devin Weaver <suki@tritarget.org>
" License: http://www.apache.org/licenses/LICENSE-2.0.txt
" Reference: http://tiddlywiki.org/wiki/TiddlyWiki_Markup


""" Initial checks
" To be compatible with Vim 5.8. See `:help 44.12`
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    " Quit when a (custom) syntax file was already loaded
    finish
endif


""" Patterns
syn spell toplevel

" Emphasis
syn match twItalic /\/\/.\{-}\/\// contains=@Spell
syn match twBold /''.\{-}''/ contains=@Spell
syn match twUnderline /__.\{-}__/ contains=@Spell
syn match twStrikethrough /--.\{-}--/ contains=@Spell
syn match twHighlight /@@.\{-}@@/
syn match twNoFormatting /{{{.\{-}}}}/ contains=@Spell
syn match twCodeblockTag /^```\i*$/ contains=@Spell

" Heading
syn match twHeading /^!\+\s*.*$/ contains=@Spell

" Comment
syn region twComment start=/<!--/ end=/-->/ contains=@Spell

" Lists
syn match twList /^[\*#]\+/

" Definition list
syn match twDefinitionListTerm /^;.\+$/ contains=@Spell
syn match twDefinitionListDescription /^:.\+$/ contains=@Spell

" Blockquotes
syn match twBlockquote /^>\+.\+$/ contains=@Spell
syn region twBlockquote start=/^<<</ end=/^<<</ contains=@Spell

" Table
syn match twTable /|/

" Link
syn region twLink start=/\[\[/ end=/\]\]/
syn match twCamelCaseLink /[^~]\<[A-Z][a-z0-9]\+[A-Z][[:alnum:]]*\>/
syn match twUrlLink /\<\(https\=\|ftp\|file\):\S*/

syn match twString /["'][^"']*["']/ contained extend contains=@Spell
syn match twTransclude /{{[^{}]\{-}}}/

syn region twWidgetStartTag start=/<\$\=\i\+/ end=/>/ contains=twWidgetAttr,twMacro,twTransclude,twString
syn match  twWidgetAttr /\s\i\+=/ contained
syn match  twWidgetEndTag /<\/$\=\i\+>/

syn match twFieldsLine /^[[:alnum:]_-]\+:\s\+.*$/ contains=twFieldsKey
syn match twFieldsKey /^[[:alnum:]_-]\+:/ contained

syn match twMacro /<<.\{-}>>/ contains=twString
syn match twMacroDefineStart /^\s*\\define\s\+\i\+(\i*)/ contains=twMacroDefineName,twMacroDefineVar
syn match twMacroDefineName /\i\+(\i*)/ contained contains=twMacroDefineArg
syn region twMacroDefineArg start=/(/ms=s+1 end=/)/me=e-1 contained
syn match twMacroDefineEnd /^\s*\\end/

syn match twVariable /\$(\=\i\+)\=\$/

""" Highlighting

hi def twItalic term=italic cterm=italic gui=italic
hi def twBold term=bold cterm=bold gui=bold

hi def link twUnderline Underlined
hi def link twStrikethrough Ignore
hi def link twHighlight Todo
hi def link twNoFormatting Constant
hi def link twCodeblockTag Constant
hi def link twHeading Title
hi def link twComment Comment
hi def link twList Structure
hi def link twDefinitionListTerm Identifier
hi def link twDefinitionListDescription String
hi def link twBlockquote Repeat
hi def link twTable Label
hi def link twLink Typedef
hi def link twCamelCaseLink Typedef
hi def link twUrlLink Typedef
hi def link twTransclude Label
hi def link twWidgetStartTag Structure
hi def link twWidgetAttr Identifier
hi def link twWidgetEndTag Structure
hi def link twString String
hi def link twFieldsLine String
hi def link twFieldsKey Identifier
hi def link twMacro Label
hi def link twMacroDefineStart Typedef
hi def link twMacroDefineName Label
hi def link twMacroDefineArg Identifier
hi def link twMacroDefineEnd Typedef
hi def link twVariable Identifier
