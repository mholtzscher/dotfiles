{ ... }:
{
  programs = {
    nushell = {
      enable = true;
      extraConfig = builtins.readFile ../files/nushell/functions.nu;
      shellAliases = {
        # General aliases
        ch = "chezmoi";
        chradd = "chezmoi re-add";
        chap = "chezmoi apply";
        chd = "chezmoi diff --pager delta";
        chda = "chezmoi data";
        chu = "chezmoi update";
        chs = "chezmoi status";

        ghd = "gh dash";
        j = "just";
        ltd = "eza --tree --only-dirs --level 3";
        ll = "ls -al";
        lg = "lazygit";
        n = "nvim";
        oc = "opencode";

        nfu = "nix flake update";
        ngc = "nix-collect-garbage -d";
        nup = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin";

        sso = "aws_change_profile";
      };
      settings = {
        edit_mode = "vi";
        show_banner = false;
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
      };
    };
  };
}
