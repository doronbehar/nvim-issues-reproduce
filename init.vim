autocmd BufEnter * if getfsize(expand("<afile>")) > 1024 * 1024 |
	\ execute('NoMatchParen') |
	\ else |
	\ execute('DoMatchParen') |
\ endif
