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

-- Minimal setup_chat_buffer and teardown_chat_buffer implementations
-- These are ported from deps/codecompanion.nvim/tests/helpers.lua so tests
-- that expect these functions when running in a child Neovim instance will pass.
Helpers.setup_chat_buffer = function(config, adapter)
  -- Try to load tests.config if present; otherwise fall back to empty table
  local test_config = {}
  do
    local ok, cfg = pcall(require, "tests.config")
    if ok and type(cfg) == "table" then
      test_config = vim.deepcopy(cfg)
    end
  end
  -- Mock config module
  local config_module
  do
    local ok, m = pcall(require, "codecompanion.config")
    if not ok then
      -- Provide a minimal config module for the child tests
      m = {
        setup = function(args)
          m.config = args or {}
          m.adapters = (args and args.adapters) or m.adapters or {}
          m.strategies = (args and args.strategies) or m.strategies or {}
          m.display = (args and args.display) or m.display or { chat = { intro_message = "", show_settings = false } }
        end,
        can_send_code = function() return true end,
        strategies = { chat = { adapter = "test_adapter", tools = { fast_apply = { opts = {} } }, opts = {} } },
        adapters = {},
        constants = { LLM_ROLE = "llm", USER_ROLE = "user", SYSTEM_ROLE = "system" },
      }
      package.loaded["codecompanion.config"] = m
    else
      -- Ensure expected functions/fields exist
      if type(m.setup) ~= "function" then
        m.setup = function(args) m.config = args or {} end
      end
      if type(m.can_send_code) ~= "function" then
        m.can_send_code = function() return true end
      end
      m.display = m.display or { chat = { intro_message = "", show_settings = false } }
      m.constants = m.constants or { LLM_ROLE = "llm", USER_ROLE = "user", SYSTEM_ROLE = "system" }
    end
    config_module = m
  end
  config_module.setup(vim.tbl_deep_extend("force", test_config, config or {}))

  -- Prepare a minimal adapter object to avoid deep adapter resolution issues in tests
  local minimal_adapter = {
    name = "test_adapter",
    formatted_name = "test_adapter",
    roles = { llm = "assistant", user = "user" },
    schema = { model = { default = "gpt-3.5-turbo" } },
    handlers = {
      form_parameters = function() return {} end,
      form_messages = function() return {} end,
      tools = {
        format_tool_calls = function(self, tools) return tools end,
        output_response = function(self, tool_call, output)
          return { role = "tool", tool_call_id = tool_call.id, content = output, opts = { tag = tool_call.id, visible = false } }
        end,
      },
    },
    parameters = {},
    opts = {},
  }

  -- Extend the adapters if provided
  if adapter and config_module.adapters then
    config_module.adapters[adapter.name] = adapter.config
  end

  local adapter_arg = adapter and adapter.name or minimal_adapter
  local chat = require("codecompanion.strategies.chat").new({
    buffer_context = { bufnr = 1, filetype = "lua" },
    adapter = adapter_arg,
  })
  chat.vars = {
    foo = {
      callback = "spec.codecompanion.strategies.chat.variables.foo",
      description = "foo",
    },
  }
  local tools = require("codecompanion.strategies.chat.tools").new({ bufnr = 1 })
  local vars = require("codecompanion.strategies.chat.variables").new()

  return chat, tools, vars
end

Helpers.teardown_chat_buffer = function()
  -- Minimal teardown to avoid leaking packages between tests
  package.loaded["codecompanion.utils.foo"] = nil
  package.loaded["codecompanion.utils.bar"] = nil
  package.loaded["codecompanion.utils.bar_again"] = nil
end

return Helpers