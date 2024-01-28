--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.cmd([[set guifont=CaskaydiaCove\ NF\ Mono:h26]])
-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local function grabColor(name, at)
  local tmp = vim.api.nvim_get_hl(0, {name = name})
  return string.format('#%x', tmp[at])
end

local bgColor = "NONE"
local tern = function (cond, t, f)
  if cond then return t else return f end
end

-- helper function for ToggleColor
local winSetHighlights = function(colorSet, accentBgColor)
  vim.api.nvim_set_hl(0, 'Normal', { bg = colorSet })
  vim.api.nvim_set_hl(0, 'Cursor', { reverse = true })
  vim.api.nvim_set_hl(0, 'CursorLineNr',{ fg = grabColor('DraculaYellow', 'fg')})
  vim.api.nvim_set_hl(0, 'CursorLine',{ bg = tern(bgColor == "NONE", "NONE", accentBgColor) })
  vim.api.nvim_set_hl(0, 'ColorColumn',{ bg = tern(bgColor == "NONE", "NONE", accentBgColor) })
  vim.api.nvim_set_hl(0, 'TabLine',{ bg = colorSet, fg = grabColor('DraculaPurple', 'fg')})
  vim.api.nvim_set_hl(0, 'TabLineFill',{ bg = colorSet })
  vim.api.nvim_set_hl(0, 'WinSeparator',{ bg = colorSet })
  vim.api.nvim_set_hl(0, 'Folded',{ fg = grabColor('DraculaBoundary', 'fg'), bg = tern(bgColor == "NONE", "NONE", accentBgColor) })
end

-- helper function for ToggleColor
local setupLualine = function (colorSet)
  local conditionalColors = {
    interactive = { bg = grabColor('DraculaBgLight', 'bg') },
    visual = { bg = grabColor('DraculaYellow', 'fg'), fg = colorSet },
    insert = { bg = grabColor('DraculaPurple', 'fg') },
    terminal = { bg = grabColor('DraculaGreen', 'fg'), fg = colorSet },
    command = { bg = grabColor('DraculaPink', 'fg') },
    replace = { bg = "#ad2424" },
    normal = { bg = tern(bgColor == "NONE", 'white', grabColor('DraculaBgLight', 'bg')) },
  }

  local function lualine_segment_colors(cols)
    local textCol = tern(cols.fg == nil, "white", cols.fg)
    if bgColor == "NONE" then
      return {
        a = { fg = cols.bg, bg = colorSet, gui = "bold" },
        b = { fg = cols.bg, bg = colorSet },
        c = { bg = colorSet },
        x = { bg = colorSet },
        y = { fg = cols.bg, bg = colorSet },
        z = { fg = cols.bg, bg = colorSet }
      }
    else
      return {
        a = { fg = textCol, bg = cols.bg, gui = "bold" },
        b = { fg = "white", bg = grabColor('DraculaBgLighter', 'bg') },
        c = { bg = grabColor('DraculaBgDark', 'bg') },
        x = { bg = grabColor('DraculaBgDark', 'bg') },
        y = { fg = "white", bg = grabColor('DraculaBgLighter', 'bg') },
        z = { fg = textCol, bg = cols.bg }
      }
    end
  end

  local lualine_theme = {}

  for k, v in pairs(conditionalColors) do
    lualine_theme[k] = lualine_segment_colors(v)
  end
  require('lualine').setup {
    options = {
      theme = lualine_theme
    }
  }
end

local _solidBgColor = nil
local solidBgColor = function ()
  if _solidBgColor == nil then
    local ok, mod = pcall(require, 'vimbgcol')
    if not ok then _solidBgColor = grabColor('draculabgdarker', 'bg')
    else _solidBgColor = mod end
  end

  return _solidBgColor
end
-- Toggles wether or not nvim has transparent background
local ToggleColor = function ()
  local lighterCol = "NONE"
  if bgColor == "NONE" then

    bgColor = solidBgColor()
    local _, _, r, g, b = string.find(bgColor, '^#(%x%x)(%x%x)(%x%x)')
    r, g, b =
      math.floor(tonumber(r, 16) * 0.75),
      math.floor(tonumber(g, 16) * 0.75),
      math.floor(tonumber(b, 16) * 0.75)
    lighterCol = [[#]] .. string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
  else bgColor = "NONE" end
  winSetHighlights(bgColor, lighterCol)
  setupLualine(bgColor)
end
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- database explorer like PGADmin, but native to NVIM
  'tpope/vim-dadbod',

  -- UI tool for dadbod
  'kristijanhusak/vim-dadbod-ui',

  -- completion tool for dadbod
  'kristijanhusak/vim-dadbod-completion',

  -- vim tmux window move intregration
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Debugger plugin for neovim
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
  },

  -- shows little variable values inline in buffer as the debugger is running
  'theHamsta/nvim-dap-virtual-text',

  -- vim commands in the middle of the screen
  {
    'VonHeikemen/fine-cmdline.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    }
  },
  -- Ollama intregration into nvim
  'David-Kunz/gen.nvim',

  -- Useful plugin to show you pending keybinds.
  -- the empty opts is necessary
  { "folke/which-key.nvim", opts = {} },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>k', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Go to previous Hunk' })
        vim.keymap.set('n', '<leader>j', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Go to next Hunk' })
        vim.keymap.set('n', '<leader>ga', require('gitsigns').stage_hunk, { buffer = bufnr, desc = '[G]it [A]dd/stage hunk' })
        vim.keymap.set('n', '<leader>gA', require('gitsigns').stage_buffer, { buffer = bufnr, desc = '[G]it add [A]ll hunks in buffer' })
        vim.keymap.set('n', '<leader>gu', require('gitsigns').undo_stage_hunk, { buffer = bufnr, desc = '[G]it [U]ndo hunk' })
        vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { buffer = bufnr, desc = '[G]it [R]eset hunk' })
        vim.keymap.set('n', '<leader>go', require('gitsigns').preview_hunk_inline, { buffer = bufnr, desc = '[G]it [O]pen preview of hunk' })
        vim.keymap.set('n', '<leader>gc', [[:Git commit<CR>]], { buffer = bufnr, desc = '[G]it [C]ommit' })
        vim.keymap.set('n', '<leader>gp', [[:Git push<CR>]], { buffer = bufnr, desc = '[G]it [P]ush' })
      end,
    },
  },

  -- gives background colors to strings like "#6C7C2D" or "color: darkcyan"
  'brenoprata10/nvim-highlight-colors',

  -- setting the theme
  {
     'dracula/vim',
     priority = 1000,
     config = function ()
       vim.cmd.colorscheme 'dracula'
       winSetHighlights(bgColor)
     end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = '',
        section_separators = '',
      },
      sections = {
        lualine_a = {'filename'},
        lualine_b = {'filetype'},
        lualine_c = {'diagnostics'},
        lualine_x = {'diff'},
        lualine_y = {'branch'},
        lualine_z = {'fileformat', 'encoding'}
      },
      inactive_sections = {
        lualine_a = {'filename'},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'filetype'}
      }
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {
      opleader = { line = '<leader>com', block = '<leader>bcom' },
  } },

  -- Fuzzy Finder (files, lsp, etc)
  -- Remeber to install ripgrep in administer terminal `choco install ripgrep`
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'BurntSushi/ripgrep',
      'debugloop/telescope-undo.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      require("telescope").load_extension("undo")
      vim.keymap.set("n", "<leader>u", [[:Telescope undo<CR>]])
    end,
  },
  -- tag completion for html tags or react components starting with <something
  {
    'windwp/nvim-ts-autotag',
    ft = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    config= function ()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    compilers = { "clang" },
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- plugin for reliably closing other buffers than current
  "Asheq/close-buffers.vim",

  -- code runner for inline feedback for interpreted languages like js, python and lua
  {
    -- '0x100101/lab.nvim' fork
    'Edvid/lab.nvim',
    build = 'cd js && npm ci',
    dependencies =  {
      'nvim-lua/plenary.nvim',
    },
  }

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Make line numbers relative
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 1200

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- nvim-cmp setup for sql stuff
vim.cmd([[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })]])


-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

require('ibl').setup {
  indent = { char = "┆" },
}

-- local lualine_theme = require('lualine.themes.auto')
setupLualine()

require('lab').setup { }

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>o', require('telescope.builtin').oldfiles, { desc = '[O]pen recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').current_buffer_fuzzy_find, { desc = '[S]earch in thi[s] buffer' })

vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_files, { desc = '[S]earch [G]it Files' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sc', require('telescope.builtin').live_grep, { desc = '[S]earch [C]ontents' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sx', require('telescope.builtin').commands, { desc = '[S]earch commands/e[X]ecutables' })
vim.keymap.set('n', '<leader>sr' , [[:%s///g<Left><Left><Left>]], { desc = '[S]earch & global [R]eplace' })
vim.keymap.set('v', '<leader>sr', [[:s///g<Left><Left><Left>]], { desc = '[S]earch & this [L]line [R]eplace' })

require('nvim-highlight-colors').turnOn()

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  -- ensure_installed = { 'c', 'cpp', 'c_sharp', 'go', 'lua', 'python', 'rust', 'javascript', 'typescript', 'tsx', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      -- swap_next = {
      --   ['<leader>a'] = '@parameter.inner',
      -- },
      -- swap_previous = {
      --   ['<leader>A'] = '@parameter.inner',
      -- },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { desc = '[D]iagnostics [O]pen float' })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Debugger keymaps
require('dapui').setup()

require('fine-cmdline').setup({
  popup = {
    position = {
      row = '50%',
    },
    size = { width = '40%' },
  }
})

-- keybind for fine-cmdline
vim.api.nvim_set_keymap('n', 'æ', '<cmd>FineCmdline<CR>', {noremap = true})


require('gen').setup({
  model = "mistral",
  display_mode = "split",
  show_prompt = true,
  show_model = true,
  no_auto_close = false,
  init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
  command = "curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d $body",
})

-- gen.nvim keybind
vim.keymap.set({'n', 'v'}, '<leader>Gch', [[:Gen Chat<CR>]], {desc = [[using [Gen] [ch]at with AI]]})
vim.keymap.set('v', '<leader>Gcc', [[:Gen Change_Code<CR>]], {desc = [[using [Gen], [C]hange [C]ode with AI]]})

vim.keymap.set('n', '<leader>dt', require('dapui').toggle, { desc = '[D]ebugger [T]oggle' })
vim.keymap.set('n', '<leader>db', [[:DapToggleBreakpoint<CR>]], { desc = '[D]ebugger toggle [B]reakpoint' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>K', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  gopls = {},
  pyright = {},
  rust_analyzer = {},
  tsserver = {},
  eslint = {},
  html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim' }
      }
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

-- choose your icon chars
local icons = {
  Class = '',
  Color = '',
  Constant = '',
  Constructor = '',
  Enum = '',
  EnumMember = '',
  Event = '',
  Field = '',
  File = '',
  Folder = '󰉋',
  Function = '󰡱',
  Interface = '',
  Keyword = '',
  Method = "",
  Module = 'mod',
  Operator = '',
  Property = '',
  Reference = 'ref',
  Snippet = '󰧛',
  Struct = '󰘦',
  Text = 'abc',
  TypeParameter = '',
  Unit = '󰑭',
  Value = '',
  Variable = '',
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      if vim_item.kind == 'Color' and entry.completion_item.documentation then
        local _, _, r, g, b = string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
        if r then
          local color = string.format('%02x', r) .. string.format('%02x', g) ..string.format('%02x', b)
          local group = 'Tw_' .. color
          if vim.fn.hlID(group) < 1 then
            vim.api.nvim_set_hl(0, group, {fg = '#' .. color})
          end
          vim_item.kind = '⬤'
          vim_item.kind_hl_group = group
          return vim_item
        end
      end
      -- vim_item.kind = icons[vim_item.kind] and (icons[vim_item.kind] .. vim_item.kind) or vim_item.kind
      -- or just show the icon
      vim_item.kind = icons[vim_item.kind] and icons[vim_item.kind] or vim_item.kind
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'lab.quick_data', keyword_length = 4 },
  },
}

vim.opt.showmode = false

vim.cmd([[set cursorline]])

vim.cmd([[au BufRead,BufNewFile * set sw=0]])
vim.cmd([[au BufRead,BufNewFile * set ts=2]])
vim.cmd([[au BufRead,BufNewFile * set expandtab]])
vim.cmd([[au BufRead,BufNewFile */COMMIT_EDITMSG set cc=70]])


ToggleColor()
vim.api.nvim_create_user_command("ToggleTransparency", function()
  ToggleColor()
end, {})

vim.keymap.set('n', '<leader>xx', [[:source ~/.config/nvim/init.lua<CR>]], { desc = 'source/E[X]ecute init'})
vim.keymap.set('n', '<leader>xt', [[:source %<CR>]], { desc = 'source/E[X]ecute [T]his'})

-- Toggle between always having the cursor centered and not doing so
local fixedLines = false

local function toggleFixedLines()
  if fixedLines then
    vim.opt.scrolloff = 0
  else vim.opt.scrolloff = 9999
  end
  fixedLines = not fixedLines
end

vim.keymap.set('n', '<leader>l', toggleFixedLines, {desc = 'fixed [L]ines'})

-- paste without destroying what you have in register
vim.keymap.set('v', '<leader>p', [["_dP]], {noremap = true, desc = [[[P]aste without loosing clipboard]]})

-- new file here and explore here keybinds
vim.keymap.set('n', '<leader>n', [[:FineCmdline edit %:p:h/<CR>]], {desc = [[edit/create [N]ew file here]]})
vim.keymap.set('n', '<leader>e', [[:Explore<CR>]], {desc = [[[E]xplore from here]]})

-- better keybinds for netrw
vim.api.nvim_create_autocmd('filetype', {
  pattern = 'netrw',
  desc = 'Better keybinds for netrw',
  callback = function()
    local bind = function(new, old)
      vim.keymap.set('n', new, old, {remap = true, buffer = true})
    end

    -- edit new file
    bind('<leader>n', '%')

    -- rename file
    bind('r', 'R')

  end
})

vim.keymap.set({'n', 'i', 'v', 'o', 'c'}, '<A-s>', ToggleColor)

vim.keymap.set('n', '<leader>who', [[:G blame<CR>]])
vim.keymap.set('n', '<leader>cl', [[:Bd other<CR>]])
vim.keymap.set('n', '<leader>col', [[:FineCmdline set cc=<CR>]], { desc = 'Color in [COL]umn at given number'} )

vim.keymap.set('n', '<leader>run', [[:Lab code run<CR>]], { desc = '[RUN] lab code runner'} )
vim.keymap.set('n', '<leader>stop', [[:Lab code stop<CR>]], { desc = '[STOP] lab code runner'} )

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('n', '<leader>f', [[/]])
vim.keymap.set('n', '<leader>q', [[@]])

-- vim.keymap.set('n', '<C-h>', [[<C-w>h]])
-- vim.keymap.set('n', '<C-j>', [[<C-w>j]])
-- vim.keymap.set('n', '<C-k>', [[<C-w>k]])
-- vim.keymap.set('n', '<C-l>', [[<C-w>l]])

vim.keymap.set('n', '<A-j>', [[ddp:undojoin<CR>]])
vim.keymap.set('n', '<A-k>', [[ddkP:undojoin<CR>]])

vim.keymap.set('n', '<A-d>', [[:bn<CR>]])
vim.keymap.set('n', '<A-a>', [[:bN<CR>]])
vim.keymap.set('n', '<A-1>', [[:bf<CR>]])
vim.keymap.set('n', '<A-2>', [[:bf<CR>:bn<CR>]])
vim.keymap.set('n', '<A-3>', [[:bf<CR>:2bn<CR>]])
vim.keymap.set('n', '<A-q>', [[:bf<CR>:3bn<CR>]])
vim.keymap.set('n', '<A-w>', [[:bf<CR>:4bn<CR>]])
vim.keymap.set('n', '<A-e>', [[:bf<CR>:5bn<CR>]])
vim.keymap.set({'n', 'v', 'o', 'c'}, '<C-z>', '<Nop>')
vim.opt.list = true
vim.opt.listchars:append({trail = '•', eol = '↵', tab = '» '})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
