-- nvim-cmp source implementation for Macaulay2
local keywords = require("macaulay2.completion.keywords")

local source = {}

-- nvim-cmp completion item kinds
local cmp_kinds = {
  Text = 1,
  Method = 2,
  Function = 3,
  Constructor = 4,
  Field = 5,
  Variable = 6,
  Class = 7,
  Interface = 8,
  Module = 9,
  Property = 10,
  Unit = 11,
  Value = 12,
  Enum = 13,
  Keyword = 14,
  Snippet = 15,
  Color = 16,
  File = 17,
  Reference = 18,
  Folder = 19,
  EnumMember = 20,
  Constant = 21,
  Struct = 22,
  Event = 23,
  Operator = 24,
  TypeParameter = 25,
}

-- Cache for completion items
local cached_items = nil

-- Build completion items from keywords
local function build_items()
  if cached_items then
    return cached_items
  end

  cached_items = {}

  -- Add keywords
  for _, kw in ipairs(keywords.keywords) do
    table.insert(cached_items, {
      label = kw,
      kind = cmp_kinds.Keyword,
      detail = "keyword",
    })
  end

  -- Add types
  for _, t in ipairs(keywords.types) do
    table.insert(cached_items, {
      label = t,
      kind = cmp_kinds.Class,
      detail = "type",
    })
  end

  -- Add functions
  for _, f in ipairs(keywords.functions) do
    table.insert(cached_items, {
      label = f,
      kind = cmp_kinds.Function,
      detail = "function",
    })
  end

  -- Add constants
  for _, c in ipairs(keywords.constants) do
    table.insert(cached_items, {
      label = c,
      kind = cmp_kinds.Constant,
      detail = "constant",
    })
  end

  return cached_items
end

-- Create a new source instance
function source.new()
  return setmetatable({}, { __index = source })
end

-- Return the source name
function source:get_keyword_pattern()
  return [[\k\+]]
end

-- Check if source is available for current buffer
function source:is_available()
  return vim.bo.filetype == "macaulay2"
end

-- Return completion items
function source:complete(params, callback)
  local items = build_items()
  callback(items)
end

-- Get debug name
function source:get_debug_name()
  return "macaulay2"
end

return source
