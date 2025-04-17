{
  pkgs,
  ...
}:
{
  programs = {
    bat = {
      enable = true;
      config = {
        theme = "tokyo-night";
      };
      themes = {
        tokyo-night = {
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "tokyonight.nvim";
            rev = "054790b8676d0c561b22320d4b5ab3ef175f7445";
            sha256 = "sha256-mriZ9QBe1QIDsBkGd+tmg4bNFtD0evuSom2pWyQ1yEM=";
          };
          file = "extras/sublime/tokyonight_night.tmTheme";
        };
        catppuccin-mocha = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
            sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
    };
  };
}
