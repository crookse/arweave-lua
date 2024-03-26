---Example Usage
---
---```lua
---local Validator = require "arweave.types.validator"
---
---local validator = Validator:init({
---  types = {
---    Quantity = Type:number("Invalid quantity (must be a number)"),
---    From = Type:string("Invalid type for Arweave address (must be string)"),
---  },
---})
---
---
---```
local mod = {}

-- Given a list it returns its keys
---@param list table
---@return table
function tableKeys(list)
  local keys = {}

  for k in pairs(list) do
    table.insert(keys, k)
  end

  return keys
end

---@alias AssertionInterface { assert: fun(...) }

---Initialize a validator.
---@param options { types: table<string, AssertionInterface> }
---@return ValidatorInstance
function mod:init(options)
  if not options then
    error("Cannot initialize Validator without specifying options")
  end

  ---@class ValidatorInstance
  local instance = {
    types = options.types -- TODO: options.types should be required
  }

  ---Validate the given value using a type's validation rules.
  ---@param types_key string The key name in the `options.types` rules to use to
  ---get the validation rules for the given value.
  ---@param value any The value to validate.
  ---@return table<string, any>
  function instance:validate_type(types_key, value)
    local assertion = instance.types[types_key]

    if not assertion then
      error("No type assertion found for '" .. types_key .. "' key")
    end

    -- Assert the value's type
    assertion:assert(value)

    return self
  end

  ---Validate and return provided keys and their values from the given `pairs`.
  ---@param obj table<string, any>
  ---@param keys_to_validate nil|string[]
  ---@return table<string, any>
  function instance:validate_types(obj, keys_to_validate)
    local validatedVars = {}

    if keys_to_validate == nil then
      keys_to_validate = tableKeys(options.types)
    end

    for _index, key in pairs(keys_to_validate) do
      -- Get the value to assert from the object containing it
      local value = obj[key]

      -- If all good, then add the value to the return variable
      instance.validate_type(self, key, value)

      validatedVars[key] = value
    end

    return validatedVars
  end

  return instance
end

return mod
