-- LSP integration for macaulay2.nvim
local M = {}

local config = require("macaulay2.config")

local function find_root(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local dir = fname ~= "" and vim.fn.fnamemodify(fname, ":p:h") or vim.fn.getcwd()
  local markers = vim.fs.find({ ".git" }, { upward = true, path = dir })
  return markers[1] and vim.fn.fnamemodify(markers[1], ":h") or dir
end

-- Start the LSP server for a buffer (no-op if disabled or server not found)
function M.start(bufnr)
  if not vim.lsp.start then
    return  -- requires Neovim >= 0.9
  end

  local cfg = config.get()
  if not cfg.lsp.enabled then
    return
  end

  local cmd = cfg.lsp.cmd
  if vim.fn.executable(cmd[1]) == 0 then
    return
  end

  vim.lsp.start({
    name = "macaulay2",
    cmd = cmd,
    root_dir = find_root(bufnr),
    settings = cfg.lsp.settings,
  }, { bufnr = bufnr })
end

-- Set up the LspAttach autocmd for macaulay2 LSP keymaps
function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("macaulay2_lsp", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client or client.name ~= "macaulay2" then
        return
      end
      local bufnr = args.buf
      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
      end

      map("K",  vim.lsp.buf.hover,      "LSP hover")
      map("gd", vim.lsp.buf.definition, "Go to definition")
    end,
  })
end

return M
