-- Description: Utility functions for creating and managing keymaps
-- Dependencies: None
-- Purpose: Provides helper functions for consistent keymap creation across config files

local M = {}

-- Helper function to create keymaps with consistent options
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Create multiple keymaps at once
function M.map_table(maps)
  for _, map in ipairs(maps) do
    M.map(map.mode or "n", map.lhs, map.rhs, map.opts)
  end
end

-- Create leader-based keymaps with consistent prefix
function M.leader_map(suffix, rhs, opts, mode)
  mode = mode or "n"
  local lhs = "<leader>" .. suffix
  M.map(mode, lhs, rhs, opts)
end

-- Create buffer-local keymaps (useful for filetype-specific mappings)
function M.buf_map(bufnr, mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true, buffer = bufnr }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Create telescope-based keymap with consistent telescope command format
function M.telescope_map(suffix, command, desc, mode)
  mode = mode or "n"
  local cmd = string.format("<cmd>Telescope %s<cr>", command)
  M.leader_map(suffix, cmd, { desc = desc }, mode)
end

-- Create LSP keymap helper for consistent LSP bindings
function M.lsp_map(bufnr, suffix, rhs, desc, mode)
  mode = mode or "n"
  M.buf_map(bufnr, mode, "<leader>" .. suffix, rhs, { desc = desc })
end

-- Create which-key group registration helper
function M.which_key_group(prefix, name)
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add({
      { prefix, group = name },
    })
  end
end

return M