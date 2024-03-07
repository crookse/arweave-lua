local io = io
local type = type
local string_gsub = string.gsub
local io_write = io.write
local pretty = require "pl.pretty"

---@alias Tracker { __AllTestFileResults: { test_files: TestFileResults, test_files_count: number, test_files_failed: table<string, boolean>, test_files_by_name: table<string, TestFileResults> } }
---@alias Element { trace: { short_src: string } }
---@alias Test { name: string, status: TestStatus }
---@alias TestStatus "success" | "failure" | "error" | "pending"
---@alias TestWithMessage Test | { message: string }
---@alias TestWithMessageTable table<string, Test>
---@alias TestFileResults { all_tests_passed: nil | boolean, tests: TestWithMessageTable, tests_count: number, total_tests: number, success: TestWithMessageTable, success_count: number, failure: TestWithMessageTable, failure_count: number, error: TestWithMessageTable, error_count: number, pending: TestWithMessageTable, pending_count: number }
---@alias TestFileResultsField
---| "all_tests_passed"
---| "tests"
---| "tests_count"
---| "success"
---| "success_count"
---| "failure"
---| "failure_count"
---| "error"
---| "error_count"
---| "pending"
---| "pending_count"
---@alias File { name: string }

local function print(msg)
  io_write(msg .. "\n")
end

local colors = {}
local styling = string.char(27) .. "[%dm"

function colors.bg_green(message)
  return
    styling:format(42) .. styling:format(37) .. message .. styling:format(0)
end

function colors.bg_red(message)
  return
    styling:format(41) .. styling:format(37) .. message .. styling:format(0)
end

function colors.fg_default(message)
  return styling:format(2) .. message .. styling:format(0)
end

local statusIconMap = {
  success = "✅",
  failure = "❌",
  error = "🛑",
  pending = "⚪️",
  unknown = "⚪️"
}

---Handle test output
return function(options)
  local busted = require "busted"
  local handler = require "busted.outputHandlers.base"()

  ---@type Tracker
  local tracker = {}

  local getTestMessage = function(test)
    local message = test.message

    if message == nil then
      message = "(no error message was provided)"
    elseif type(message) ~= "string" then
      message = pretty.write(message)
    end

    return message
  end

  ---Get the test filename from the given element.
  ---@param element Element
  ---@return string
  local function getTestFilenameFromElement(element)
    return element.trace.short_src
  end

  local function incrementTestFileCount()
    local currentValue = tracker.__AllTestFileResults.test_files_count or 0
    tracker.__AllTestFileResults.test_files_count = currentValue + 1
  end

  ---@param testFilename string
  ---@param countFieldName "success_count" | "error_count" | "pending_count" | "failure_count" | "tests_count"
  local function incrementTestResultCount(testFilename, countFieldName)
    local currentValue =
      tracker.__AllTestFileResults.test_files_by_name[testFilename][countFieldName]
        or 0
    tracker.__AllTestFileResults.test_files_by_name[testFilename][countFieldName] =
      currentValue + 1
  end

  ---@param testFilename string
  local function incrementTestFilesFailedCount(testFilename)
    tracker.__AllTestFileResults.test_files_failed[testFilename] = true
  end

  ---Show the test error details.
  ---@param test TestWithMessage
  local function showError(test)
    print(
      "\n" .. statusIconMap.error .. " ERROR @ "
        .. string_gsub(getTestMessage(test), "\n", "\n    ")
    )
  end

  ---Show the test failure details.
  ---@param test TestWithMessage
  local function showFailure(test)
    print(
      "\n" .. statusIconMap.failure .. " FAIL @ "
        .. string_gsub(getTestMessage(test), "\n", "\n    ")
    )
  end

  handler.resetSuite = function()
    tracker.__AllTestFileResults = {
      test_files = {},
      test_files_count = 0,
      test_files_failed = {},
      test_files_by_name = {}
    }
  end

  ---Handle when the test suite ends.
  handler.onSuiteEnd = function()

    -- Show failures before errors because errors need to be addressed first.
    -- See comment on errors below for more info.
    for _, v in ipairs(handler.failures) do
      showFailure(v)
    end

    -- Show errors last. Errored tests need to be seen and addressed before
    -- failed tests because errors mean there are errors in the test/code.
    for _, v in ipairs(handler.errors) do
      showError(v)
    end

    local totalSuites = tracker.__AllTestFileResults.test_files_count
    local totalSuitesFailed = 0
    for _, v in pairs(tracker.__AllTestFileResults.test_files_failed) do
      totalSuitesFailed = totalSuitesFailed + 1
    end

    print("\n")

    print(
      styling:format(1) .. "Test Suites: "
        .. styling:format(totalSuitesFailed == 0 and 32 or 31) .. totalSuites
        - totalSuitesFailed .. " passed" .. styling:format(37) .. ", "
        .. totalSuites .. " total"
    )

    local totalTests = 0
    local totalTestsFailed = 0
    for _, testFileResults in pairs(
                                tracker.__AllTestFileResults.test_files_by_name
                              ) do
      totalTests = totalTests + testFileResults.tests_count
      totalTestsFailed = totalTestsFailed + testFileResults.failure_count
      totalTestsFailed = totalTestsFailed + testFileResults.error_count
    end

    print(
      "Tests:       " .. styling:format(totalSuitesFailed == 0 and 32 or 31)
        .. totalTests - totalTestsFailed .. " passed" .. styling:format(37)
        .. ", " .. totalTests .. " total"
    )

    print(
      styling:format(0) .. styling:format(2) .. "Ran " .. totalSuites
        .. " test suites." .. styling:format(0)
    )
  end

  ---Handle when a test file starts running.
  ---@param file File
  handler.onFileStart = function(file)

    ---@type TestFileResults
    local initTestFileResults = {
      all_tests_passed = true, -- Gets set to false on test failures and errors
      tests = {},
      tests_count = 0,
      success = {},
      success_count = 0,
      failure = {},
      failure_count = 0,
      error = {},
      error_count = 0,
      pending = {},
      pending_count = 0
    }

    tracker.__AllTestFileResults.test_files_by_name[file.name] =
      initTestFileResults

    incrementTestFileCount()

    print("\n")
  end

  ---Handle when a test file is done running.
  ---@param file File
  handler.onFileEnd = function(file)

    local allTestsPassed =
      tracker.__AllTestFileResults.test_files_by_name[file.name]
        .all_tests_passed or false

    if allTestsPassed then
      print(colors.bg_green(" PASS ") .. file.name)
    else
      print(colors.bg_red(" FAIL ") .. file.name)
    end

    for _, test in ipairs(
                     tracker.__AllTestFileResults.test_files_by_name[file.name]
                       .tests
                   ) do

      ---@cast test TestWithMessage

      local status = statusIconMap[test.status] or statusIconMap.unknown

      print("    " .. status .. " " .. colors.fg_default(test.name))
    end
  end

  ---Handler to run when a test starts.
  ---@param element Element
  ---@param parent any
  ---@param status TestStatus
  ---@param trace any
  handler.onTestStart = function(element, parent, status, trace)
    -- placeholder for now
  end

  ---Handler to run when a test ends.
  ---@param element any
  ---@param parent any
  ---@param status TestStatus
  ---@param trace any
  handler.onTestEnd = function(element, parent, status, trace)
    local testFilename = getTestFilenameFromElement(element)
    incrementTestResultCount(testFilename, "tests_count")

    local test = nil

    if status == "success" then
      test = handler.successes[#handler.successes]
      incrementTestResultCount(testFilename, "success_count")
    end

    if status == "pending" then
      test = handler.pendings[#handler.pendings]
      incrementTestResultCount(testFilename, "pending_count")
    end

    if status == "failure" then
      test = handler.failures[#handler.failures]
      tracker.__AllTestFileResults.test_files_by_name[testFilename]
        .all_tests_passed = false
      incrementTestResultCount(testFilename, "failure_count")
      incrementTestFilesFailedCount(testFilename)
    end

    if status == "error" then
      test = handler.errors[#handler.errors]
      tracker.__AllTestFileResults.test_files_by_name[testFilename]
        .all_tests_passed = false
      incrementTestResultCount(testFilename, "error_count")
      incrementTestFilesFailedCount(testFilename)
    end

    if test ~= nil then
      test.status = status

      table.insert(
        tracker.__AllTestFileResults.test_files_by_name[testFilename].tests,
        test
      )

      table.insert(
        tracker.__AllTestFileResults.test_files_by_name[testFilename][status],
        test
      )
    end
  end

  -- Initially set the test suite up
  handler.resetSuite()

  -- Bind busted events to the functions above
  busted.subscribe(
    {
      "suite",
      "reset"
    }, handler.resetSuite
  )
  busted.subscribe(
    {"suite", "end"}, handler.onSuiteEnd
  )
  busted.subscribe(
    {
      "file",
      "start"
    }, handler.onFileStart
  )
  busted.subscribe(
    {"file", "end"}, handler.onFileEnd
  )
  busted.subscribe(
    {
      "test",
      "start"
    }, handler.onTestStart
  )
  busted.subscribe(
    {"test", "end"}, handler.onTestEnd
  )

  return handler
end
