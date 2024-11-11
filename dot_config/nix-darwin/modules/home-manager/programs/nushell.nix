{ ... }:
{
  programs = {
    nushell = {
      enable = true;
      extraConfig = builtins.readFile ../files/nushell/functions.nu;
      # environmentVariables = {
      #   EDITOR = "nvim";
      # };
      shellAliases = {
        build = "./gradlew build --parallel";
        fmt = "./gradlew spotlessApply --parallel";
        gradle = "./gradlew";
        ll = "ls -al";
        c = "clear";
        lg = "lazygit";
        pbj = "pbpaste | jq";
      };
    };
  };
}
