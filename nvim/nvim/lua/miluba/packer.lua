return require('packer').startup(function()
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  use 'folke/tokyonight.nvim'
  -- use 'gruvbox-community/gruvbox'
  -- use { "catppuccin/nvim", as = "catppuccin" }
  
  -- Statusline
  use { 
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true } 
  }

  -- Configurations for Nvim LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'

  -- Autocompletion
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  -- Git integration
  use 'dinhhuy258/git.nvim'
  use 'lewis6991/gitsigns.nvim'
  
end)
