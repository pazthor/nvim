return {
  -- SvelteJS Support
  {
    "leafOfTree/vim-svelte-plugin",
    ft = "svelte",
    config = function()
      vim.g.vim_svelte_plugin_use_typescript = 1
      vim.g.vim_svelte_plugin_use_sass = 1
    end,
  },

  -- Enhanced Svelte support with Tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "svelte",
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "php",
        "blade",
        "json",
        "yaml",
        "sql",
      })
    end,
  },

  -- PHP Support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpactor = {
          filetypes = { "php" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("composer.json", ".git")(fname)
          end,
        },
        intelephense = {
          filetypes = { "php" },
          settings = {
            intelephense = {
              files = {
                maxSize = 1000000,
              },
            },
          },
        },
      },
    },
  },

  -- Laravel Blade support
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

  -- Enhanced JavaScript/TypeScript support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = {
          filetypes = { "vue", "typescript", "javascript" },
        },
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      },
    },
  },

  -- ESLint and Prettier integration
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        php = { "php_cs_fixer" },
      },
    },
  },

  -- Enhanced linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
        svelte = { "eslint" },
        php = { "phpstan" },
      },
    },
  },

  -- Mason tool installer
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- JavaScript/TypeScript
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
        "eslint_d",
        
        -- PHP/Laravel
        "intelephense",
        "phpactor",
        "php-cs-fixer",
        "phpstan",
        
        -- Svelte
        "svelte-language-server",
        
        -- General
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "yaml-language-server",
        "tailwindcss-language-server",
      },
    },
  },

  -- Package.json support
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("package-info").setup()
    end,
    keys = {
      { "<leader>ns", "<cmd>lua require('package-info').show()<cr>", desc = "Show package info" },
      { "<leader>nc", "<cmd>lua require('package-info').hide()<cr>", desc = "Hide package info" },
      { "<leader>nt", "<cmd>lua require('package-info').toggle()<cr>", desc = "Toggle package info" },
      { "<leader>nu", "<cmd>lua require('package-info').update()<cr>", desc = "Update package" },
      { "<leader>nd", "<cmd>lua require('package-info').delete()<cr>", desc = "Delete package" },
      { "<leader>ni", "<cmd>lua require('package-info').install()<cr>", desc = "Install package" },
      { "<leader>np", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change package version" },
    },
  },
}