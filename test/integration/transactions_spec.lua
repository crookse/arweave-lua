local tx = require "arweave.transactions"

describe("testing", function()
  describe("utils", function()
    test("can generate IDs", function()
      local value = tx.tags.tag_value("hello", {
        {
          name = "key_1",
          value = "value_1"
        },
        {
          name = "hello",
          value = "this should be returned"
        }
      })

      assert.is_string(value)
    end)
  end)
end)
