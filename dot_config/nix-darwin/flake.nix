{
  description = "Zenful Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
    }:
    let
      configuration =
        { pkgs, config, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          nix = {
            settings.experimental-features = "nix-command flakes";
            package = pkgs.nix;
            gc = {
              automatic = true;
              interval = {
                Weekday = 0;
                Hour = 2;
                Minute = 0;
              };
              options = "--delete-older-than 30d";
            };
          };

        };
    in
    {
      darwinConfigurations = {
        # Personal Mac
        "Michaels-M1-Max" = nix-darwin.lib.darwinSystem {
          modules = [
            ./hosts/personal-mac.nix
            ./modules/darwin
            configuration
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
          ];
        };
        # Work Mac
        "Michael-Holtzscher-Paytient" = nix-darwin.lib.darwinSystem {
          modules = [
            ./hosts/paytient-mac.nix
            ./modules/darwin
            configuration
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
          ];
        };
      };
    };
}
