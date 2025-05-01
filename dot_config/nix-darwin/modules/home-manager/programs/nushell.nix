{ ... }:
{
  programs = {
    nushell = {
      enable = true;
      extraConfig = builtins.readFile ../files/nushell/functions.nu;
      shellAliases = {
        # General aliases
        ll = "ls -al";
        c = "clear";
        lg = "lazygit";
        pbj = "pbpaste | jq";

        # chezmoi aliases
        ch = "chezmoi";
        chad = "chezmoi add";
        chrad = "chezmoi re-add";
        chap = "chezmoi apply";
        chd = "chezmoi diff --pager delta";
        chda = "chezmoi data";
        chs = "chezmoi status";

        # nix aliases
        nup = "darwin-rebuild switch --flake ~/.config/nix-darwin";
        nfu = "nix flake update";
        ngc = "nix-collect-garbage -d";

        # work aliases
        aws_ecr_login = "aws ecr get-login-password | docker login --username AWS --password-stdin 188442536245.dkr.ecr.us-west-2.amazonaws.com";
        # aws_export_envs = "export (aws configure export-credentials --profile $AWS_PROFILE --format env-no-export )";
        aws_local = "env AWS_PROFILE=localstack aws --endpoint-url=http://localhost.localstack.cloud:4566";

        build = "./gradlew build --parallel";
        gradle = "./gradlew";
        sso = "aws_change_profile";
      };
    };
  };
}
