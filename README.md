# codecompanion-fast-apply.nvim

## Description

A tiny CodeCompanion extension that provides a `fast_apply` tool to apply code
edits using [morphllm](https://morphllm.com) fast apply.

## Motivation

Making code changes with any model other than Claude is a pain. The example
below is achieved with Gemini 2.5 Flash.

## Usage

https://github.com/user-attachments/assets/4e376995-5256-4288-9291-00bb70d15a22

## Installation (lazy.nvim):

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
