-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-save sessions on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("ProjectSession", { clear = true }),
  callback = function()
    local cwd = vim.fn.getcwd()
    -- Only save session if we're in a project directory
    if cwd:match("PhpstormProjects") or cwd:match("Projects") then
      local session_dir = vim.fn.stdpath("data") .. "/sessions"
      vim.fn.mkdir(session_dir, "p")
      local session_name = cwd:gsub("/", "_"):gsub("^_", "")
      local session_path = session_dir .. "/" .. session_name .. ".vim"
      vim.cmd("mksession! " .. session_path)
    end
  end,
})

-- Auto-load session on startup if in project directory and no arguments
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("ProjectSessionLoad", { clear = true }),
  callback = function()
    -- Only auto-load if no arguments were passed and we're in a project
    if vim.fn.argc() == 0 then
      local cwd = vim.fn.getcwd()
      if cwd:match("PhpstormProjects") or cwd:match("Projects") then
        local session_dir = vim.fn.stdpath("data") .. "/sessions"
        local session_name = cwd:gsub("/", "_"):gsub("^_", "")
        local session_path = session_dir .. "/" .. session_name .. ".vim"
        if vim.fn.filereadable(session_path) == 1 then
          vim.defer_fn(function()
            vim.cmd("source " .. session_path)
          end, 100)
        end
      end
    end
  end,
})
