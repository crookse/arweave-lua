---Example Usage
---
---```lua
---local Validator = require "arweave.types.validator"
---
---local validator = Validator.init({
---  types = {
---    Quantity = Type:number("Invalid quantity (must be a number)"),
---    Sender = Type:string("Invalid type for Arweave address (must be string)"),
---  },
---})
---
---
---```
local mod = {}

---@class AssertionInterface
local AssertionInterface = {}
function AssertionInterface:assert()
end

---Initialize a validator.
---@param options { types: table<string, AssertionInterface> }
---@return table
function mod.init(options)
  local instance = {
    types = options.types -- TODO: options.types should be required
  }


  ---Validate and return provided keys and their values from the given `pairs`.
  ---@param obj table<string, any>
  ---@param keys string[]
  ---@return table<string, any>
  function instance.validate_types(obj, keys_to_validate)
    local validatedVars = {}
    
    for _index, key in pairs(keys_to_validate) do
      local assertion = instance.types[key]

      if not assertion then
        error("No type assertion found for '" .. key .. "' key")
      end

      -- Get the value to assert from the object containing it
      local value = obj[key]

      -- Assert the value's type
      instance.types[key]:assert(value)

      -- If all good, then add the value to the return variable
      validatedVars[key] = value
    end

    return validatedVars
  end

  return instance
end

return mod
