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
        pkgs = import nixpkgs{ inherit system; };
        rPacks = with pkgs.rPackages; [ 
          pagedown rmarkdown tidyverse 
          httpgd knitr geobr sf 
          jsonlite rlang 
          basedosdados cartogram
          cartogramR dotenv 
        ];
      in
      {
        devShells.default = pkgs.mkShell { 
          nativeBuildInputs = with pkgs; [ 
            bashInteractive
          ]; 
          buildInputs = with pkgs; [ 
            R
            chromium 
            pandoc
            geos
            gdal
            proj
          ] ++ rPacks;
          shellHook = ''
            export R_PATH=''$(which R)
          '';
        };
      }
    );
}
