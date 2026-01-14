-- Health check for macaulay2.nvim
local M = {}

local health = vim.health

function M.check()
  health.start("macaulay2.nvim")

  -- Check Neovim version
  if vim.fn.has("nvim-0.8.0") == 1 then
    health.ok("Neovim version >= 0.8.0")
  else
    health.error("Neovim version >= 0.8.0 required")
  end

  -- Check for M2 executable
  local config = require("macaulay2.config").get()
  local m2_cmd = config.repl.cmd

  if vim.fn.executable(m2_cmd) == 1 then
    -- Try to get version
    local handle = io.popen(m2_cmd .. " --version 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      if result and result ~= "" then
        local version = result:match("version%s+([%d%.]+)") or result:match("Macaulay2%s+([%d%.]+)")
        if version then
          health.ok("Macaulay2 found: version " .. version)
        else
          health.ok("Macaulay2 found: " .. m2_cmd)
        end
      else
        health.ok("Macaulay2 found: " .. m2_cmd)
      end
    else
      health.ok("Macaulay2 found: " .. m2_cmd)
    end
  else
    health.warn("Macaulay2 executable not found: " .. m2_cmd)
    health.info("Install Macaulay2 from https://macaulay2.com")
    health.info("Or configure a different path: require('macaulay2').setup({ repl = { cmd = '/path/to/M2' } })")
  end

  -- Check for nvim-cmp (optional)
  local has_cmp = pcall(require, "cmp")
  if has_cmp then
    health.ok("nvim-cmp found (completion enabled)")
  else
    health.info("nvim-cmp not found (completion disabled)")
    health.info("Install nvim-cmp for autocompletion support")
  end

  -- Check configuration
  health.start("Configuration")
  health.ok("REPL command: " .. config.repl.cmd)
  health.ok("REPL direction: " .. config.repl.direction)
  health.ok("REPL size: " .. tostring(config.repl.size))
  health.ok("Completion enabled: " .. tostring(config.completion.enabled))
  health.ok("Keymaps enabled: " .. tostring(config.keymaps.enabled))
end

return M
