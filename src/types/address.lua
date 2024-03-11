local Type = require "arweave.types.type"

return Type
  :string("Invalid type for Arweave address (must be string)")
  :length(43, nil, "Invalid length for Arweave address")
  :match("[A-z0-9_-]+", "Invalid characters in Arweave address")

