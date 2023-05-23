function! s:largeFiles()
	setlocal foldmethod=indent
	setlocal foldexpr=0
	lua require('cmp').setup.buffer { enabled = false }
	let b:nix_disable_fenced_highlight = 1
	let b:lexima_disabled = 1
endfunction
if has('nvim-0.7')
	set foldmethod=expr
	set foldexpr=nvim_treesitter#foldexpr()
endif
autocmd BufReadPre * if getfsize(expand("<afile>")) > 1024 * 1024 |
	\ call s:largeFiles() |
\ endif
autocmd BufEnter * if getfsize(expand("<afile>")) > 1024 * 1024 |
	\ execute('NoMatchParen') |
	\ else |
	\ execute('DoMatchParen') |
\ endif
