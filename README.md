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

#### `test`

The `test` command uses [busted](https://lunarmodules.github.io/busted/) to run tests. It calls busted's test runner under the hood. This means you can pass in any `busted` CLI args/options to the `test` command and busted would handle it like it normally would.

```
arweave test [args/options] [directory]
```

__Things to Note__

- When providing a `directory` to `arweave test`, busted's test runner will:
  - find and run all tests in that directory; and
  - traverse each subdirectory in that directory to find and run more tests.

## Tutorials

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
