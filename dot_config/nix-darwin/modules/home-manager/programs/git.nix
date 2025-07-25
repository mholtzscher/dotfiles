{
  pkgs,
  ...
}:
let
  tokyonight = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "057ef5d260c1931f1dffd0f052c685dcd14100a3";
    sha256 = "sha256-1xZhQR1BhH2eqax0swlNtnPWIEUTxSOab6sQ3Fv9WQA=";
  };
in
{
  programs = {
    git = {
      enable = true;
      userName = "Michael Holtzscher";
      userEmail = "michael@holtzscher.com";
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyAn4X7ZQUyU7DQYHjQ4qccecA2r6ekk+jS1gjBfWAi";
      # signing.signByDefault = true;
      lfs.enable = true;
      delta = {
        options = {
          side-by-side = true;
          dark = true;
        };
        enable = true;
      };
      includes = [ { path = "${tokyonight}/extras/delta/tokyonight_night.gitconfig"; } ];
      extraConfig = {
        column = {
          ui = "auto";
        };
        branch = {
          sort = "-committerdate";
        };
        tag = {
          sort = "version:refname";
        };
        init = {
          defaultBranch = "main";
        };
      };

    };
  };
}
