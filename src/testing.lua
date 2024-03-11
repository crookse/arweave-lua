local utils = require "arweave.testing.utils"
local marton = require "arweave.testing.output_handlers.marton"

return {
  output_handlers = {
    marton = marton,
  },
  utils = utils,
}

