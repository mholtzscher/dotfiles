{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };
    taps = [
      "hashicorp/tap"
    ];
    brews = [
      # "go"
      "asdf"
      "mas"
      "sops"
      "hashicorp/tap/terraform"
      "pyenv-virtualenv"
    ];
    casks = [
      "1password"
      "1password-cli"
      "arc"
      "bartender"
      "deskpad"
      "docker"
      "ghostty"
      "intellij-idea"
      "jetbrains-toolbox"
      "nightfall"
      "postman"
      "raycast"
      "slack"
      "ticktick"
    ];
    masApps = {
      "In Your Face" = 1476964367;
      "WhatsApp" = 310633997;
      "Microsoft Remote Desktop" = 1295203466;
      "Numbers" = 409203825;
      "Better Snap Tool" = 417375580;
      "Hazeover" = 430798174;
      "Postico" = 6446933691;
    };
  };

}
