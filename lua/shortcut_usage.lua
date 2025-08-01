local M = {}

local freq_file = vim.fn.stdpath("data") .. "/shortcut_freq.json"
local freq = {}
local seq = ""
local last = vim.loop.hrtime()

local function load()
  local f = io.open(freq_file, "r")
  if f then
    local ok, data = pcall(vim.json.decode, f:read("*a"))
    if ok and type(data) == "table" then
      freq = data
    end
    f:close()
  end
end

local function save()
  local f = io.open(freq_file, "w")
  if f then
    f:write(vim.json.encode(freq))
    f:close()
  end
end

local function record(s)
  if s and #s > 0 then
    s = vim.fn.keytrans(s)
    freq[s] = (freq[s] or 0) + 1
  end
end

function M.setup()
  load()
  vim.on_key(function(ch)
    local now = vim.loop.hrtime()
    if (now - last) / 1e6 > 1000 then
      record(seq)
      seq = ""
    end
    seq = seq .. ch
    last = now
  end, M)
  vim.api.nvim_create_autocmd("VimLeavePre", { callback = save })
end

function M.top(n)
  local items = {}
  for k, v in pairs(freq) do
    table.insert(items, { key = k, count = v })
  end
  table.sort(items, function(a, b)
    return a.count > b.count
  end)
  local res = {}
  n = n or 10
  for i = 1, math.min(n, #items) do
    res[i] = items[i]
  end
  return res
end

function M.show_recommendations()
  local lines = { "Most used shortcuts:" }
  for _, item in ipairs(M.top(10)) do
    table.insert(lines, string.format("%s - %d", item.key, item.count))
  end
  vim.notify(table.concat(lines, "\n"))
end

return M
