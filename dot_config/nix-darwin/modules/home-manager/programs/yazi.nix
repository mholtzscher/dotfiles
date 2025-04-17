{
  pkgs,
  ...
}:
let
  yazi-flavors = pkgs.fetchFromGitHub {
    owner = "BennyOe";
    repo = "tokyo-night.yazi";
    rev = "main";
    sha256 = "sha256-+wZzxLPCttJ2WoDdI89sQ+CcZSFIA44HshxMoh4rJIs=";
  };
in
{
  programs = {
    yazi = {
      enable = true;
      flavors = {
        tokyonight = "${yazi-flavors}";
      };
      theme = {
        flavor = {
          dark = "tokyonight";
        };
      };
    };
  };
}
