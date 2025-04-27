{ pkgs, ... }:
let
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "k9s";
    rev = "fdbec82284744a1fc2eb3e2d24cb92ef87ffb8b4";
    sha256 = "sha256-9h+jyEO4w0OnzeEKQXJbg9dvvWGZYQAO4MbgDn6QRzM=";
  };
in
{
  programs = {
    k9s = {
      enable = true;
      settings = {
        k9s = {
          ui = {
            skin = "catppuccin-mocha";
          };
        };
      };
      skins = {
        catppuccin-mocha = "${catppuccin}/dist/catppuccin-mocha.yaml";
      };
    };

  };
}
