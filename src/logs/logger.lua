---@alias LogLevel "debug" | "info" | "warn" | "error" | "fatal"

local mod = {}

---Initialize a logger.
---@param options { level: LogLevel }
---@return table
function mod.init(options)

  if not options then
    options = {}
  end

  local logger = {
    level = options.level,
    write = print
  }

  ---@type table<LogLevel, number>
  logger.levels = {
    debug = 5,
    info = 4,
    warn = 3,
    error = 2,
    fatal = 1,
    off = 0,
  }

  -- Default to "error" level if no level provided
  if not options.level then
    logger.level = "error"
  end

  -- If the provided level is invalid, then do not log anything
  if not logger.levels[options.level] then
    logger.level = "off"
  end

  ---Can the given level (associated with a message) be logged
  ---@param level LogLevel
  ---@return boolean
  local function canLog(level)
    local logLevel = logger.levels[logger.level]
    local msgLevel = logger.levels[level]

    if msgLevel <= logLevel then
      return true
    end

    return false
  end

  ---Write a message with a log level tag
  ---@param level LogLevel
  local function writeWithLevel(level)

    ---Write log messages of this log level.
    ---@param message string
    ---@param ... string
    local function log(message, ...)
      if not canLog(level) then
        return
      end

      local rest = ... or "";

      if ... ~= nil then
        rest = " " .. rest
      end

      logger.write("[" .. string.upper(level) .. "] " .. (message or "") .. (rest))
    end

    return log
  end

  logger.debug = writeWithLevel("debug")
  logger.info = writeWithLevel("info")
  logger.warn = writeWithLevel("warn")
  logger.error = writeWithLevel("error")
  logger.fatal = writeWithLevel("fatal")

  return logger
end

return mod
