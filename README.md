# Arweave

Slick Lua tooling for building in the Arweave ecosystem

## Installation

The command below assumes you have the [LuaRocks](https://luarocks.org/) CLI installed.

```bash
luarocks install arweave
```

The above will install the `arweave` command on your machine. See the [CLI](#cli) section below for more information on this command.

## CLI

In addition to providing APIs, this module is a command line program. To view the command line's help menu, run one of the following commands:

```bash
# Using the subcommand
arweave help

# Using the long flag
arweave --help

# Using the short flag of the above long flag
arweave -h
```

### CLI Commands

#### `fmt`

The `fmt` command uses [LuaFormatter](https://github.com/Koihik/LuaFormatter) to format code. It calls the LuaFormatter binary under the hood via `os.execute()`. This means you can pass in any LuaFormatter CLI args/options to the `fmt` command and LuaFormatter would handle it like it normally would.

```
arweave fmt [args/options]
```

#### `lint`

The `lint` command uses [luacheck](https://github.com/lunarmodules/luacheck) to check the code. It calls the luacheck binary under the hood by requiring the luacheck module. This means you can pass in any luacheck args/options to the `lint` command and luacheck would handle it like it normally would.

```bash
arweave lint [args/options]
```

#### `test`

The `test` command uses [busted](https://lunarmodules.github.io/busted/) to run tests. It calls busted's test runner under the hood. This means you can pass in any `busted` CLI args/options to the `test` command and busted would handle it like it normally would.

```
arweave test [args/options] [directory]
```

__Things to Note__

- When providing a `directory` to `arweave test`, busted's test runner will:
  - find and run all tests in that directory; and
  - traverse each subdirectory in that directory to find and run more tests.

## Modules

### `arweave`

#### `arweave.version`

Hold this package's version value.

```lua
local arweave = require "arweave"


--
-- Get this package's version
--
print(arweave.version) -- Example output => 0.0.1-6
```

### `arweave.hash`

#### `arweave.hash.generateId(len)`

Generate an ID of a given length. If no length is given, then the default length of 43 is used.

```lua
local hash = require "arweave.hash"


--
-- Generate a random ID with a default length of 43
--
local value = hash.generateId()
print(value) -- Example output => t_o8ipoYVkk5z9B6Fn8EQtnMOvAvXh-FQ8WCP-7XZNn



--
-- Generate a random ID with a length of 20
--
local value = hash.generateId(20) -- 20 is passed in to tell it "Make the length 20"
print(value) -- Example output => m-it0avrR-xdGOTCsnac
```

### `arweave.testing`

#### `arweave.testing.utils.generateAddress()`

Generate a valid Arweave address.

```lua
local testing = require "arweave.testing"


--
-- Generate an Arweave address for testing
--
local value = testing.utils.generateAddress()
print(value)  -- Example output => KBQYPxkK81wdX7gO9UZgFeOSW0zFvyyLcgyK34pIbc0
```

### `arweave.transactions`

#### `arweave.transactions.tags.tag_value()`

Get the value of a given tag name.

```lua
local testing = require "arweave.testing"


--
-- Get the value of a given tag name
--
local value = testing.utils.generateAddress(
  -- Pass in the tag name to search for
  "My-Tag",
  -- Pass in the tags to search for "name = My-Tag"
  {
    name = "My-Tag",
    value = "some-value",
  }
)
print(value)  -- Example output => "some-value"
```

## Tutorials

### Creating Type Assertions

#### Example Token Type Assertions

The below example shows how to create type assertions for a token. The token will have the following rules:

- It must be a number
- It must be an integer
- It must be greater than 0

1. Create your `token.lua` file.

    ```lua
    -- File: token.lua

    local Type = require "arweave.types.type"



    -- Create the assertion rules for the token
    local TokenQuantity = Type
      :number("Invalid quantity (must be number)")
      :integer("Invalid quantity (must be integer)")
      :greater_than(0, "Invalid quantity (must be > 0)")



    -- Test the `greater_than` assertion
    local _, err = pcall(function()
      TokenQuantity:assert(0)
    end)

    print(err) -- Prints => Invalid quantity (must be > 0)



    -- Test the `number` assertion
    local _, err = pcall(function()
      TokenQuantity:assert("0")
    end)

    print(err) -- Prints => Invalid quantity (must be number)



    -- Test the `integer` assertion
    local _, err = pcall(function()
      TokenQuantity:assert(1.2)
    end)

    print(err) -- Prints => Invalid quantity (must be integer)
    ```

1. Run your `token.lua` file.

    ```
    lua token.lua
    ```

    You should see output similar to the following:

    ```
    /path/to/arweave/types/type.lua:350: [Type table: 0x15b60e4e0] Invalid quantity (must be > 0)
    /path/to/arweave/types/type.lua:350: [Type table: 0x15b60e4e0] Invalid quantity (must be number)
    /path/to/arweave/types/type.lua:350: [Type table: 0x15b60e4e0] Invalid quantity (must be integer)
    ```


### Formatting Code

1. Run the code fomatter against a file.

    ```
    arweave fmt path/to/file.lua
    ```

1. Run the code formatter against a directory.

    ```
    arweave fmt /path/to/files/**/*
    ```

### Writing Tests

1. Create your test file.

    _Note: Take note of the `_spec` suffix on the filename. This is the default file naming convention required by busted._

    ```lua
    -- File: path/to/your_test_spec.lua

    describe(
      "Suite 1",
      function()
        it(
          "runs test 1",
          function()
            assert.is_nil(package.loaded.mymodule)  -- mymodule is not loaded
            assert.is_nil(_G.myglobal)  -- _G.myglobal is not set
            assert.is_nil(myglobal)
          end
        )

        it(
          "runs test 2",
          function()
            assert.is_nil(package.loaded.mymodule)  -- mymodule is not loaded
            assert.is_nil(_G.myglobal)  -- _G.myglobal is not set
            assert.is_nil(myglobal)
          end
        )
      end
    )
    ```

1. Run your test.

    ```
    arweave test .
    ```

    _Note: The `.` above tells the `arweave test` command to find and run tests in the current working directory._
