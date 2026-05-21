-- Runtime helpers to extend Macaulay2 syntax groups
local M = {}

local groups = {
  ["function"] = "m2Function",
  constant = "m2Constant",
  ["type"] = "m2Type",
  keyword = "m2Keyword",
}

local function sanitize(word)
  -- Escape whitespace and special chars for :syntax keyword
  if word:match("%s") then
    -- wrap in double quotes if contains space
    return '"' .. word .. '"'
  end
  return word
end

-- Add a list of keywords to a given group (global for the syntax)
-- kind: 'function'|'constant'|'type'|'keyword'
-- words: table of strings
function M.add(kind, words)
  local group = groups[kind]
  if not group then
    return nil, "unknown kind: " .. tostring(kind)
  end

  if type(words) == "string" then
    words = vim.split(words, "%s+", {trimempty = true})
  end

  if type(words) ~= "table" or #words == 0 then
    return nil, "no keywords provided"
  end

  local parts = {}
  for _, w in ipairs(words) do
    table.insert(parts, sanitize(w))
  end

  local cmd = "syntax keyword " .. group .. " " .. table.concat(parts, " ")
  vim.cmd(cmd)
  return true
end

return M
