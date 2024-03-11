local Address = require "arweave.types.address"

describe("types", function()
  describe("address", function()
    test("ensures valid length", function()

      local _, actual = pcall(function()
        Address:assert("test")
      end)

      assert.equals(actual:match("Invalid length for Arweave address"),
                    "Invalid length for Arweave address")
    end)
  end)
end)
