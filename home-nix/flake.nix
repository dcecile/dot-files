{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";
    rust-overlay.url = "github:oxalica/rust-overlay/58160be7abad81f6f8cb53120d5b88c16e01c06d";
  };

  outputs = { nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = true;
          };
        };
      in
        {
          packages.default = pkgs.symlinkJoin {
            name = "home";
            paths = [
              pkgs.awscli2
              pkgs.git-branchless
              pkgs.gnupg
              pkgs.mpv
              pkgs.neovim
              pkgs.poppler-utils
              pkgs.ripgrep
              pkgs.terraform
              pkgs.tree
              pkgs.zsh
            ];
          };
        }
    );
}
