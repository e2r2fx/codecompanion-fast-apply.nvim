{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    devenv.url = "github:cachix/devenv";
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {self, ...} @ inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
      unstablePkgs = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      devShells.default = inputs.devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          ({
            pkgs,
            config,
            ...
          }: {
            packages = with unstablePkgs; [
              openssl
              gnumake
              git
              curl
            ];
            dotenv.disableHint = true;
          })
        ];
      };
    });
}