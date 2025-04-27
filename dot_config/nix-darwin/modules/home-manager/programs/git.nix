{
  pkgs,
  ...
}:
let
  tokyonight = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "054790b8676d0c561b22320d4b5ab3ef175f7445";
    sha256 = "sha256-mriZ9QBe1QIDsBkGd+tmg4bNFtD0evuSom2pWyQ1yEM=";
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
        enable = true;
      };
      includes = [ { path = "${tokyonight}/extras/delta/tokyonight_night.gitconfig"; } ];
    };
  };
}
