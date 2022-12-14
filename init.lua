local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd(
	"BufWritePost",
	{ command = "source <afile> | PackerCompile", group = packer_group, pattern = "init.lua" }
)

require("packer").startup(function(use)
	use "wbthomason/packer.nvim"

	use "andweeb/presence.nvim"
	use { "catppuccin/nvim", as = "catppuccin" }
	use "glepnir/dashboard-nvim"
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/nvim-cmp"
	use "jose-elias-alvarez/null-ls.nvim"
	use "kyazdani42/nvim-web-devicons"
	use "L3MON4D3/LuaSnip"
	use "lewis6991/gitsigns.nvim"
	use "neovim/nvim-lspconfig"
	use "nvim-lua/plenary.nvim"
	use "nvim-lualine/lualine.nvim"
	use "nvim-telescope/telescope.nvim"
	use "nvim-telescope/telescope-file-browser.nvim"
	use "nvim-treesitter/nvim-treesitter"
	use "onsails/lspkind-nvim"
	use "romainl/vim-cool"
	use "ryanoasis/vim-devicons"
	use "saadparwaiz1/cmp_luasnip"
	use "tpope/vim-commentary"
	use "williamboman/mason.nvim"
	use "williamboman/mason-lspconfig.nvim"
	use "windwp/nvim-autopairs"
end)

vim.o.exrc = true

vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.lazyredraw = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.shiftwidth = 3
vim.o.tabstop = 3
vim.o.termguicolors = true
vim.o.updatetime = 100
vim.o.swapfile = false
vim.wo.wrap = false

vim.g.mapleader = " "

-- Shortcuts --

vim.keymap.set("i", "jj", "<esc>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Leader>w", "<C-w>k")
vim.keymap.set("n", "<Leader>a", "<C-w>h")
vim.keymap.set("n", "<Leader>s", "<C-w>j")
vim.keymap.set("n", "<Leader>d", "<C-w>l")
vim.keymap.set("n", "<Leader>g", ":update<CR>")
vim.keymap.set("n", "<Leader>j", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<Leader>k", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<Leader>q", ":bprevious<CR>:bdelete #<CR>", { silent = true })
vim.keymap.set("n", "<Leader>y", ":%y<CR>")
vim.keymap.set("n", "<Leader>x", ":Lex<CR>:vertical resize 30<CR>")
vim.keymap.set("n", "<Leader>l", ":vsplit term://zsh <CR>", { silent = true })
vim.keymap.set("t", "<Leader><Esc>", "<C-\\><C-n>", { silent = true })
vim.keymap.set("n", "<Leader>v", ":edit ~/.config/nvim/init.lua<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Leader>c", ":Commentary<CR>", { silent = true })

local lang_maps = {
	cpp = { build = "g++ % -o %:r", exec = "./%:r" },
	typescript = { exec = "bun %" },
	javascript = { exec = "bun %" },
	python = { exec = "python3 %" },
	java = { build = "javac %", exec = "java %:r" },
	sh = { exec = "./%" },
	go = { build = "go build", exec = "go run %" },
	rust = { exec = "cargo run" },
	html = { exec = "npx serve"},
}
for lang, data in pairs(lang_maps) do
	if data.build ~= nil then
		vim.api.nvim_create_autocmd(
			"FileType",
			{ command = "nnoremap <Leader>b :!" .. data.build .. "<CR>", pattern = lang }
		)
	end
	vim.api.nvim_create_autocmd(
		"FileType",
		{ command = "nnoremap <Leader>e :split<CR>:terminal " .. data.exec .. "<CR>", pattern = lang }
	)
end
vim.api.nvim_create_autocmd("BufWritePre", {
	command = "lua vim.lsp.buf.formatting_sync(nil, 1000)",
	pattern = "*.css,*.go,*.html,*.js,*.json,*.jsx,*.lua,*.md,*.py,*.ts,*.tsx,*.yaml",
})
vim.api.nvim_create_autocmd("InsertEnter", { command = "set norelativenumber", pattern = "*" })
vim.api.nvim_create_autocmd("InsertLeave", { command = "set relativenumber", pattern = "*" })
vim.api.nvim_create_autocmd("TermOpen", { command = "startinsert", pattern = "*" })
vim.api.nvim_create_autocmd("BufWinEnter", { command = "set noexpandtab tabstop=2 shiftwidth=2", pattern = "*.rs" })
vim.api.nvim_create_autocmd("BufWinEnter", { command = "set filetype=astro", pattern = "*.astro" })

-- auto compile scss
vim.api.nvim_create_autocmd("BufWritePost", { command = "!sass %:p %:r.css", pattern = "*.scss" })

-- Error Sign on the left
vim.cmd "sign define DiagnosticSignError text=??? texthl=DiagnosticSignError"
vim.cmd "sign define DiagnosticSignWarn text=??? texthl=DiagnosticSignWarn"
vim.cmd "sign define DiagnosticSignInfo text=??? texthl=DiagnosticSignInfo"
vim.cmd "sign define DiagnosticSignHint text=??? texthl=DiagnosticSignHint"

vim.diagnostic.config { virtual_text = false }

-------------------------------------------------------------------------
----------------------------Plugin Config--------------------------------
-------------------------------------------------------------------------

-- Presence on UI
require("presence"):setup {
	neovim_image_text = "Neovim",
	presence_log_level = "error",
	presence_editing_text = "Editing ?? %s ??",
	presence_file_explorer_text = "Browsing files",
	presence_reading_text = "Reading  ?? %s ??",
	presence_workspace_text = "Working on ?? %s ??",
}

-- Color Scheme
vim.g.catppuccin_flavour = "mocha"
vim.cmd "colorscheme catppuccin"
vim.cmd "hi Normal guibg=NONE ctermbg=NONE"

-- Dashboard when opening Neovim
local db = require "dashboard"
db.custom_header = {
	"",
	"",
	"",
	"",
	" ????????????   ????????? ???????????????????????? ?????????????????????  ?????????   ????????? ????????? ????????????   ????????????",
	" ???????????????  ????????? ??????????????????????????????????????????????????? ?????????   ????????? ????????? ??????????????? ???????????????",
	" ?????????????????? ????????? ??????????????????  ?????????   ????????? ?????????   ????????? ????????? ?????????????????????????????????",
	" ?????????????????????????????? ??????????????????  ?????????   ????????? ???????????? ???????????? ????????? ?????????????????????????????????",
	" ????????? ?????????????????? ???????????????????????????????????????????????????  ?????????????????????  ????????? ????????? ????????? ?????????",
	" ?????????  ??????????????? ???????????????????????? ?????????????????????    ???????????????   ????????? ?????????     ?????????",
	"",
	"",
	"",
}
db.custom_center = {
	{
		icon = "??? ",
		desc = "New File            ",
		action = "DashboardNewFile",
		shortcut = "SPC o",
	},
	{
		icon = "??? ",
		desc = "Browse Files        ",
		action = "Telescope file_browser",
		shortcut = "SPC n",
	},
	{
		icon = "??? ",
		desc = "Find File           ",
		action = "Telescope find_files",
		shortcut = "SPC f",
	},
	{
		icon = "??? ",
		desc = "Configure Neovim    ",
		action = "edit ~/.config/nvim/lua/init.lua",
		shortcut = "SPC v",
	},
	{
		icon = "??? ",
		desc = "Exit Neovim              ",
		action = "quit",
	},
}
vim.keymap.set("n", "<Leader>o", ":DashboardNewFile<CR>", { silent = true })

-- Snippets
local luasnip = require "luasnip"
local postfix = require("luasnip.extras.postfix").postfix
local extras = require("luasnip.extras")
local l = extras.l

postfix(".tk", {
		l("[" .. l.POSTFIX_MATCH .. "]"),
})


local cmp = require "cmp"
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = { { name = "nvim_lsp" }, { name = "luasnip" } },
}

-- lualine UI
require("lualine").setup {
	options = {
		theme = custom_catppuccin,
		component_separators = "|",
		section_separators = { left = "???", right = "???" },
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "???" }, right_padding = 2 } },
		lualine_b = { "filename", "branch", { "diff", colored = false } },
		lualine_c = {},
		lualine_x = {},
		lualine_y = { "filetype", "progress" },
		lualine_z = { { "location", separator = { right = "???" }, left_padding = 2 } },
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = {
			{
				"buffers",
				separator = { left = "???", right = "???" },
				right_padding = 2,
				symbols = { alternate_file = "" },
			},
		},
	},
}

----------------------------------------------------
-----------------Language Servers-------------------
----------------------------------------------------

-- LSP config from nvim
local lspconfig = require "lspconfig"

-- Language Server for diagnostics, formatting 
local null_ls = require "null-ls"
null_ls.setup {
	sources = {
		null_ls.builtins.formatting.eslint_d,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.stylua,
	},
}

-- See lines that are modified
require("gitsigns").setup {
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "???" },
		changedelete = { text = "~" },
	},
}


-- Telescope fuzzy finder
local telescope = require "telescope"
telescope.setup {
	defaults = {
		mappings = { n = { ["o"] = require("telescope.actions").select_default } },
		initial_mode = "normal",
		file_ignore_patterns = { ".git/", "node_modules/", "target/" },
	},
	pickers = { find_files = { hidden = true } },
	extensions = { file_browser = { hidden = true } },
}
telescope.load_extension "file_browser"
vim.keymap.set("n", "<Leader>n", telescope.extensions.file_browser.file_browser)
vim.keymap.set("n", "<Leader>f", require("telescope.builtin").find_files)
vim.keymap.set("n", "<Leader>t", require("telescope.builtin").treesitter)

-- Treesitter Syntax Highlighting
require("nvim-treesitter.configs").setup {
	ensure_installed = {
		"bash",
		"css",
		"go",
		"html",
		"lua",
		"python",
		"typescript",
	},
	highlight = { enable = true },
}

-- Atomatic Language Server download
require("mason").setup {}

local servers = {
	"bashls",
	"cssls",
	"html",
	"tsserver",
	"emmet_ls",
	"intelephense",
}
local has_formatter = { "gopls", "html", "tsserver" }
require("mason-lspconfig").setup {
	ensure_installed = servers,
	automatic_installation = true,
}
local opts = {
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		local opts = { buffer = bufnr }
		vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)
		local should_format = true
		for _, value in pairs(has_formatter) do
			if client.name == value then
				should_format = false
			end
		end
		if not should_format then
			client.resolved_capabilities.document_formatting = false
		end
	end,
	capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
}
for _, server in pairs(servers) do
	lspconfig[server].setup(opts)
end

require("nvim-autopairs").setup {}
