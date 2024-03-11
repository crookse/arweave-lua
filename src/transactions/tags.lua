local mod = {}

---Find a value for a tag by its key
---@param key string Tag key
---@param tags Tag[] Transaction tags
---@return string|nil
function mod.tag_value(key, tags)
  for _, tag in ipairs(tags) do
    if tag.name == key then
      return tag.value
    end
  end

  return nil
end

return mod
