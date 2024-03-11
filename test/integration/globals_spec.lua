local globals = require "arweave.globals"

describe("hash", function()
  describe("set_globals()", function()
    test("sets globals and overwrites current ones", function()
      _G.Hello = "World"

      assert.equals(Hello, "World")

      globals.set_globals({
        Hello = "__world__",
        Okkkk = "Then",
      })

      assert.equals(Hello, "__world__")
      assert.equals(Okkkk, "Then")
    end)
  end)

  describe("set_globals_if_not_exists()", function()
    test("sets globals and does not overwrite current ones", function()
      _G.Hello = "World"

      assert.equals(Hello, "World")

      globals.set_globals_if_not_exists({
        Hello = "__world__",
        Okkkk = "Then",
      })

      assert.equals(Hello, "World")
      assert.equals(Okkkk, "Then")
    end)
  end)
end)
