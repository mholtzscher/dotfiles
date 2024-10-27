{ ... }:
let
  user = "michaelholtzscher";
in
{
  users.users.michael = {
    name = user;
    home = "/Users/${user}";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.michael = import ../modules/home-manager/home.nix;
  };

  nix-homebrew = {
    enable = true;
    # Apple Silicon Only
    enableRosetta = true;
    # User owning the Homebrew prefix
    user = user;

    autoMigrate = true;
  };
}
