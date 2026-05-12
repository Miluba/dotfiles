vim.pack.add({
	"https://github.com/ellisonleao/gruvbox.nvim"
})

require("gruvbox").setup()
vim.cmd.colorscheme("gruvbox")

vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d65d0e", bold = true })
