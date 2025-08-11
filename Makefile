all: test

test: deps
	@echo Testing...
	nvim --headless --noplugin -u ./scripts/minimal_init.lua -c "lua MiniTest.run()"

echo:
	@echo "Run make test to run tests"

deps: deps/plenary.nvim deps/nvim-treesitter deps/mini.nvim deps/codecompanion.nvim
	@echo Pulled deps

deps/plenary.nvim:
	@mkdir -p deps
	git clone --filter=blob:none https://github.com/nvim-lua/plenary.nvim.git $@

deps/nvim-treesitter:
	@mkdir -p deps
	git clone --filter=blob:none https://github.com/nvim-treesitter/nvim-treesitter.git $@

deps/mini.nvim:
	@mkdir -p deps
	git clone --filter=blob:none https://github.com/echasnovski/mini.nvim $@

deps/codecompanion.nvim:
	@mkdir -p deps
	git clone --filter=blob:none https://github.com/olimorris/codecompanion.nvim.git $@
