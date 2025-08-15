-- Description: Common plugin settings and configurations shared across the setup
-- Dependencies: None
-- Purpose: Centralized settings for consistent plugin behavior

local M = {}

-- Common file ignore patterns used across multiple plugins
M.ignore_patterns = {
  "node_modules",
  ".git",
  "vendor",
  "storage",
  "bootstrap/cache",
  ".env",
  ".env.*",
  "*.log",
  "*.tmp",
  "*.temp",
  ".DS_Store",
  "thumbs.db",
  "*.swp",
  "*.swo",
  "*.bak",
}

-- Common telescope settings
M.telescope = {
  defaults = {
    file_ignore_patterns = M.ignore_patterns,
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    sorting_strategy = "ascending",
    winblend = 0,
    border = true,
    color_devicons = true,
    use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" },
  },
}

-- Common LSP server settings
M.lsp = {
  border = "rounded",
  diagnostics = {
    virtual_text = {
      prefix = "●",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  },
}

-- Common treesitter settings
M.treesitter = {
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "yaml",
    "markdown",
    "markdown_inline",
    "bash",
    "php",
    "svelte",
    "sql",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
}

-- Common Mason tool lists
M.mason = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  -- Core tools that should be installed for most setups
  ensure_installed = {
    -- Lua
    "lua-language-server",
    "stylua",

    -- JSON/YAML
    "json-lsp",
    "yaml-language-server",

    -- General formatting
    "prettier",
    "eslint_d",
  },
}

-- Common buffer and window settings
M.ui = {
  -- Buffer-related settings
  buffer = {
    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    separator_style = "slant",
    always_show_bufferline = true,
  },

  -- Window and float settings
  float = {
    border = "rounded",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },

  -- Icons and symbols
  icons = {
    git = {
      added = "✚",
      deleted = "✖",
      modified = "",
      renamed = "➜",
      untracked = "★",
      ignored = "◌",
      unstaged = "✗",
      staged = "✓",
      conflict = "",
    },
    diagnostics = {
      error = "",
      warn = "",
      info = "",
      hint = "",
    },
  },
}

-- Terminal settings
M.terminal = {
  size = 20,
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  float_opts = M.ui.float,
}

-- Project management settings
M.project = {
  base_dirs = {
    "~/PhpstormProjects/",
    "~/Projects/",
  },
  detection_methods = { "lsp", "pattern" },
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "composer.json" },
  exclude_dirs = M.ignore_patterns,
}

-- Completion settings
M.completion = {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = {
      border = M.lsp.border,
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
    },
    documentation = {
      border = M.lsp.border,
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Use simple icons if LazyVim icons not available
      local kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      }

      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
}

return M

