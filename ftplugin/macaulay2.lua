-- Buffer-local settings for Macaulay2 files

-- Only load once per buffer
if vim.b.did_ftplugin_macaulay2 then
  return
end
vim.b.did_ftplugin_macaulay2 = true

-- Set comment string for commenting plugins
vim.bo.commentstring = "-- %s"

-- Set useful buffer options
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

-- Setup buffer-local keymaps
local bufnr = vim.api.nvim_get_current_buf()
local ok, keymaps = pcall(require, "macaulay2.keymaps")
if ok then
  keymaps.setup_buffer_keymaps(bufnr)
end

-- Start LSP server
local ok_lsp, lsp = pcall(require, "macaulay2.lsp")
if ok_lsp then
  lsp.start(bufnr)
end
