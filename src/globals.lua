local mod = {}

---Set the given key-value pairs as globals where the key is the global name and
---the value is the globale value.
---
---This will overwrite any current global variable. If you want a safer global
---variable setter, use `set_globals_if_not_exists()` instead.
---@param obj any
function mod.set_globals(obj)
  for k, v in pairs(obj) do
    _G[k] = v
  end
end

---Set the given key-value pairs as globals where the key is the global name and
---the value is the global value only if the global variable does not exist yet.
---@param obj table<string, any>
function mod.set_globals_if_not_exists(obj)
  for k, v in pairs(obj) do

    local currentValue = _G[k]

    if not currentValue or currentValue == nil then
      _G[k] = v
    end

  end
end

return mod
