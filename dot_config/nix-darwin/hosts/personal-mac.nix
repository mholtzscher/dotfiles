{ pkgs, ... }:
let
  user = "michael";
in
{
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${user} = import ../modules/home-manager/home.nix;
  };

  homebrew = {
    brews = [
      "hashicorp/tap/terraform"
    ];
    casks = [
      "capacities"
      "intellij-idea-ce"
    ];
  };

  nix-homebrew = {
    enable = true;
    # Apple Silicon Only
    enableRosetta = true;
    # User owning the Homebrew prefix
    user = user;

    autoMigrate = true;
  };

  system = {
    primaryUser = user;
    defaults = {
      dock = {
        persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Obsidian.app"
          "/System/Applications/Messages.app"
          "/Applications/WhatsApp.app"
          "${pkgs.discord}/Applications/Discord.app"
          "/Applications/1Password.app"
          "/Applications/Ghostty.app"
          "/Applications/IntelliJ IDEA CE.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
          "/Applications/Todoist.app"
          "/System/Applications/Music.app"
          "/System/Applications/News.app"
        ];
      };

    };
  };

}
