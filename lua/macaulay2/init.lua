-- macaulay2.nvim - Neovim plugin for Macaulay2
local M = {}

local config = require("macaulay2.config")
local commands = require("macaulay2.commands")
local keymaps = require("macaulay2.keymaps")

-- Track if setup has been called
local is_setup = false

-- Setup the plugin with optional configuration
function M.setup(opts)
  if is_setup then
    return
  end

  -- Initialize configuration
  config.setup(opts)

  -- Setup commands
  commands.setup()

  -- Setup Plug mappings
  keymaps.setup_plug_mappings()

  -- Setup completion if enabled
  local cfg = config.get()
  if cfg.completion.enabled then
    local ok, completion = pcall(require, "macaulay2.completion")
    if ok then
      completion.setup()
    end
  end

  is_setup = true
end

-- Re-export submodules for convenience
M.repl = require("macaulay2.repl")
M.config = config

return M
