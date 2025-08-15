-- Description: Shared LSP configuration utilities and common settings
-- Dependencies: nvim-lspconfig, utils.keymaps
-- Purpose: Provides reusable LSP configurations and setup functions

local M = {}
local keymaps = require("utils.keymaps")

-- Common LSP server settings that can be reused
M.default_settings = {
  capabilities = nil, -- Will be set in setup
  on_attach = nil,    -- Will be set in setup
}

-- Common file ignore patterns for all LSP servers
M.common_ignore_patterns = {
  "**/node_modules/**",
  "**/vendor/**",
  "**/.git/**",
  "**/storage/**",
  "**/bootstrap/cache/**",
  "**/.env",
  "**/.env.*",
}

-- Default capabilities with cmp integration
function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
  -- Add completion capabilities if nvim-cmp is available
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end
  
  -- Enable folding support
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  
  return capabilities
end

-- Default on_attach function with common LSP keymaps
function M.on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- LSP keymaps using the keymap utility
  local lsp_maps = {
    { lhs = "gD", rhs = vim.lsp.buf.declaration, desc = "Go to declaration" },
    { lhs = "gd", rhs = vim.lsp.buf.definition, desc = "Go to definition" },
    { lhs = "K", rhs = vim.lsp.buf.hover, desc = "Hover documentation" },
    { lhs = "gi", rhs = vim.lsp.buf.implementation, desc = "Go to implementation" },
    { lhs = "<C-k>", rhs = vim.lsp.buf.signature_help, desc = "Signature help" },
    { lhs = "gr", rhs = vim.lsp.buf.references, desc = "Go to references" },
  }
  
  for _, map in ipairs(lsp_maps) do
    keymaps.buf_map(bufnr, "n", map.lhs, map.rhs, { desc = map.desc })
  end
  
  -- Leader-based LSP keymaps
  keymaps.lsp_map(bufnr, "wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  keymaps.lsp_map(bufnr, "wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  keymaps.lsp_map(bufnr, "wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
  keymaps.lsp_map(bufnr, "D", vim.lsp.buf.type_definition, "Type definition")
  keymaps.lsp_map(bufnr, "rn", vim.lsp.buf.rename, "Rename")
  keymaps.lsp_map(bufnr, "ca", vim.lsp.buf.code_action, "Code action")
  keymaps.lsp_map(bufnr, "f", function()
    vim.lsp.buf.format({ async = true })
  end, "Format")
  
  -- Diagnostic keymaps
  keymaps.lsp_map(bufnr, "e", vim.diagnostic.open_float, "Open float")
  keymaps.lsp_map(bufnr, "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
  keymaps.lsp_map(bufnr, "]d", vim.diagnostic.goto_next, "Next diagnostic")
  keymaps.lsp_map(bufnr, "q", vim.diagnostic.setloclist, "Set loclist")
end

-- Setup function to initialize default LSP settings
function M.setup()
  M.default_settings.capabilities = M.get_capabilities()
  M.default_settings.on_attach = M.on_attach
  
  -- Configure diagnostic display
  vim.diagnostic.config({
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
  })
  
  -- Configure LSP handlers
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })
  
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

-- Helper to create server configuration with defaults
function M.create_server_config(server_opts)
  return vim.tbl_deep_extend("force", M.default_settings, server_opts or {})
end

-- Common server configurations
M.servers = {
  -- Lua language server
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { 
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  },
  
  -- JSON language server
  jsonls = {
    settings = {
      json = {
        -- Note: schemas require schemastore.nvim plugin
        -- schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  
  -- YAML language server  
  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        -- Note: schemas require schemastore.nvim plugin
        -- schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
}

return M