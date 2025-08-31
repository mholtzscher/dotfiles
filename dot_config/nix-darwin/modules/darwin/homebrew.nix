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
      "jetbrains/utils"
      "nikitabobko/tap"
      "FelixKratz/formulae"
    ];
    brews = [
      "awscli"
      "asdf"
      "borders"
      "JetBrains/utils/kotlin-lsp"
      "mas"
    ];
    casks = [
      "1password"
      "1password-cli"
      "aerospace"
      "arc"
      "bartender"
      "deskpad"
      "docker-desktop"
      "ghostty"
      "jetbrains-toolbox"
      "nightfall"
      "obsidian"
      "postman"
      "raycast"
      "slack"
    ];
    masApps = {
      "WhatsApp" = 310633997;
      "Numbers" = 409203825;
      "Hazeover" = 430798174;
      "Postico" = 6446933691;
      "Todoist" = 585829637;
    };
  };

}
