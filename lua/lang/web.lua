-- Description: Web development support (JavaScript, TypeScript, Svelte, CSS, HTML)
-- Dependencies: nvim-treesitter, nvim-lspconfig, conform.nvim, nvim-lint
-- Keybindings: <leader>ns/nu/ni for package.json operations

local lsp_utils = require("utils.lsp")
local settings = require("core.settings")

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
        svelte = {},
        html = {},
        cssls = {},
        tailwindcss = {
          filetypes = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
        },
      },
    },
  },

  -- Enhanced Treesitter support for web languages
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
        "json",
        "yaml",
      })
    end,
  },

  -- Formatting with Prettier
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
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
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
      },
    },
  },

  -- Package.json support
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    ft = "json",
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

  -- Mason tools for web development
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- JavaScript/TypeScript
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
        "eslint_d",

        -- Svelte
        "svelte-language-server",

        -- Web technologies
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
      })
    end,
  },
}