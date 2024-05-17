local Plug = vim.fn["plug#"]

vim.call("plug#begin")
Plug("junegunn/fzf")
Plug("nvim-tree/nvim-tree.lua")

Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim", { ["tag"] = "0.1.x" })

Plug("folke/trouble.nvim", { ["branch"] = "dev" })
Plug("nvim-treesitter/nvim-treesitter")
Plug("neovim/nvim-lspconfig")

Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")

Plug("neovim/nvim-lspconfig")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("L3MON4D3/LuaSnip")

Plug("VonHeikemen/lsp-zero.nvim", { ["branch"] = "v3.x" })

Plug("stevearc/conform.nvim")

Plug("Olical/conjure")
Plug("ionide/Ionide-vim")
Plug("folke/neodev.nvim")

Plug("mfussenegger/nvim-dap")
Plug("nvim-neotest/nvim-nio")
Plug("rcarriga/nvim-dap-ui")

Plug("rebelot/kanagawa.nvim")
Plug("nyoom-engineering/oxocarbon.nvim")
Plug("ellisonleao/gruvbox.nvim")

Plug("nvim-lualine/lualine.nvim")
Plug("nvim-tree/nvim-web-devicons")
Plug("ChristianChiarulli/neovim-codicons")
vim.call("plug#end")

--- Common Vim Settings
---
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.opt.nu = true
vim.opt.rnu = true
vim.opt.scrolloff = 10

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])
vim.g.mapleader = " "

--- Treesitter
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "ruby", "python", "go", "c_sharp", "ocaml" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	-- List of parsers to ignore installing (or "all")
	ignore_install = { "" },

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})

-- lua setup for neovim
require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
	library = { plugins = { "nvim-dap-ui" }, types = true },
})

-- LSP
local lsp = require("lspconfig")
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

lsp_zero.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"fennel_ls",
		"lua_ls",
		"fsautocomplete",
		"omnisharp",
		"lexical",
		"ocamllsp",
		"ruby_lsp",
		"pyright",
		"clangd",
		"tsserver",
	},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
		lsp.lua_ls.setup({
			Settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		}),
	},
})

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp_action.luasnip_supertab(),
		["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
	}),

	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { { "prettierd", "prettier" } },
		ruby = { "rubocop" },
		csharp = { "csharpier" },
		fsharp = { "fantomas" },
		c = { "clang-format" },
		cpp = { "clang-format" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
})

require("nvim-tree").setup()
require("trouble").setup()
require("lualine").setup()
require("dapui").setup()
local dapui = require("dapui")

local builtin = require("telescope.builtin")
-- yayyy keymaps
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- open lsp diagnostics in floating window
-- vim.diagnostic.open_float()
vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>dp", dapui.toggle, {})
