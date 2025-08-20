-- Description: PHP and Laravel development support
-- Dependencies: nvim-lspconfig, laravel.nvim, conform.nvim, nvim-lint
-- Keybindings: <leader>la/lr/lm for Laravel operations

local lsp_utils = require("utils.lsp")

-- Read Intelephense license if available
local licence_path = vim.fn.expand("~/.config/intelephense/licence.txt")
local licence_key = ""
if vim.fn.filereadable(licence_path) == 1 then
  licence_key = vim.fn.trim((vim.fn.readfile(licence_path)[1] or ""))
end

return {
  -- PHP Language Server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          filetypes = { "php" },
          settings = {
            intelephense = {
              licenceKey = licence_key,
              files = {
                maxSize = 1000000,
                associations = { "*.php", "*.phtml" },
                exclude = {
                  "**/node_modules/**",
                  "**/vendor/**/Tests/**",
                  "**/vendor/**/tests/**",
                  "**/.git/**",
                },
              },
              completion = {
                fullyQualifyGlobalConstantsAndFunctions = false,
                triggerParameterHints = true,
                insertUseDeclaration = true,
              },
              format = {
                enable = true,
                braces = "psr12",
              },
              environment = {
                includePaths = { "vendor/" },
              },
              diagnostics = {
                enable = true,
                undefinedVariables = false,
              },
              telemetry = {
                enabled = false,
              },
            },
          },
        },
      },
    },
  },

  -- Enhanced Treesitter support for PHP
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "php",
        "blade",
      })
    end,
  },

  -- Laravel Blade support and Laravel tools
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "kevinhwang91/nvim-ufo",
    },
    cmd = { "Laravel" },
    keys = {
      { "<leader>la", ":Laravel artisan<cr>", desc = "Laravel artisan" },
      { "<leader>lr", ":Laravel routes<cr>", desc = "Laravel routes" },
      { "<leader>lm", ":Laravel related<cr>", desc = "Laravel related" },
    },
    event = { "VeryLazy" },
    opts = {
      lsp_server = "intelephense",
      features = {
        null_ls = {
          enable = true,
        },
      },
    },
  },

  -- PHP formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        php = { "php_cs_fixer" },
      },
    },
  },

  -- PHP linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        php = { "phpstan" },
      },
    },
  },

  -- Mason tools for PHP development
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- PHP/Laravel
        "intelephense",
        "php-cs-fixer",
        "phpstan",
      })
    end,
  },
}

