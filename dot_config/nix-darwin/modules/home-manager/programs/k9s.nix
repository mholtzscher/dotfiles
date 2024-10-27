{ ... }:
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
        catppuccin-mocha = ../themes/k9s-catppuccin-mocha.yaml;
      };
    };

  };
}
