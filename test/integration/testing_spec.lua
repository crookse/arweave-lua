local arweave = require "arweave"

describe(
  "testing", function()
    describe(
      "utils", function()
        test(
          "can generate IDs", function()
            assert.is_string(arweave.testing.utils.generateAddress())
          end
        )
      end
    )
  end
)
