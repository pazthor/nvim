-- Description: LSP configuration and mason setup
-- Dependencies: nvim-lspconfig, mason.nvim, utils.lsp
-- Purpose: Central LSP configuration using shared utilities

local lsp_utils = require("utils.lsp")
local settings = require("core.settings")

return {
  -- Core LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      -- Initialize LSP utilities
      lsp_utils.setup()
    end,
  },

  -- Mason package manager
  {
    "mason-org/mason.nvim",
    opts = vim.tbl_extend("force", settings.mason, {
      ensure_installed = vim.list_extend(settings.mason.ensure_installed, {
        -- Additional tools can be added by other modules
      }),
    }),
  },

  -- Mason LSP config integration
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "jsonls",
        "yamlls",
        "intelephense",
      },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Setup servers with default configuration
      require("mason-lspconfig").setup_handlers({
        -- Default handler for all servers
        function(server_name)
          local server_opts = lsp_utils.servers[server_name] or {}
          local config = lsp_utils.create_server_config(server_opts)
          require("lspconfig")[server_name].setup(config)
        end,
      })
    end,
  },

  -- Schema store for JSON/YAML
  {
    "b0o/schemastore.nvim",
    ft = { "json", "yaml" },
  },
}

