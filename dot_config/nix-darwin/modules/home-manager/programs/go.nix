{ ... }:
{
  programs = {
    go = {
      enable = true;
      # packages = {
      #   "github.com/air-verse/air" = builtins.fetchGit "https://github.com/air-verse/air";
      # };
    };
  };
}
