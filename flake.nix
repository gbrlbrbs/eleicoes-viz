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
        rPacks = with pkgs.rPackages; [ pagedown rmarkdown tidyverse httpgd languageserver knitr geobr sf jsonlite rlang basedosdados ];
      in
      {
        devShells.default = pkgs.mkShell { 
          nativeBuildInputs = [ pkgs.bashInteractive ]; 
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
