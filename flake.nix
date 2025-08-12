{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    devenv.url = "github:cachix/devenv";
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {self, ...} @ inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      buildPlugin = attrs:
        pkgs.vimUtils.buildVimPlugin {
          pname = attrs.pname;
          version = "dev";
          src = pkgs.fetchFromGitHub {
            inherit (attrs) owner repo rev hash;
          };
          doCheck = false;
        };

      plenary = buildPlugin {
        pname = "plenary.nvim";
        owner = "nvim-lua";
        repo = "plenary.nvim";
        rev = "b9fd5226c2f76c951fc8ed5923d85e4de065e509";
        hash = "sha256-9Un7ekhBxcnmFE1xjCCFTZ7eqIbmXvQexpnhduAg4M0=";
      };

      nvim_treesitter = buildPlugin {
        pname = "nvim-treesitter";
        owner = "nvim-treesitter";
        repo = "nvim-treesitter";
        rev = "42fc28ba918343ebfd5565147a42a26580579482";
        hash = "sha256-CVs9FTdg3oKtRjz2YqwkMr0W5qYLGfVyxyhE3qnGYbI=";
      };

      mini = buildPlugin {
        pname = "mini.nvim";
        owner = "echasnovski";
        repo = "mini.nvim";
        rev = "4035ef97407a6661ae9ff913ff980e271a658502";
        hash = "sha256-VBwCwwsE+wpUUuVP0f85pVvrAEjGfnVj78i0CfukSLg=";
      };

      codecompanion = buildPlugin {
        pname = "codecompanion.nvim";
        owner = "olimorris";
        repo = "codecompanion.nvim";
        rev = "a61730e84f92453390a4e1250482033482c33e84";
        hash = "sha256-aux5G2W1oP726s+GQALm31JTRzl1KSMS4OSNbDEZ4M0=";
      };
    in {
      packages = {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
        devenv-test = self.devShells.${system}.default.config.test;
      };

      devShells.default = inputs.devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          ({
            pkgs,
            config,
            ...
          }: {
            packages = with pkgs; [
              openssl
              gnumake
              git
              curl
              neovim
              plenary
              nvim_treesitter
              mini
              codecompanion
            ];

            enterTest = ''
              nvim --headless --noplugin -u ./scripts/minimal_init.lua -c "lua MiniTest.run()"
            '';

            #something

            dotenv.disableHint = true;
          })
        ];
      };
    });
}

