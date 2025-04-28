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
            rev = "main";
            sha256 = "sha256-mriZ9QBe1QIDsBkGd+tmg4bNFtD0evuSom2pWyQ1yEM=";
          };
          file = "extras/sublime/tokyonight_night.tmTheme";
        };
        catppuccin-mocha = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "main";
            sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
    };
  };
}
