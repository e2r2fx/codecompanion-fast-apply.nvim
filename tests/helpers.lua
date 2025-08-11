local Helpers = {}

Helpers.child_start = function(child)
  child.restart({ "-u", "scripts/minimal_init.lua" })
  child.o.statusline = ""
  child.o.laststatus = 0
  child.o.cmdheight = 0
end

-- Minimal expectations to satisfy tests (wraps MiniTest expectations from host)
Helpers.expect_contains = function(pattern, str)
  assert(str:find(pattern, 1, true), ("Expected to contain %s but it did not.\n%s"):format(pattern, str))
end

Helpers.not_expect_contains = function(pattern, str)
  assert(not str:find(pattern, 1, true), ("Expected to NOT contain %s but it did.\n%s"):format(pattern, str))
end

return Helpers
