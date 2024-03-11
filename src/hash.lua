local utils = require "arweave.testing.utils"
local marton = require "arweave.testing.output_handlers.marton"

local mod = {}

---Generate an ID of a given length.
---@param length number (Optional) The length to make the hash. Defaults to 43.
---@return string
function mod.generateId(len)
  local id = ""

  if not len then
    len = 43
  end

  -- possible characters in a valid arweave address
  local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_-"

  while string.len(id) < len do
    -- get random char
    local char = math.random(1, string.len(chars))

    -- select and apply char
    id = id .. string.sub(chars, char, char)
  end

  return id
end

return mod
