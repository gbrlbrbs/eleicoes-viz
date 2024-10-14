{
  description = "Flake for reproducible environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell { 
          nativeBuildInputs = [ pkgs.bashInteractive ]; 
          buildInputs = with pkgs; [ 
            (
              rWrapper.override{ 
                packages = with rPackages; [
                  pagedown rmarkdown tidyverse
                  httpgd languageserver knitr
                  geobr
                  jsonlite rlang
                ];
            })
            chromium 
            pandoc 
          ];

          shellHook = ''
            export R_HOME=''$(R -e "cat(R.home())" -q -s)
            export R_PATH=''$(which R)
          '';
        };
      }
    );
}
