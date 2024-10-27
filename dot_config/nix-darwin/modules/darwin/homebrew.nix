{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };
    brews = [
      "asdf"
      "go"
      "gum"
      "mas"
      "slides"
      "watch"
    ];
    casks = [
      "1password"
      "1password-cli"
      "arc"
      "bartender"
      "deskpad"
      "docker"
      "intellij-idea"
      "nightfall"
      "postman"
      "raycast"
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
