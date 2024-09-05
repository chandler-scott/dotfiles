" Syntax highlighting for Nix files with Dracula theme

" Highlight comments
syntax match nixComment /#.*/

" Highlight keywords
syntax keyword nixKeywords with import mkShell

" Highlight functions
syntax keyword nixFunctions nativeBuildInputs shellHook

" Highlight booleans
syntax keyword nixBoolean true false

" Highlight strings
syntax region nixString start=+"+ end=+"+
syntax region nixString start=+'+ end=+'+

" Highlight attributes
syntax match nixAttribute /\<NIX_ENFORCE_PURITY\>/

" Define highlight groups linking to Dracula theme groups
hi def link nixComment Comment
hi def link nixKeywords Keyword
hi def link nixFunctions Function
hi def link nixBoolean Boolean
hi def link nixString String
hi def link nixAttribute Identifier

