-- Configuration management for macaulay2.nvim
local M = {}

-- Default configuration
M.defaults = {
  repl = {
    cmd = "M2",
    args = {},
    direction = "vertical", -- "vertical", "horizontal", "float", "tab"
    size = 0.4,
    float_opts = {
      border = "rounded",
      width = 0.8,
      height = 0.8,
    },
  },
  completion = {
    enabled = true,
  },
  keymaps = {
    enabled = true,
    prefix = "<localleader>",
  },
}

-- Current configuration (will be populated by setup)
M.options = {}

-- Deep merge tables
local function deep_merge(base, override)
  local result = vim.deepcopy(base)
  for k, v in pairs(override) do
    if type(v) == "table" and type(result[k]) == "table" then
      result[k] = deep_merge(result[k], v)
    else
      result[k] = v
    end
  end
  return result
end

-- Initialize configuration
function M.setup(opts)
  opts = opts or {}
  M.options = deep_merge(M.defaults, opts)
  return M.options
end

-- Get current configuration
function M.get()
  if vim.tbl_isempty(M.options) then
    M.options = vim.deepcopy(M.defaults)
  end
  return M.options
end

return M
