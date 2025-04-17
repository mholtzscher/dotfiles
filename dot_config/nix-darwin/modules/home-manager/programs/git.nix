{
  ...
}:
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
        options = {
          # dark = true;
        };
      };
      # includes = [ { path = ../themes/catppuccin.gitconfig; } ];
    };
  };
}
