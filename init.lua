-- fetch plugins
vim.pack.add({
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/folke/which-key.nvim',
	'https://github.com/folke/lazydev.nvim',
	{
		src = 'https://github.com/Saghen/blink.cmp',
		version = vim.version.range('*')
	}
})

require('which-key').setup {}
require("lazydev").setup {}
require('blink.cmp').setup {
	signature = {
		enabled = true
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 0
		},
		menu = {
			auto_show = true,
			auto_show_delay_ms = 0,
		}
	}
}

-- set space as leaderkey
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- allow for easier explorer
vim.keymap.set('n', '<Leader>e', ':Ex<CR>', { desc = "Explorer" })

-- enable various lsp servers
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('texlab')
vim.lsp.enable('jdtls')

-- set line numbers and relative line numbers
vim.o.number = true
vim.o.relativenumber = true
-- save undo history
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- always keep x amount of lines above and below cursor
vim.o.scrolloff = 10
-- highlight current line
vim.o.cursorline = true
-- confirm dialog for unsaved changes
vim.o.confirm = true

-- hightlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end
})

-- if the client supports it, format the file on save
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(outerEvent)
		local client = vim.lsp.get_client_by_id(outerEvent.data.client_id)

		-- enable format on save
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
			-- format file on save
			vim.api.nvim_create_autocmd("BufWrite", {
				callback = function(innerEvent)
					vim.lsp.buf.format({ bufnr = innerEvent.buf })
				end
			})
		end
	end
})
