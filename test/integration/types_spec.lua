local Address = require "arweave.types.address"
local Type = require "arweave.types.type"

describe("types", function()
  describe("address", function()
    test("ensures valid length", function()

      local _, actual = pcall(function()
        Address:assert("test")
      end)

      assert.equals(
        actual:match("Invalid length for Arweave address"),
        "Invalid length for Arweave address"
      )
    end)
  end)

  describe("validator", function()
    test("can validate a type", function()

      local Validator = require "src.types.validator"

      -- Given we have a validator that validates an object's Quantity field and
      -- expects it to be a number
      local validator = Validator:init({
        types = {
          Quantity = Type:number("should be a number")
        }
      })

      -- ... and we have this object that we want to validate
      local obj = {
        Quantity = 190
      }

      -- When validating the given obj and its Quantity field
      local validated = validator:validate_types(
        obj,
        {
          "Quantity"
        }
      )

      -- Then the given Quantity field's value should be returned by the
      -- validator's `validate_types()` method
      assert.equals(
        validated.Quantity,
        190
      )
    end)

    test("can validate multiple types", function()

      local Validator = require "src.types.validator"

      -- Given we have a validator that validates an object's Quantity and
      -- Sender fields
      local validator = Validator:init({
        types = {
          Quantity = Type:number("should be a number"),
          Sender = Type:string("should be a string"),
        }
      })

      -- ... and we have this object that we want to validate
      local obj = {
        Quantity = 190,
        Sender = "sender-1447"
      }

      -- When validating the given obj and its Quantity and Sender fields
      local validated = validator:validate_types(
        obj,
        {
          "Quantity",
          "Sender",
        }
      )

      -- Then the given Quantity and Sender field's values should be returned by
      -- the validator's `validate_types()` method
      assert.equals(validated.Quantity, 190)
      assert.equals(validated.Sender, "sender-1447")
    end)

    test("throws an error if a type is not valid (#1)", function()

      local Validator = require "src.types.validator"

      -- Given we have a validator that validates an object's Quantity and
      -- Sender fields
      local validator = Validator:init({
        types = {
          Quantity = Type:number("Quantity should be a number"),
          Sender = Type:string("should be a string"),
        }
      })

      -- ... and we have this object that we want to validate
      local obj = {
        Quantity = "190", -- ... and this value is the wrong type
        Sender = "sender-1447"
      }

      -- When validating the given obj and its Quantity and Sender fields
      local validated = {}
      local _, err = pcall(function()
        validated = validator:validate_types(
          obj,
          {
            "Quantity",
            "Sender",
          }
        )
      end)

      -- Then the validator should have thrown the following error when
      -- validating the Quantity field
      assert.equals(
        err:match("Quantity should be a number"),
        "Quantity should be a number"
      )

      -- ... and the validator should not have returned any valid values beacuse
      -- it errored out
      assert.equals(validated.Quantity, nil)
      assert.equals(validated.Sender, nil)
    end)

    test("throws an error if a type is not valid (#2)", function()

      local Validator = require "src.types.validator"

      -- Given we have a validator that validates an object's Quantity and
      -- Sender fields
      local validator = Validator:init({
        types = {
          Quantity = Type:number("Quantity should be a number"),
          Sender = Type:string("Sender should be a string"),
        }
      })

      -- ... and we have this object that we want to validate
      local obj = {
        Quantity = 190,
        Sender = 190 -- ... and this value is the wrong type
      }

      -- When validating the given obj and its Quantity and Sender fields
      local validated = {}
      local _, err = pcall(function()
        validated = validator:validate_types(
          obj,
          {
            "Quantity",
            "Sender",
          }
        )
      end)

      -- Then the validator should have thrown the following error when
      -- validating the Sender field
      assert.equals(
        err:match("Sender should be a string"),
        "Sender should be a string"
      )

      -- ... and the validator should not have returned any valid values beacuse
      -- it errored out
      assert.equals(validated.Quantity, nil)
      assert.equals(validated.Sender, nil)
    end)
  end)
end)
