# codecompanion-fast-apply.nvim

A CodeCompanion extension providing the `fast_apply` tool to apply code edits
using Morph Fast Apply model.

Installation

Using lazy.nvim:

```lua
{
  "e2r2fx/codecompanion-fast-apply.nvim",
  dependencies = { "olimorris/codecompanion.nvim" },
  config = function()
    require("codecompanion").setup({
      extensions = {
        fast_apply = {
          enabled = true,
          opts = {
            adapter = "openai_compatible",
            model = "morph-v3-large",
            url = "https://api.morphllm.com/v1",
          },
        },
      },
    })
  end,
}
```

Or register at runtime:

```lua
require("codecompanion._extensions.fast_apply").setup({ adapter = "openai_compatible" })
```

Running tests

This repo uses a nix flake for development. Start the dev shell and run the test
runner with Neovim's headless mode using plenary/MiniTest.

