-- {{{ Helper for treesitter, and cmp
bufIsBig = function(bufnr)
	local max_filesize = 100 * 1024 -- 100 KB
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
	if ok and stats and stats.size > max_filesize then
		return true
	else
		return false
	end
end
-- }}}

-- {{{ LSP & completion
-- Set up nvim-cmp.
local cmp = require'cmp'
cmp.setup({
	-- I don't add sources here, but I add them in a BufReadPre autocmd
})
-- If a file is too large, I don't want to add to it's cmp sources treesitter, see:
-- https://github.com/hrsh7th/nvim-cmp/issues/1522
vim.api.nvim_create_autocmd('BufReadPre', {
	callback = function(t)
		if not bufIsBig(t.buf) then
			cmp.setup.buffer {
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lsp_signature_help' },
					{ name = 'treesitter' },
				}, {
					{ name = 'vsnip' },
					{ name = 'path' }
				})
			}
		end
	end
})
-- Set up lspconfig.
servers_list = {
	-- Original list contains many more servers
	"nil_ls",
}
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp = require("lspconfig")
for _,v in ipairs(servers_list) do
	lsp[v].setup{
		autostart = true,
		capabilities = capabilities,
	}
end
-- }}}

-- {{{ treesitter
treesitter_disable_func = function(lang, buf)
	return bufIsBig(buf)
end
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		disable = treesitter_disable_func,
	},
	textobjects = {
		select = {
			enable = true,
			disable = treesitter_disable_func,
		},
	},
}
-- }}}

-- vim:foldmethod=marker
