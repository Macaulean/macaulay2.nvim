-- Plugin entry point for macaulay2.nvim
-- This file is loaded automatically by Neovim

-- Prevent double loading
if vim.g.loaded_macaulay2 then
  return
end
vim.g.loaded_macaulay2 = true

-- Initialize with default configuration
-- Users can call require("macaulay2").setup() to customize
require("macaulay2").setup()
