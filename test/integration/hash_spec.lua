local hash = require "arweave.hash"

describe("hash", function()
  test("generates hash with length of 43 by default", function()
    local actual = hash.generateId()
    assert.equals(#actual, 43)
    assert.is_string(actual)
  end)

  test("generates hash with given length", function()
    local actual = hash.generateId(20)
    assert.equals(#actual, 20)
    assert.is_string(actual)
  end)
end)
