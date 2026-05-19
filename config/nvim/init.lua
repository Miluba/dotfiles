vim.pack.add({
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path"
})

for _, plugin in ipairs({
	"gruvbox.nvim",
	"nvim-lspconfig",
	"nvim-cmp",
	"cmp-nvim-lsp",
	"cmp-buffer",
	"cmp-path"
}) do
	vim.cmd.packadd(plugin)
end

require("gruvbox").setup()
vim.cmd.colorscheme("gruvbox")

vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d65d0e", bold = true })

vim.diagnostic.config({
	severity_sort = true,
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 2,
		source = "if_many",
		prefix = "●"
	},
	float = {
		border = "rounded",
		source = "if_many"
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H"
		}
	}
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspDefaults", { clear = true }),
	callback = function(event)
		local bufnr = event.buf
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
		local map_opts = { silent = true, buffer = bufnr }
		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, map_opts)
		vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, map_opts)
		vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, map_opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, map_opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, map_opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, map_opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, map_opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, map_opts)
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, map_opts)
	end
})

local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

cmp.setup({
	completion = {
		completeopt = "menu,menuone,noselect"
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item()
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" }
	})
})

local capabilities = cmp_nvim_lsp.default_capabilities()

local function warn_if_missing(bin, label)
	if vim.fn.executable(bin) == 0 then
		vim.schedule(function()
			vim.notify(label .. " is not installed or not in PATH", vim.log.levels.WARN)
		end)
	end
end

warn_if_missing("gopls", "gopls")
warn_if_missing("typescript-language-server", "typescript-language-server")

local gopls_config = {
	capabilities = capabilities,
	settings = {
		gopls = {
			gofumpt = true,
			staticcheck = true,
			usePlaceholders = true,
			completeUnimported = true,
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				shadow = true
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true
			}
		}
	}
}
local tsls_config = {
	capabilities = capabilities,
	cmd = { "typescript-language-server", "--stdio" }
}

if vim.lsp.config and vim.lsp.enable then
	vim.lsp.config("gopls", gopls_config)
	vim.lsp.config("ts_ls", tsls_config)
	vim.lsp.enable("gopls")
	vim.lsp.enable("ts_ls")
else
	local lspconfig = require("lspconfig")
	lspconfig.gopls.setup(gopls_config)
	lspconfig.ts_ls.setup(tsls_config)
end

local go_format_group = vim.api.nvim_create_augroup("GoFormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = go_format_group,
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params(0, "utf-8")
		params.context = { only = { "source.organizeImports" } }
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
		for _, res in pairs(result or {}) do
			for _, action in pairs(res.result or {}) do
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
				end
				if type(action.command) == "table" then
					vim.lsp.buf.execute_command(action.command)
				end
			end
		end

		vim.lsp.buf.format({
			async = false,
			filter = function(client)
				return client.name == "gopls"
			end
		})
	end
})
