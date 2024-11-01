-- Configuración básica
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.mouse = "a"
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/.local/bin")
vim.fn.serverstart("/tmp/nvim.pipe")
local config_path = vim.fn.stdpath('config')
package.path = package.path .. ';' .. config_path .. '/?.lua'

-- Configuración de la fuente
vim.o.guifont = "Noto Sans CJK JP:h12"
vim.g.neovide_font_hinting = "full"
vim.g.neovide_font_antialiasing = "subpixel"

-- Activar ligaduras
vim.g.neovide_ligatures = true

-- Instalación de Packer si no está instalado
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

-- Configuración de plugins
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  
  -- Tema Catppuccin
  use { "catppuccin/nvim", as = "catppuccin" }
  
  -- Barra de estado
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  
  -- Explorador de archivos mejorado
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    }
  }
  
  -- Autocompletado y snippets
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  
  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  
  -- Resaltado de sintaxis mejorado
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  
  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- GitHub Copilot
  use 'github/copilot.vim'

  -- Git integration
  use 'lewis6991/gitsigns.nvim'

  -- Indent guides
  use 'lukas-reineke/indent-blankline.nvim'

  -- Auto pairs
  use 'windwp/nvim-autopairs'

  -- Comment toggler
  use 'numToStr/Comment.nvim'

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'mfussenegger/nvim-dap-python'
  use 'nvim-neotest/nvim-nio'

  -- Session management
  use 'rmagatti/auto-session'

  -- Startup screen
  use 'goolord/alpha-nvim'

  -- Markdown preview
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- Todo comments
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
  }

  -- Which key
  use "folke/which-key.nvim"

  -- Smooth scrolling
  use 'karb94/neoscroll.nvim'

  -- Better terminal integration
  use {"akinsho/toggleterm.nvim", tag = '*'}

  -- Surround
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
  })

  -- Autoformatting
  use 'jose-elias-alvarez/null-ls.nvim'

  -- Python specific
  use 'vim-test/vim-test'
  use 'raimon49/requirements.txt.vim'

  -- Notificaciones
  use 'rcarriga/nvim-notify'

  -- Gestor de proyectos
  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- Barra de buffers
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

  -- Navegar entre buffers
  use 'christoomey/vim-tmux-navigator'

  -- Visualización de colores
  use 'norcalli/nvim-colorizer.lua'

  -- Pantalla de inicio personalizada
  use {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  }
end)

-- Cargar los colores generados dinámicamente
local dynamic_colors = dofile(vim.fn.stdpath('config') .. '/colors.lua')

-- Configuración del tema Catppuccin
require("catppuccin").setup({
    flavour = "macchiato", -- Puedes cambiar esto si lo deseas
    background = {
        light = "latte",
        dark = "macchiato",
    },
    transparent_background = true,
    show_end_of_buffer = false,
    term_colors = true,
    dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.20,
    },
    no_italic = false,
    no_bold = false,
    no_underline = false,
    styles = {
        comments = { "italic" },
        conditionals = { "italic", "bold" },
        loops = { "bold" },
        functions = { "bold" },
        keywords = { "italic" },
        strings = {},
        variables = {},
        numbers = { "bold" },
        booleans = { "bold", "italic" },
        properties = {},
        types = { "italic" },
        operators = { "bold" },
    },
    color_overrides = {
        macchiato = dynamic_colors,
    },
    custom_highlights = {
        CursorLine = { bg = dynamic_colors.surface0 },
        LineNr = { fg = dynamic_colors.overlay0 },
        CursorLineNr = { fg = dynamic_colors.pink, style = { "bold" } },
        DiagnosticError = { fg = dynamic_colors.red },
        DiagnosticWarn = { fg = dynamic_colors.yellow },
        DiagnosticInfo = { fg = dynamic_colors.blue },
        DiagnosticHint = { fg = dynamic_colors.green },
        MatchParen = { fg = dynamic_colors.peach, bg = dynamic_colors.surface1, style = { "bold" } },
        Pmenu = { bg = dynamic_colors.surface0 },
        PmenuSel = { bg = dynamic_colors.surface1, fg = dynamic_colors.text },
        Search = { bg = dynamic_colors.surface2, fg = dynamic_colors.text },
        IncSearch = { bg = dynamic_colors.peach, fg = dynamic_colors.base },
        StatusLine = { bg = dynamic_colors.mantle, fg = dynamic_colors.text },
        NvimTreeNormal = { bg = dynamic_colors.mantle },
        NvimTreeFolderIcon = { fg = dynamic_colors.yellow },
        NvimTreeFolderName = { fg = dynamic_colors.blue },
        NvimTreeOpenedFolderName = { fg = dynamic_colors.blue, style = { "bold" } },
    },
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = {
            enabled = true,
            indentscope_color = dynamic_colors.surface1,
        },
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
        },
        telescope = true,
        which_key = true,
    },
})

-- Aplicar el tema
vim.cmd.colorscheme "catppuccin"

-- Personalización adicional para un aspecto más japonés
local colors = require("catppuccin.palettes").get_palette()
vim.api.nvim_set_hl(0, "Normal", { bg = colors.base, fg = colors.text })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.mantle })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.blue })
vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.surface0 })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.lavender, bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = colors.overlay0 })
vim.api.nvim_set_hl(0, "Pmenu", { bg = colors.surface0 })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.pink, fg = colors.base })

-- Configuración de lualine para un aspecto más japonés
require('lualine').setup {
  options = {
    theme = 'catppuccin',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

-- Configuración del explorador de archivos
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- Configuración de autocompletado
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Configuración de LSP
require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}
-- Agrega más servidores LSP según sea necesario

-- Configuración de Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "lua" },
  highlight = {
    enable = true,
  },
}

-- Configuración de nvim-tree para un aspecto más japonés
require'nvim-tree'.setup {
  view = {
    width = 30,
    side = 'left',
  },
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}

-- Configuración de bufferline para un aspecto más japonés
require("bufferline").setup{
  options = {
    separator_style = "slant",
    indicator = {
      icon = '▎',
      style = 'icon',
    },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
  }
}



-- Configuración de Gitsigns
require('gitsigns').setup()

-- Configuración de indent-blankline
require("ibl").setup()

-- Configuración de nvim-autopairs
require('nvim-autopairs').setup{}

-- Configuración de Comment.nvim
require('Comment').setup()

-- Configuración de nvim-dap (debugger)
local dap = require('dap')
local dapui = require('dapui')

dapui.setup()
require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Configuración de auto-session
require('auto-session').setup {
  log_level = 'error',
  auto_session_suppress_dirs = {'~/', '~/Projects', '~/Downloads', '/'},
}

-- Configuración de alpha-nvim
-- Requiere la instalación de la fuente Nerd neovide_font 
-- y la fuente FiraCode Nerd Font 
local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
dashboard.section.header.val = {

    "          ▀████▀▄▄              ▄█ ",
    "            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ",
    "    ▄        █          ▀▀▀▀▄  ▄▀  ",
    "   ▄▀ ▀▄      ▀▄              ▀▄▀  ",
    "  ▄▀    █     █▀   ▄█▀▄      ▄█    ",
    "  ▀▄     ▀▄  █     ▀██▀     ██▄█   ",
    "   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ",
    "    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ",
    "   █   █  █      ▄▄           ▄▀   ",
}

dashboard.section.buttons.val = {
    dashboard.button("e", "  新規ファイル", ":enew<CR>"),
    dashboard.button("f", "  ファイル検索", ":Telescope find_files<CR>"),
    dashboard.button("g", "  グレップ検索", ":Telescope live_grep<CR>"),
    dashboard.button("b", "  バッファ一覧", ":Telescope buffers<CR>"),
    dashboard.button("h", "  ヘルプ", ":Telescope help_tags<CR>"),
}

dashboard.section.footer.val = {
    "                                                ",
    "   技術と想像力の融合                           ",
    "   未来を創造するコードの世界へようこそ         ",
    "   新たな地平線を目指して                       ",
    "   イノベーションの花が咲く場所                 ",
    "                                                ",
}

alpha.setup(dashboard.opts) 

-- Configuración de todo-comments
require("todo-comments").setup {}

-- Configuración de which-key
require("which-key").setup {}

-- Configuración de neoscroll
require('neoscroll').setup()

-- Configuración de toggleterm
require("toggleterm").setup{
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}

-- Configuración de nvim-surround
require("nvim-surround").setup({
    -- Configuration here, or leave empty to use defaults
})

-- Configuración de null-ls para autoformateo
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.diagnostics.flake8.with({
            command = vim.fn.expand("~/.local/bin/flake8"),
        }),
    },
})

-- Configurar formateo automático al guardar
vim.cmd [[autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync()]]

-- Configuración de vim-test
vim.g['test#strategy'] = "neovim"
vim.g['test#python#runner'] = "pytest"

-- Configuración de notificaciones
vim.notify = require("notify")

-- Configuración del gestor de proyectos
require("project_nvim").setup {
  -- Detección de proyectos:
  -- "lsp" Utiliza el directorio raíz del servidor LSP
  -- "pattern" Utiliza un patrón para detectar el directorio raíz del proyecto
  detection_methods = { "lsp", "pattern" },

  -- Patrones para detectar el directorio raíz del proyecto
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

  -- Mostrar proyectos recientes en telescope
  show_hidden = false,
}

-- Integración del gestor de proyectos con telescope
require('telescope').load_extension('projects')

-- Configuración de bufferline
require("bufferline").setup{}

-- Configuración de colorizer
require'colorizer'.setup()

-- Atajos de teclado
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Explorador de archivos
map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

-- Fuzzy finder
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts)
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opts)
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opts)
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opts)

-- LSP
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

-- Guardar y salir rápidamente
map('n', '<leader>w', ':w<CR>', opts)
map('n', '<leader>q', ':q<CR>', opts)

-- Navegación entre ventanas
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

-- GitHub Copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Debugging
map('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', opts)
map('n', '<leader>dc',  '<cmd>lua require"dap".continue()<CR>', opts)
map('n', '<leader>di', '<cmd>lua require"dap".step_into()<CR>', opts)
map('n', '<leader>do', '<cmd>lua require"dap".step_over()<CR>', opts)
map('n', '<leader>dO', '<cmd>lua require"dap".step_out()<CR>', opts)
map('n', '<leader>dr', '<cmd>lua require"dap".repl.toggle()<CR>', opts)
map('n', '<leader>dl', '<cmd>lua require"dap".run_last()<CR>', opts)
map('n', '<leader>du', '<cmd>lua require"dapui".toggle()<CR>', opts)
map('n', '<leader>dt', '<cmd>lua require"dap".terminate()<CR>', opts)

-- Markdown preview
map('n', '<leader>mp', ':MarkdownPreview<CR>', opts)
map('n', '<leader>ms', ':MarkdownPreviewStop<CR>', opts)
map('n', '<leader>mt', ':MarkdownPreviewToggle<CR>', opts)

-- Autoformateo
map('n', '<leader>f', ':lua vim.lsp.buf.formatting()<CR>', opts)

-- Ejecutar pruebas
map('n', '<leader>tn', ':TestNearest<CR>', opts)
map('n', '<leader>tf', ':TestFile<CR>', opts)
map('n', '<leader>ts', ':TestSuite<CR>', opts)
map('n', '<leader>tl', ':TestLast<CR>', opts)
map('n', '<leader>tv', ':TestVisit<CR>', opts)

-- Gestor de proyectos
map('n', '<leader>fp', ':Telescope projects<CR>', opts)

-- Navegación entre buffers
map('n', '<leader>bn', ':bnext<CR>', opts)
map('n', '<leader>bp', ':bprevious<CR>', opts)
map('n', '<leader>bd', ':bdelete<CR>', opts)

-- Obtener colores de Catppuccin para personalización
local macchiato = require("catppuccin.palettes").get_palette "macchiato"

-- Ejemplo de personalización de resaltado
vim.api.nvim_set_hl(0, "Normal", { bg = macchiato.base, fg = macchiato.text })
vim.api.nvim_set_hl(0, "LineNr", { fg = macchiato.overlay0 })
vim.api.nvim_set_hl(0, "CursorLine", { bg = macchiato.surface0 })

-- Configuración adicional para Python
vim.g.python3_host_prog = '/usr/bin/python3'  -- Asegúrate de que esta ruta sea correcta para tu sistema

-- Configurar pyright para un mejor soporte de LSP
require'lspconfig'.pyright.setup{
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
}

-- Autocomandos para Python 
vim.cmd([[
  augroup python_files
    autocmd!
    autocmd FileType python setlocal colorcolumn=88
    autocmd BufWritePre *.py lua vim.lsp.buf.format()
  augroup END
]])


-- Configurar isort para ordenar las importaciones
vim.g.vim_isort_python_version = 'python3'
