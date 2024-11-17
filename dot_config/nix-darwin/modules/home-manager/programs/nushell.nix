{ ... }:
{
  programs = {
    nushell = {
      enable = true;
      extraConfig = builtins.readFile ../files/nushell/functions.nu;
      shellAliases = {
        build = "./gradlew build --parallel";
        ch = "chezmoi";
        chad = "chezmoi add";
        chap = "chezmoi apply";
        chd = "chezmoi diff";
        chda = "chezmoi data";
        chs = "chezmoi status";
        fmt = "./gradlew spotlessApply --parallel";
        gradle = "./gradlew";
        ll = "ls -al";
        c = "clear";
        lg = "lazygit";
        sso = "aws_change_profile";
      };
    };
  };
}
