package.path = package.path .. ";" .. vim.fn.getcwd() .. "/?.lua"
vim.cmd([[let &rtp.=','.getcwd()]])

vim.cmd("set rtp+=./deps/plenary.nvim")
vim.cmd("set rtp+=./deps/nvim-treesitter")

-- Setup treesitter parsers used by tests (if missing)
vim.cmd("set rtp+=./deps/mini.nvim")
vim.cmd("set rtp+=./deps/codecompanion.nvim")

local ok, ts = pcall(require, "nvim-treesitter")
if ok then
	ts.setup()
	local required_parsers = { "lua", "python", "markdown", "yaml" }
	local installed_parsers = require("nvim-treesitter.info").installed_parsers()
	local to_install = vim.tbl_filter(function(parser)
		return not vim.tbl_contains(installed_parsers, parser)
	end, required_parsers)

	if #to_install > 0 then
		vim.cmd("set display=lastline")
		vim.cmd("runtime! plugin/nvim-treesitter.vim")
		vim.cmd("TSInstallSync " .. table.concat(to_install, " "))
	end
end

-- For headless test runs, add mini.nvim and setup mini.test
if #vim.api.nvim_list_uis() == 0 then
	require("mini.test").setup()
end