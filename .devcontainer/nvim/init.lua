vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- clipboard
vim.opt.clipboard = 'unnamedplus' -- Sync with system clipboard

-- https://neovim.io/doc/user/provider.html#clipboard-osc52
if vim.fn.has('wsl') == 1 or os.getenv('HOSTNAME') ~= nil then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    },
    paste = {
      -- https://github.com/neovim/neovim/discussions/28010#discussioncomment-9877494
      ['+'] = function()
        return {
          vim.fn.split(vim.fn.getreg(''), '\n'),
          vim.fn.getregtype(''),
        }
      end,
    },
  }
end

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require('lazy').setup({
  spec = {
    {
      'goropikari/front-matter.nvim',
      dev = true,
      opts = {
        front_matter_path = '/workspaces/front-matter.nvim/cmd/front-matter.nvim',
      },
      build = 'make setup',
    },
    {
      'nvim-neotest/neotest',
      version = '*',
      dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter/nvim-treesitter',
        { 'fredrikaverpil/neotest-golang', version = '*' },
      },
      config = function()
        local config = { -- Specify configuration
          go_test_args = {
            '-v',
            '-race',
            '-count=1',
            '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out',
          },
        }
        require('neotest').setup({
          adapters = {
            require('neotest-golang')(config), -- Apply configuration
          },
        })
      end,
    },
  },
  dev = {
    path = '/workspaces',
    patterns = { 'goropikari' },
  },
  checker = { enabled = true },
})
