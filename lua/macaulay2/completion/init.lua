-- Completion module for macaulay2.nvim
local M = {}

local source = require("macaulay2.completion.source")

-- Setup nvim-cmp source
function M.setup()
  local has_cmp, cmp = pcall(require, "cmp")
  if not has_cmp then
    return false
  end

  -- Register the source
  cmp.register_source("macaulay2", source.new())

  -- Setup for macaulay2 filetype
  cmp.setup.filetype("macaulay2", {
    sources = cmp.config.sources({
      { name = "macaulay2" },
      { name = "buffer" },
    }),
  })

  return true
end

return M
