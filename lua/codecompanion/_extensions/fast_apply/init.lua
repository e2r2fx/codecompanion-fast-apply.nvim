local config = require("codecompanion.config")

local defaults = {
  adapter = "openai_compatible",
  model = "morph-v3-large",
  url = "https://api.morphllm.com/v1",
}

local Extension = {}

---Setup the extension and register the fast_apply tool in CodeCompanion's config
---@param opts table
function Extension.setup(opts)
  opts = opts or {}
  local merged = vim.tbl_deep_extend("force", {}, defaults, opts)

  config.strategies = config.strategies or {}
  config.strategies.chat = config.strategies.chat or {}
  config.strategies.chat.tools = config.strategies.chat.tools or {}

  config.strategies.chat.tools.fast_apply = {
    callback = "codecompanion._extensions.fast_apply.tool",
    description = "Apply code changes to a file using morphllm for fast code modifications",
    opts = merged,
  }
end

return Extension
