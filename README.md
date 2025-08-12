# codecompanion-fast-apply.nvim

A tiny CodeCompanion extension that provides a `fast_apply` tool to apply
concise code edits using a Morph-compatible Fast Apply model.

Installation (lazy.nvim):

```lua
{
  "olimorris/codecompanion.nvim"",
  dependencies = { "e2r2fx/codecompanion-fast-apply.nvim" },
  opts = {
    extensions = {
      fast_apply = {
        enabled = true,
        opts = {
          adapter = "openai_compatible",
          model = "morph-v3-large",
          url = "https://api.morphllm.com/v1",
          api_key = "cmd:some command to get your api key",
        },
      },
    }
  }
}
```

## Quick notes

### Nix users

This repository provides a Nix flake. To enter the development shell and run the
test suite:

```bash
nix develop --impure --accept-flake-config --command devenv test
```

### If you don't use Nix just run `make test`

License: MIT
