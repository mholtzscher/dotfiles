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

  nix-homebrew = {
    enable = true;
    # Apple Silicon Only
    enableRosetta = true;
    # User owning the Homebrew prefix
    user = user;

    autoMigrate = true;
  };

  system.defaults = {
    dock = {
      persistent-apps = [
        "/Users/michaelholtzcher/Applications/Google Gemini.app"
        "/Users/michaelholtzcher/Applications/Reclaim.app"
      ];
    };
  };
}
