local config = require("codecompanion.config")

local defaults = {
	adapter = "openai_compatible",
	model = "morph-v3-large",
	url = "https://api.morphllm.com/v1",
}

---@class CodeCompanion.Extension
---@field setup fun(opts: table) Function called when extension is loaded
local Extension = {}

---Setup the extension and register the fast_apply tool in CodeCompanion's config
---@param opts table Configuration options
function Extension.setup(opts)
	opts = opts or {}
	local merged = vim.tbl_deep_extend("force", {}, defaults, opts)

	config.interactions = config.interactions or {}
	config.interactions.chat = config.interactions.chat or {}
	config.interactions.chat.tools = config.interactions.chat.tools or {}

	config.interactions.chat.tools.fast_apply = {
		path = "_extensions.fast_apply.tool",
		description = "Apply code changes to a file using morphllm for fast code modifications",
		opts = merged,
	}
end

return Extension
