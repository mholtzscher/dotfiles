{ ... }:
let
  user = "michaelholtzcher";
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
      "tfenv"
    ];
    casks = [
      "intellij-idea"
    ];
    masApps = {
      "In Your Face" = 1476964367;
    };
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
          "/System/Applications/Messages.app"
          "/Applications/WhatsApp.app"
          "/Applications/Slack.app"
          "/Applications/1Password.app"
          "/Applications/Ghostty.app"
          "/Applications/Postico.app"
          "/Applications/IntelliJ IDEA.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
          "/Applications/Todoist.app"
          "/System/Applications/Music.app"
          # "/System/Applications/News.app"
          "/Users/michaelholtzcher/Applications/Google Gemini.app"
          "/Users/michaelholtzcher/Applications/Reclaim.app"
        ];
      };
    };
  };
}
