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
      "FelixKratz/formulae"
      "jetbrains/utils"
      "nikitabobko/tap"
      "sst/tap"
    ];
    brews = [
      "awscli"
      "asdf"
      "borders"
      "JetBrains/utils/kotlin-lsp"
      "mas"
      "sst/tap/opencode"
      # "sketchybar"
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
      "zen"
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
