local mod = {}

---Generate a valid Arweave address
---@return string
function mod.generateAddress()
  local id = ""

  -- possible characters in a valid arweave address
  local chars =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_-"

  while string.len(id) < 43 do
    -- get random char
    local char = math.random(1, string.len(chars))

    -- select and apply char
    id = id .. string.sub(chars, char, char)
  end

  return id
end

return mod
