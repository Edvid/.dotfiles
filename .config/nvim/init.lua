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

local bgColor = "NONE"

local tern = function (cond, t, f)
  if cond then return t else return f end
end
local winSetHighlights = function(colorSet)
  vim.api.nvim_set_hl(0, 'Normal', { bg = colorSet })
  vim.api.nvim_set_hl(0, 'Cursor', { reverse = true })
  vim.api.nvim_set_hl(0, 'CursorLineNr',{ fg = "#F1FA8C" })
  vim.api.nvim_set_hl(0, 'CursorLine',{ bg = colorSet })
  vim.api.nvim_set_hl(0, 'TabLine',{ bg = colorSet, fg = "#BD93F9" })
  vim.api.nvim_set_hl(0, 'TabLineFill',{ bg = colorSet })
  vim.api.nvim_set_hl(0, 'WinSeparator',{ bg = colorSet })
end

local setupLualine = function (colorSet)
  local conditionalColors = {
    interactive = "#6272A4",
    visual = "#F1FA8C",
    insert = "#BD93F9",
    terminal = tern(bgColor == "NONE", "#50fa7b", "#2c8a48"),
    command = tern(bgColor == "NONE", "#FF79C6", "#c85f8c"),
    replace = "#FF6E6E",
    normal = tern(bgColor == "NONE", "#ABB2BF", "#747983"),
  }
  local function lualine_segment_colors(col)
    if bgColor == "NONE" then
      return {
        a = { fg = col, bg = colorSet, gui = "bold" },
        b = { fg = col, bg = colorSet },
        c = { bg = colorSet },
        x = { bg = colorSet },
        y = { fg = col, bg = colorSet },
        z = { fg = col, bg = colorSet }
      }
    else
      return {
        a = { fg = "white", bg = col, gui = "bold" },
        b = { fg = "white", bg = "#5f6a8e" },
        c = { bg = "#2c2e39" },
        x = { bg = "#2c2e39" },
        y = { fg = "white", bg = "#5f6a8e" },
        z = { fg = "white", bg = col }
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

local ToggleColor = function ()
  if bgColor == "NONE" then bgColor = "#121826"
  else bgColor = "NONE" end
  winSetHighlights(bgColor)
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

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>k', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Go to previous Hunk' })
        vim.keymap.set('n', '<leader>j', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Go to next Hunk' })
        vim.keymap.set('n', '<leader>gs', require('gitsigns').stage_hunk, { buffer = bufnr, desc = '[G]it [S]tage hunk' })
        vim.keymap.set('n', '<leader>ga', require('gitsigns').stage_buffer, { buffer = bufnr, desc = '[G]it stage [A]ll hunks in buffer' })
        vim.keymap.set('n', '<leader>gu', require('gitsigns').undo_stage_hunk, { buffer = bufnr, desc = '[G]it [U]ndo hunk' })
        vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { buffer = bufnr, desc = '[G]it [R]eset hunk' })
        vim.keymap.set('n', '<leader>go', require('gitsigns').preview_hunk_inline, { buffer = bufnr, desc = '[G]it [O]pen preview of hunk' })
        vim.keymap.set('n', '<leader>gc', [[:Git commit<CR>]], { buffer = bufnr, desc = '[G]it [C]ommit' })
        vim.keymap.set('n', '<leader>gp', [[:Git push<CR>]], { buffer = bufnr, desc = '[G]it [P]ush' })
      end,
    },
  },

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
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    compilers = { "clang" },
  },
  {
    'gorbit99/codewindow.nvim',
    config = function()
      local codewindow = require('codewindow')
      codewindow.setup()
      codewindow.apply_default_keybinds()
    end,
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  {
    "Asheq/close-buffers.vim"
  },

  {
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
vim.keymap.set('n', '<leader>sr', function()
  local pattern = vim.fn.input "Pattern: "
  local replacement = vim.fn.input "Replacement: "
  vim.cmd([[%s/]] .. pattern .. [[/]] .. replacement .. [[/g]])
end, { desc = '[S]earch & global [R]eplace' })
vim.keymap.set('n', '<leader>slr', [[:s///g<Left><Left><Left>]], { desc = '[S]earch & this [L]line [R]eplace' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'c_sharp', 'go', 'lua', 'python', 'rust', 'javascript', 'typescript', 'tsx', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

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
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { desc = '[D]iagnostics [O]pen float' })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

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
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

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
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

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
  Class = '',
  Color = '',
  Constant = '',
  Constructor = '',
  Enum = '',
  EnumMember = '',
  Event = '',
  Field = '',
  File = '',
  Folder = '',
  Function = "f⒳",
  Interface = '',
  Keyword = '',
  Method = "",
  Module = '',
  Operator = '',
  Property = '',
  Reference = '',
  Snippet = '',
  Struct = '',
  Text = '',
  TypeParameter = '',
  Unit = '',
  Value = '',
  Variable = '',
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
      vim_item.kind = icons[vim_item.kind] and (icons[vim_item.kind] .. vim_item.kind) or vim_item.kind
      -- or just show the icon
      -- vim_item.kind = icons[vim_item.kind] and icons[vim_item.kind] or vim_item.kind
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

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

vim.cmd([[set cursorline]])

vim.cmd([[au BufRead,BufNewFile * set sw=0]])
vim.cmd([[au BufRead,BufNewFile * set ts=2]])
vim.cmd([[au BufRead,BufNewFile * set expandtab]])
vim.cmd([[au BufRead,BufNewFile */COMMIT_EDITMSG set cc=70]])

ToggleColor()
vim.api.nvim_create_user_command("ToggleTransparency", function()
  ToggleColor()
end, {})

vim.keymap.set('n', '<A-s>', [[:ToggleTransparency<CR>]])

vim.keymap.set('n', '<leader>who', [[:G blame<CR>]])
vim.keymap.set('n', '<leader>cl', [[:Bd other<CR>]])
vim.keymap.set('n', '<leader>col', [[:set cc=]], { desc = 'Color in [COL]umn at given number'} )

vim.keymap.set('n', '<leader>run', [[:Lab code run<CR>]], { desc = '[RUN] lab code runner'} )
vim.keymap.set('n', '<leader>stop', [[:Lab code stop<CR>]], { desc = '[STOP] lab code runner'} )

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('n', '<leader>f', [[/]])
vim.keymap.set('n', '<leader>q', [[@]])

vim.keymap.set('n', '<A-d>', [[:bn<CR>]])
vim.keymap.set('n', '<A-a>', [[:bN<CR>]])
vim.keymap.set('n', '<A-1>', [[:bf<CR>]])
vim.keymap.set('n', '<A-2>', [[:bf<CR>:bn<CR>]])
vim.keymap.set('n', '<A-3>', [[:bf<CR>:2bn<CR>]])
vim.keymap.set('n', '<A-q>', [[:bf<CR>:3bn<CR>]])
vim.keymap.set('n', '<A-w>', [[:bf<CR>:4bn<CR>]])
vim.keymap.set('n', '<A-e>', [[:bf<CR>:5bn<CR>]])
vim.opt.listchars:append({trail = '•', eol = '↵', tab = '» '})
vim.keymap.set({'n', 'v', 'o', 'c'}, '<C-z>', '<Nop>')
