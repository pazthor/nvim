local M = {}

-- Get project session file path
local function get_session_path()
  local cwd = vim.fn.getcwd()
  local session_dir = vim.fn.stdpath("data") .. "/sessions"
  vim.fn.mkdir(session_dir, "p")
  local session_name = cwd:gsub("/", "_"):gsub("^_", "")
  return session_dir .. "/" .. session_name .. ".vim"
end

-- Save current session
local function save_session()
  local session_path = get_session_path()
  vim.cmd("mksession! " .. session_path)
  vim.notify("Session saved: " .. vim.fn.fnamemodify(session_path, ":t"))
end

-- Load session if it exists
local function load_session()
  local session_path = get_session_path()
  if vim.fn.filereadable(session_path) == 1 then
    vim.cmd("source " .. session_path)
    vim.notify("Session loaded: " .. vim.fn.fnamemodify(session_path, ":t"))
    return true
  end
  return false
end

-- Close all buffers except current
local function close_all_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  
  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) then
      local buf_type = vim.api.nvim_buf_get_option(buf, "buftype")
      if buf_type == "" then -- Only close normal buffers
        vim.api.nvim_buf_delete(buf, { force = false })
      end
    end
  end
end

-- Clear harpoon marks
local function clear_harpoon()
  local ok, harpoon = pcall(require, "harpoon")
  if ok then
    harpoon:list():clear()
  end
end

-- Close current project
function M.close_project()
  -- Save session first
  save_session()
  
  -- Close all buffers
  close_all_buffers()
  
  -- Clear harpoon marks
  clear_harpoon()
  
  -- Create a scratch buffer
  vim.cmd("enew")
  vim.api.nvim_buf_set_option(0, "buftype", "nofile")
  vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(0, "swapfile", false)
  
  vim.notify("Project closed and session saved")
end

-- Open project with session loading
function M.open_project()
  require("telescope").extensions.project.project({
    action = function(prompt_bufnr)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      
      local selection = action_state.get_selected_entry()
      actions.close(prompt_bufnr)
      
      if selection then
        -- Change to project directory
        vim.cmd("cd " .. selection.value)
        
        -- Try to load session
        if not load_session() then
          -- If no session, open file explorer
          vim.cmd("Telescope find_files")
        end
      end
    end
  })
end

-- Switch project (close current + open new)
function M.switch_project()
  -- Ask for confirmation if there are unsaved changes
  local modified_buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "modified") then
      table.insert(modified_buffers, buf)
    end
  end
  
  if #modified_buffers > 0 then
    local choice = vim.fn.confirm(
      "You have unsaved changes. Save before switching projects?",
      "&Save and switch\n&Switch without saving\n&Cancel",
      1
    )
    
    if choice == 1 then
      vim.cmd("wa") -- Save all
    elseif choice == 3 then
      return -- Cancel
    end
  end
  
  -- Close current project
  save_session()
  close_all_buffers()
  clear_harpoon()
  
  -- Open project picker
  M.open_project()
end

return M