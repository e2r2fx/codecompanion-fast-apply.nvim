return {
  adapters = {
    test_adapter = {
      name = "test_adapter",
      url = "https://api.openai.com/v1/chat/completions",
      roles = {
        llm = "assistant",
        user = "user",
      },
      opts = {
        stream = true,
      },
      handlers = {
        form_parameters = function()
          return {}
        end,
        form_messages = function()
          return {}
        end,
        is_complete = function()
          return false
        end,
        tools = {
          format_tool_calls = function(self, tools)
            return tools
          end,
          output_response = function(self, tool_call, output)
            return {
              role = "tool",
              tool_call_id = tool_call.id,
              content = output,
              opts = { tag = tool_call.id, visible = false },
            }
          end,
        },
      },
      schema = {
        model = {
          default = "gpt-3.5-turbo",
        },
      },
    },
    opts = {
      allow_insecure = false,
      proxy = nil,
    },
  },

  strategies = {
    chat = {
      adapter = "test_adapter",
      roles = {
        llm = "assistant",
        user = "foo",
      },
      tools = {
        ["fast_apply"] = {
          callback = "codecompanion._extensions.fast_apply.tool",
          description = "Apply code changes to a file using the morphllm for fast code modifications",
        },
        opts = {
          system_prompt = "",
          wait_timeout = 3000,
        },
      },
    },
  },
}