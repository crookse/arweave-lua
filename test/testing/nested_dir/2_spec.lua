require "busted"


describe("bundled_1", function()
  it("tests insulate block does not update environment", function()
    assert.is_nil(package.loaded.mymodule)  -- mymodule is not loaded
    assert.is_nil(_G.myglobal)  -- _G.myglobal is not set
    assert.is_ndil(myglobal)
  end)

  it("tests insulate block does not update environment", function()
    assert.is_nil(package.loaded.mymodule)  -- mymodule is not loaded
    assert.is_nil(_G.myglobal)  -- _G.myglobal is not set
    assert.are_same(false, true)
  end)

end)


-- local fakes = require "libs.testing_fakes"
-- local json  = require "libs.json"

-- local processId = testing.generatePlaceholderID()

-- Handlers = {}

-- Handlers.added_handlers = {}

-- function Handlers.add(
--   name,
--   condition,
--   func
-- )
--   Handlers.added_handlers[name] = func
-- end

-- Handlers.utils = {}
-- function Handlers.utils.hasMatchingTag(name, value)
--   return true
-- end

-- require "bundled"

-- describe("bundled",
--   function (test)
--     test(
--       'Action = "Info"',
--       function ()
--         testing.set_globals({
--           Name = "TestToken",
--           Ticker = "A-Test",
--           Logo = "logo",
--           Denomination = 12,
--         })

--         -- Set up global ao object
--         ao = fakes.ao()
--         Logger = ao
--         OutputWriter = {
--           write = ao.log
--         }

--         local msg = {
--           From = "0x1337"
--         }

--         Handlers.added_handlers["info"](msg)

--         local expectedSend = {
--           Target = "0x1337",
--           Tags = {
--             Name = "TestToken",
--             Ticker = "A-Test",
--             Denomination = "12",
--             Logo = "logo"
--           }
--         }

--         testing.asserts.json_equals(
--           ao.calls.send[1],
--           expectedSend
--         )

--         testing.asserts.json_equals(
--           json.decode(ao.calls.log[1]),
--           expectedSend.Tags
--         )
--       end
--     )

--     test(
--       'Action = "Balance',
--       function ()
--         local sender = testing.generatePlaceholderID()

--         testing.set_globals({
--           Name = "TestToken",
--           Ticker = "A-Test",
--           Logo = "logo",
--           Denomination = 12,
--           Balances = {
--             [sender] = 190,
--           }
--         })

--         -- Set up global ao object
--         ao = fakes.ao()
--         Logger = ao
--         OutputWriter = {
--           write = ao.log
--         }

--         local msg = {
--           From = sender,
--           Tags = {
--             Address = sender
--           }
--         }

--         Handlers.added_handlers["balance"](msg)

--         local expectedSend = {
--           Target = sender,
--           Tags = {
--             Balance = "190",
--             Target = sender,
--             Ticker = Ticker
--           }
--         }

--         testing.asserts.json_equals(
--           ao.calls.send[1],
--           expectedSend
--         )

--         testing.asserts.json_equals(
--           json.decode(ao.calls.log[1]),
--           expectedSend.Tags
--         )
--       end
--     )

--     test(
--       'Action = "Balances"',
--       function ()
--         local sender = testing.generatePlaceholderID()

--         testing.set_globals({
--           Name = "TestToken",
--           Ticker = "A-Test",
--           Logo = "logo",
--           Denomination = 12,
--           Balances = {
--             [sender] = 190,
--           }
--         })

--         -- Set up global ao object
--         ao = fakes.ao()
--         Logger = ao
--         OutputWriter = {
--           write = ao.log
--         }

--         local msg = {
--           From = sender,
--         }

--         Handlers.added_handlers["balances"](msg)

--         local expectedSend = {
--           Target = sender,
--           Data = Balances
--         }

--         testing.asserts.json_equals(
--           ao.calls.send[1],
--           expectedSend
--         )

--         testing.asserts.json_equals(
--           json.decode(ao.calls.log[1]),
--           {
--             [sender] = 190
--           }
--         )
--       end
--     )

--     test(
--       'Action = "Burn" -> burns successfully',
--       function ()
--         local burnerA = testing.generatePlaceholderID()
--         local burnerB = testing.generatePlaceholderID()
--         local requestor = testing.generatePlaceholderID()

--         testing.set_globals({
--           Name = "TestToken",
--           Ticker = "A-Test",
--           Logo = "logo",
--           Denomination = 12,
--           Balances = {
--             [requestor] = 190,
--           },
--           ProposalAuthorities = {
--             burners = {
--               burnerA,
--               burnerB,
--             }
--           }
--         })

--         -- Set up global ao object
--         ao = fakes.ao()
--         Logger = ao

--         --
--         -- Send the initial burn request
--         --

--         Handlers.added_handlers["burn"]({
--           From = requestor,
--           Tags = {
--             Quantity = "1"
--           }
--         })

--         local burnRequestId = ao.calls.send[1].Tags["Burn-Request-Id"]

--         testing.asserts.json_equals(
--           ao.calls.send[1],
--           {
--             Target = burnerA,
--             Tags = {
--               Action = "Burn-Request-Notice",
--               ["Burn-Request-Id"] = burnRequestId,
--               Quantity = "1",
--               Requestor = requestor
--             }
--           }
--         )

--         testing.asserts.json_equals(
--           ao.calls.send[1],
--           {
--             Target = burnerA,
--             Tags = {
--               Action = "Burn-Request-Notice",
--               ["Burn-Request-Id"] = burnRequestId,
--               Quantity = "1",
--               Requestor = requestor
--             }
--           }
--         )

--         --
--         -- Send the burn approvals
--         --

--         Handlers.added_handlers["burn"](
--           {
--             From = burnerA,
--             Tags = {
--               ["Burn-Request-Id"] = burnRequestId,
--               ["Burn-Type"] = "Burn-Approval",
--               ["Requestor"] = requestor
--             }
--           },
--           {
--             Process = {
--               Id = processId
--             }
--           }
--         )

--         testing.asserts.equals(
--           Proposals.burn_requests[requestor][burnRequestId].approvals[1],
--           burnerA
--         )

--         Handlers.added_handlers["burn"](
--           {
--             From = burnerB,
--             Tags = {
--               ["Burn-Request-Id"] = burnRequestId,
--               ["Burn-Type"] = "Burn-Approval",
--               ["Requestor"] = requestor
--             }
--           },
--           {
--             Process = {
--               Id = processId
--             }
--           }
--         )

--         testing.asserts.equals(
--           Proposals.burn_requests[requestor][burnRequestId].approvals[2],
--           burnerB
--         )

--         --
--         -- The requestor's balance should now be updated
--         --

--         -- Assert the balance is the initial balance (190) - the quantity (1)
--         testing.asserts.equals(
--           Balances[requestor],
--           189
--         )

--         -- Assert a Debit-Notice was sent to the requestor
--         testing.asserts.json_equals(
--           ao.calls.send[3],
--           {
--             Target = processId,
--             Tags = {
--               Action = "Debit-Notice",
--               Recipient = requestor,
--               Quantity = "1"
--             }
--           }
--         )
--       end
--     )

--     test(
--       'Action = "Mint" -> mints successfully',
--       function ()
--         local qty = "18000000000000"
--         local minter = testing.generatePlaceholderID()
--         local target = "s5GsZ3t3DTICGzbL0zgnWy0woYDjgqRwMqWSyrO1K7S"
--         local processId = testing.generatePlaceholderID()
--         local vaultProcessId = testing.generatePlaceholderID()
--         local depositTxId = testing.generatePlaceholderID()

--         --TODO: No need to reset like this
--         testing.set_globals({
--           Name = "TestToken",
--           Ticker = "A-Test",
--           Logo = "logo",
--           Denomination = 12,
--           Balances = {
--             [target] = 190,
--           },
--           ProposalAuthorities = {
--             minters = {
--               minter
--             }
--           },
--         })

--         VaultProcessId = vaultProcessId
--         AuthorizedExternalTargets = {
--           vaultProcessId
--         }

--         -- Set up global ao object
--         ao = fakes.ao()
--         Logger = ao

--         local msg = {
--           From = minter,
--           Tags = {
--             ["Deposit-Tx-Id"] = depositTxId,
--             ["Fee-Winston"] = "3600000000000",
--             ["Fee-USD"] = "57.82",
--             ["Currency-From-USD-Price"] = "289.08",
--             Target = target,
--             Quantity = qty
--           }
--         }

--         local env = {
--           Process = {
--             Id = processId
--           }
--         }

--         Handlers.added_handlers["mint"](msg, env)

--         testing.asserts.json_equals(
--           ao.calls.send[1],
--           {
--             Target = processId,
--             Tags = {
--               Action = "Credit-Notice",
--               Quantity = qty,
--               Recipient = target
--             }
--           },
--           "Assert Credit-Notice"
--         )

--         testing.asserts.equals(
--           ao.calls.log[1],
--           "[INFO] Minted " .. qty .. " " .. Ticker .. " to address '" .. target .. "'"
--         )
--       end
--     )

--     test(
--       'Action = "Mint" -> errors if minter is not in approval authority',
--       function ()
--         local qty = "18000000000000"
--         local target = testing.generatePlaceholderID()
--         local processId = testing.generatePlaceholderID()
--         local minter = testing.generatePlaceholderID()
--         local depositTxId = testing.generatePlaceholderID()

--         ProposalAuthorities = {
--           minters = {
--             minter
--           }
--         }

--         -- Set up global ao object
--         ao = fakes.ao()
--         Logger = ao

--         local msg = {
--           From = target,
--           Tags = {
--             ["Deposit-Tx-Id"] = depositTxId,
--             ["Fee-Winston"] = "3600000000000",
--             ["Fee-USD"] = "57.82",
--             ["Currency-From-USD-Price"] = "289.08",
--             Target = target,
--             Quantity = qty
--           }
--         }

--         local env = {
--           Process = {
--             Id = processId
--           }
--         }

--         local success, res = pcall(
--           function()
--             Handlers.added_handlers["mint"](msg, env)
--           end,
--           processId,
--           target,
--           qty
--         )

--         testing.asserts.error_equals(res, "Address '" .. target .. "' unauthorized to mint tokens")
--       end
--     )

--     test(
--       'Action = "Transfer", Transfer-Type = "Internal"',
--       function ()
--         local from = testing.generatePlaceholderID()
--         local to = testing.generatePlaceholderID()
        
--         testing.set_globals({
--           Name = "TestToken",
--           Ticker = "A-Test",
--           Logo = "logo",
--           Denomination = 12,
--           Balances = {
--             [from] = 190,
--             [to] = 1
--           },
--         })
        
--         -- Set up global ao object
--         ao = fakes.ao()
--         Logger = ao

--         local msg = {
--           From = from,
--           Tags = {
--             Target = to,
--             ["Transfer-Type"] = "Internal",
--             Quantity = "1"
--           }
--         }

--         Handlers.added_handlers["transfer"](msg, {
--           Process = {
--             Id = processId
--           }
--         })

--         testing.asserts.equals(
--           Balances[from],
--           189
--         )

--         testing.asserts.equals(
--           Balances[to],
--           2
--         )

--         testing.asserts.json_equals(
--           ao.calls.send[1],
--           {
--             Target = processId,
--             Tags = {
--               Action = "Debit-Notice",
--               Quantity = "1",
--               Recipient = to
--             }
--           }
--         )

--         testing.asserts.json_equals(
--           ao.calls.send[2],
--           {
--             Target = processId,
--             Tags = {
--               Action = "Credit-Notice",
--               Quantity = "1",
--               Recipient = to
--             }
--           }
--         )

--         testing.asserts.equals(
--           ao.calls.log[1],
--           "[INFO] Transferred 1 A-Test"
--         )
--       end
--     )

--     -- test(
--     --   'Action = "Transfer", Transfer-Type = "External"',
--     --   function ()
--     --     local from = testing.generatePlaceholderID()
--     --     local to = testing.generatePlaceholderID()

--     --     testing.set_globals({
--     --       Name = "TestToken",
--     --       Ticker = "A-Test",
--     --       Logo = "logo",
--     --       Denomination = 12,
--     --       Balances = {
--     --         [from] = 190,
--     --         [to] = 1
--     --       },
--     --       AuthorizedExternalTargets = {
--     --         to
--     --       },
--     --     })

--     --     -- Set up global ao object
--     --     ao = fakes.ao()

--     --     local msg = {
--     --       From = from,
--     --       Target = to,
--     --       Tags = {
--     --         ["Transfer-Type"] = "External",
--     --         Quantity = "1"
--     --       }
--     --     }

--     --     Handlers.added_handlers["transfer"](msg)

--     --     -- This address balance should reflect the transfer result
--     --     testing.asserts.equals(
--     --       Balances[from],
--     --       189
--     --     )

--     --     -- This address balance should not be modified
--     --     testing.asserts.equals(
--     --       Balances[to],
--     --       1
--     --     )

--     --     testing.asserts.json_equals(
--     --       ao.calls.send[1],
--     --       {
--     --         Target = to,
--     --         Tags = {
--     --           Action = "Borrow",
--     --           Quantity = "1",
--     --           Borrower = from,
--     --           ["Token-Ticker"] = "A-Test",
--     --         }
--     --       }
--     --     )

--     --     testing.asserts.json_equals(
--     --       ao.calls.send[2],
--     --       {
--     --         Target = to,
--     --         Tags = {
--     --           Action = "Debit-Notice",
--     --           Quantity = "1",
--     --           Recipient = to
--     --         }
--     --       }
--     --     )

--     --     testing.asserts.equals(
--     --       ao.calls.log[1],
--     --       "Transferred 1 A-Test"
--     --     )
--     --   end
--     -- )
--   end
-- )
