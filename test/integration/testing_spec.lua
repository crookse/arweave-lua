local testing = require "arweave.testing"

describe("testing", function()
  describe("utils", function()
    test("can generate IDs", function()
      assert.is_string(testing.utils.generateAddress())
    end)
  end)
end)
