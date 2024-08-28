--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.wo.number = true

vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.wo.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.o.timeoutlen = 300
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Configure how new splits should be opened
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '•', eol = '↵', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 6

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- nvim-cmp setup for sql stuff
vim.cmd(
  [[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })]])

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { desc = '[D]iagnostics [O]pen float' })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = '*',
})

vim.cmd([[set guifont=CaskaydiaCove\ NF\ Mono:h26]])

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local function grabColor(name, at)
  local tmp = vim.api.nvim_get_hl(0, { name = name })
  return string.format('#%x', tmp[at])
end

local bgColor = "NONE"
local tern = function(cond, t, f)
  if cond then return t else return f end
end

-- helper function for ToggleColor
local winSetHighlights = function(colorSet, accentBgColor, highlightColor)
  vim.api.nvim_set_hl(0, 'Normal', { bg = colorSet })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = colorSet })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = colorSet })
  vim.api.nvim_set_hl(0, 'Cursor', { reverse = true })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = grabColor('Number', 'fg') })
  vim.api.nvim_set_hl(0, 'CursorLine', { bg = tern(bgColor == "NONE", "NONE", accentBgColor) })
  vim.api.nvim_set_hl(0, 'ColorColumn', { bg = tern(bgColor == "NONE", "NONE", accentBgColor) })
  vim.api.nvim_set_hl(0, 'Search', { bg = tern(bgColor == "NONE", "NONE", highlightColor) })
  vim.api.nvim_set_hl(0, 'TabLineFill', { bg = colorSet })
  vim.api.nvim_set_hl(0, 'WinSeparator', { bg = colorSet })
  vim.api.nvim_set_hl(0, 'Folded',
    { fg = grabColor('Folded', 'fg'), bg = tern(bgColor == "NONE", "NONE", accentBgColor) })
end

-- helper function for ToggleColor
local setupLualine = function(colorSet)
  local conditionalColors = {
    visual = { bg = grabColor('Type', 'fg'), fg = colorSet },
    insert = { bg = grabColor('Statement', 'fg') },
    terminal = { bg = grabColor('String', 'fg'), fg = colorSet },
    command = { bg = grabColor('Number', 'fg'), fg = colorSet },
    replace = { bg = grabColor('CurSearch', 'bg'), fg= colorSet },
    normal = { bg = tern(bgColor == "NONE", 'white', "NONE") },
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
        b = { fg = "white", bg = grabColor('WildMenu', 'bg') },
        c = { bg = grabColor('TabLine', 'bg') },
        x = { bg = grabColor('TabLine', 'bg') },
        y = { fg = "white", bg = grabColor('WildMenu', 'bg') },
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
local solidBgColor = function()
  if _solidBgColor == nil then
    local ok, mod = pcall(require, 'vimbgcol')
    if not ok then
      _solidBgColor = grabColor('Normal', 'bg')
    else
      _solidBgColor = mod
    end
  end

  return _solidBgColor
end
-- Toggles wether or not nvim has transparent background
local ToggleColor = function()
  local accentCol = "NONE"
  local highlightCol = "NONE"
  if bgColor == "NONE" then
    bgColor = solidBgColor()
    local _, _, r, g, b = string.find(bgColor, '^#(%x%x)(%x%x)(%x%x)')
    r, g, b =
        math.floor(tonumber(r, 16)),
        math.floor(tonumber(g, 16)),
        math.floor(tonumber(b, 16))

    accentCol =
        [[#]] ..
        string.format('%02x', math.floor(r * 0.75)) ..
        string.format('%02x', math.floor(g * 0.75)) ..
        string.format('%02x', math.floor(b * 0.75))

    highlightCol =
        [[#]] ..
        string.format('%02x', math.floor(255 * 0.25 + (r * 0.75))) ..
        string.format('%02x', math.floor(255 * 0.25 + (g * 0.75))) ..
        string.format('%02x', math.floor(255 * 0.25 + (b * 0.75)))
  else
    bgColor = "NONE"
  end
  winSetHighlights(bgColor, accentCol, highlightCol)
  setupLualine(bgColor)
end

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

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    opts = {
      opleader = { line = '<leader>com', block = '<leader>bcom' },
    }
  },
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        -- Actions
        -- visual mode
        map('v', '<leader>ga', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[G]it [A]dd/stage hunk' })
        map('v', '<leader>gr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[G]it [R]eset hunk' })
        -- normal mode
        map('n', '<leader>k', gs.prev_hunk, { buffer = bufnr, desc = 'Go to previous Hunk' })
        map('n', '<leader>j', gs.next_hunk, { buffer = bufnr, desc = 'Go to next Hunk' })
        map('n', '<leader>ga', gs.stage_hunk, { buffer = bufnr, desc = '[G]it [A]dd/stage hunk' })
        map('n', '<leader>gA', gs.stage_buffer, { buffer = bufnr, desc = '[G]it add [A]ll hunks in buffer' })
        map('n', '<leader>gu', gs.undo_stage_hunk, { buffer = bufnr, desc = '[G]it [U]ndo hunk' })
        map('n', '<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = '[G]it [R]eset hunk' })
        map('n', '<leader>go', gs.preview_hunk_inline, { buffer = bufnr, desc = '[G]it [O]pen preview of hunk' })
        map('n', '<leader>gc', [[:Git commit<CR>]], { buffer = bufnr, desc = '[G]it [C]ommit' })
        map('n', '<leader>gp', [[:Git push<CR>]], { buffer = bufnr, desc = '[G]it [P]ush' })
        -- Toggles
        map('n', '<leader>gt', gs.toggle_current_line_blame, { buffer = bufnr, desc = '[G]it [T]oggle line blame' })
      end,
    },
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  { -- git worktree convenient plguin
    'ThePrimeagen/git-worktree.nvim'
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      }
    end,
  },

  -- database explorer like PGADmin, but native to NVIM
  'tpope/vim-dadbod',

  -- Remeber to install ripgrep in administer terminal `choco install ripgrep`
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'BurntSushi/ripgrep',
      'debugloop/telescope-undo.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("telescope").load_extension("undo")
      vim.keymap.set("n", "<leader>u", [[:Telescope undo<CR>]])
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require("telescope").load_extension, 'git_worktree')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })

      local function find_git_root()
        -- Use the current buffer's path as the starting point for the git search
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir
        local cwd = vim.fn.getcwd()
        -- If the buffer is not associated with a file, return nil
        if current_file == '' then
          current_dir = cwd
        else
          -- Extract the directory from the current file's path
          current_dir = vim.fn.fnamemodify(current_file, ':h')
        end

        -- Find the Git root directory from the current file's path
        local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
        if vim.v.shell_error ~= 0 then
          print 'Not a git repository. Searching on current working directory'
          return cwd
        end
        return git_root
      end

      local function live_grep_normal()
        require('telescope.builtin').live_grep {
          previewer = true,
          layout_strategy = 'vertical',
          layout_config = {
            vertical = { width = 0.8 },
            preview_cutoff = 1
          }
        }
      end

      local function live_grep_git_root()
        local git_root = find_git_root()
        if git_root then
          require('telescope.builtin').live_grep {
            search_dirs = { git_root },
            previewer = true,
            layout_strategy = 'vertical',
            layout_config = {
              vertical = { width = 0.8 },
              preview_cutoff = 1
            }
          }
        end
      end

      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sT', builtin.builtin, { desc = '[S]earch  [T]elescope built ins' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sC', live_grep_normal, { desc = '[S]earch [C]ontents' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sg', builtin.git_files, { desc = '[S]earch [G]it Files' })
      vim.keymap.set('n', '<leader>sc', live_grep_git_root, { desc = '[S]earch [c]ontents in Git Root' })
      -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>sx', builtin.commands, { desc = '[S]earch commands/e[X]ecutables' })

      vim.keymap.set('n', '<leader>sa', builtin.git_status, { desc = '[S]earch [A]ll git changes' })
      vim.keymap.set('n', '<leader>sr', [[:%s///g<Left><Left><Left>]], { desc = '[S]earch & global [R]eplace' })
      vim.keymap.set('v', '<leader>sr', [[:s///g<Left><Left><Left>]], { desc = '[S]earch & this [L]line [R]eplace' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>sG', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
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
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('<leader>K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {}
        pyright = {},
        rust_analyzer = {},
        html = { filetypes = { 'html', 'twig', 'hbs' } },
        eslint = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        tsserver = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = {
                globals = { 'vim' },
                -- disable = { 'missing-fields' }
              },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- 'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },



  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    -- event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        formatting = {
          format = function(entry, vim_item)
            if vim_item.kind == 'Color' and entry.completion_item.documentation then
              local _, _, r, g, b = string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
              if r then
                local color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
                local group = 'Tw_' .. color
                if vim.fn.hlID(group) < 1 then
                  vim.api.nvim_set_hl(0, group, { fg = '#' .. color })
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
        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          ['<C-c>'] = cmp.mapping.abort(),
          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'lab.quick_data', keyword_length = 4 },
        },
      }
    end,
  },

  -- Debugger plugin for neovim
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
  },

  -- shows little variable values inline in buffer as the debugger is running
  'theHamsta/nvim-dap-virtual-text',

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    compilers = { "clang" },
    opts = {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'vim', 'vimdoc',  'cpp', 'c_sharp', 'go', 'python', 'rust', 'tsx', 'javascript', 'typescript'},
      -- Autoinstall languages that are not installed
      auto_install = true,
      -- Install languages synchronously (only applied to `ensure_installed`)
      sync_install = false,
      -- List of parsers to ignore installing
      ignore_install = { "gitcommit", "markdown" },
      -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
      modules = {},
      highlight = {
        enable = true,
        disable = { "html" },
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby', 'html' } },
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
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  -- vim commands in the middle of the screen
  {
    'VonHeikemen/fine-cmdline.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    }
  },

  -- Ollama intregration into nvim
  'David-Kunz/gen.nvim',

  -- gives background colors to strings like "#6C7C2D" or "color: darkcyan"
  'brenoprata10/nvim-highlight-colors',

  {
    -- setting the theme
    'catppuccin/nvim',
    priority = 1000,
    lazy = false,
    name = "catppuccin",
    config = function()
      vim.cmd.colorscheme "catppuccin"
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
        lualine_a = { 'filename' },
        lualine_b = { 'filetype' },
        lualine_c = { 'diagnostics' },
        lualine_x = { 'diff' },
        lualine_y = { 'branch' },
        lualine_z = { 'fileformat', 'encoding' }
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'filetype' }
      }
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
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
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },

  "Asheq/close-buffers.vim",

  -- code runner for inline feedback for interpreted languages like js, python and lua
  {
    -- '0x100101/lab.nvim' fork
    'Edvid/lab.nvim',
    build = 'cd js && npm ci',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  }

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  here are some example plugins that i've included in the kickstart repository.
  --  uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      -- cmd = '⌘',
      -- config = '🛠',
      -- event = '📅',
      -- ft = '📂',
      -- init = '⚙',
      -- keys = '🗝',
      -- plugin = '🔌',
      -- runtime = '💻',
      -- require = '🌙',
      -- source = '📄',
      -- start = '🚀',
      -- task = '📌',
      -- lazy = '💤 ',
    },
  },
})


require('ibl').setup {
  indent = { char = "┆" },
}


-- local lualine_theme = require('lualine.themes.auto')
setupLualine()

require('lab').setup {}
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>o', require('telescope.builtin').oldfiles, { desc = '[O]pen recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>ss', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[S]earch in thi[s] buffer' })

require('nvim-highlight-colors').turnOn()

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

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
vim.api.nvim_set_keymap('n', 'æ', '<cmd>FineCmdline<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', 'æ', '<cmd>FineCmdline\'<,\'><CR>', { noremap = true })

require("git-worktree").setup({
  clearjumps_on_change = false -- default: true
})
vim.keymap.set('n', '<leader>wt<leader>', require('telescope').extensions.git_worktree.git_worktrees, { desc = '[W]ork [T]ree list all' })
vim.keymap.set('n', '<leader>wtc', require('telescope').extensions.git_worktree.create_git_worktree, { desc = '[W]ork [T]ree [C]reate' })

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
vim.keymap.set({ 'n', 'v' }, '<leader>Gch', [[:Gen Chat<CR>]], { desc = [[using [Gen] [ch]at with AI]] })
vim.keymap.set('v', '<leader>Gcc', [[:Gen Change_Code<CR>]], { desc = [[using [Gen], [C]hange [C]ode with AI]] })

vim.keymap.set('n', '<leader>dt', require('dapui').toggle, { desc = '[D]ebugger [T]oggle' })
vim.keymap.set('n', '<leader>db', [[:DapToggleBreakpoint<CR>]], { desc = '[D]ebugger toggle [B]reakpoint' })

-- Setup neovim lua configuration
require('neodev').setup()

-- Mason doesn't work well with gdscript, so we will setup manually
local dap = require('dap')
dap.adapters.godot = {
  type = 'server',
  host = '192.0.0.1',
  port = 6007,
}

dap.configurations.gdscript = {
  {
    type = 'godot',
    request = 'launch',
    name = 'Launch scene',
    project = '${workspaceFolder}',
    launch_scene = true,
  }
}

require('lspconfig').gdscript.setup {}

require("telescope").setup {
  extensions = {
    file_browser = {
      previewer = false,
      depth = 1,
      hidden = { file_browser = true, folder_browser = true },
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
}

require("telescope").load_extension "file_browser"

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

vim.keymap.set('n', '<leader>xx', [[:source ~/.config/nvim/init.lua<CR>]], { desc = 'source/E[X]ecute init' })
vim.keymap.set('n', '<leader>xt', [[:source %<CR>]], { desc = 'source/E[X]ecute [T]his' })

-- Toggle between always having the cursor centered and not doing so
local fixedLines = false

local function toggleFixedLines()
  if fixedLines then
    vim.opt.scrolloff = 6
  else
    vim.opt.scrolloff = 9999
  end
  fixedLines = not fixedLines
end

vim.keymap.set('n', '<leader>l', toggleFixedLines, { desc = 'fixed [L]ines' })

-- paste without destroying what you have in register
vim.keymap.set('v', '<leader>p', [["_dP]], { noremap = true, desc = [[[P]aste without loosing clipboard]] })

-- new file here and explore here keybinds
vim.keymap.set('n', '<leader>n', [[:FineCmdline edit %:p:h/<CR>]], { desc = [[edit/create [N]ew file here]] })
vim.keymap.set('n', '<leader>e', [[:Telescope file_browser<CR>]], { desc = [[[E]xplore from here]] })

vim.api.nvim_create_user_command("W",
  [[:w|silent !prettier % --write]], { desc = [[save and format with prettier]]}
)

-- better keybinds for netrw
vim.api.nvim_create_autocmd('filetype', {
  pattern = 'netrw',
  desc = 'Better keybinds for netrw',
  callback = function()
    local bind = function(new, old)
      vim.keymap.set('n', new, old, { remap = true, buffer = true })
    end

    -- edit new file
    bind('<leader>n', '%')

    -- rename file
    bind('r', 'R')
  end
})

vim.keymap.set({ 'n', 'i', 'v', 'o', 'c' }, '<A-s>', ToggleColor)

vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = [[#9CB8FF]] })

vim.keymap.set('n', '<leader>who', [[:G blame<CR>]])
vim.keymap.set('n', '<leader>cl', [[:Bd other<CR>]])
vim.keymap.set('n', '<leader>col', [[:FineCmdline set cc=<CR>]], { desc = 'Color in [COL]umn at given number' })

vim.keymap.set('n', '<leader>run', [[:Lab code run<CR>]], { desc = '[RUN] lab code runner' })
vim.keymap.set('n', '<leader>stop', [[:Lab code stop<CR>]], { desc = '[STOP] lab code runner' })

vim.keymap.set('n', '<leader>f', [[/]])
vim.keymap.set('x', '<leader>q', [[@]])

vim.keymap.set('n', 'gp', '`[v`]', { desc = "Reselect last pasted" })

vim.keymap.set('n', '<leader>J', [[mz<cmd>join<CR>`z]])

vim.keymap.set('n', 'J', [[:m +1<CR>==]])
vim.keymap.set('n', 'K', [[:m -2<CR>==]])
vim.keymap.set('v', 'K', [[:m '<-2<CR>gv=gv]])
vim.keymap.set('v', 'J', [[:m '>+1<CR>gv=gv]])

vim.keymap.set('n', '<leader>ck', [[:cprev<CR>]])
vim.keymap.set('n', '<leader>cj', [[:cnext<CR>]])

vim.keymap.set('v', '<leader>_', [[:norm! _]])

vim.keymap.set('n', '<A-d>', [[:bn<CR>]])
vim.keymap.set('n', '<A-a>', [[:bN<CR>]])
vim.keymap.set('n', '<A-1>', [[:bf<CR>]])
vim.keymap.set('n', '<A-2>', [[:bf<CR>:bn<CR>]])
vim.keymap.set('n', '<A-3>', [[:bf<CR>:2bn<CR>]])
vim.keymap.set('n', '<A-q>', [[:bf<CR>:3bn<CR>]])
vim.keymap.set('n', '<A-w>', [[:bf<CR>:4bn<CR>]])
vim.keymap.set('n', '<A-e>', [[:bf<CR>:5bn<CR>]])
vim.keymap.set({ 'n', 'v', 'o', 'c' }, '<C-z>', '<Nop>')

vim.opt.wrap = true
vim.opt.linebreak = true

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
