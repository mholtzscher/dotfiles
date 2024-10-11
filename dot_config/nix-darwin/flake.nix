{
  description = "Zenful Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
    }:
    let
      configuration =
        { pkgs, config, ... }:
        {
          nixpkgs.config.allowUnfree = true;
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.asdf
            pkgs.atuin
            pkgs.bat
            pkgs.bottom
            pkgs.buf
            pkgs.chezmoi
            pkgs.dive
            pkgs.docker
            pkgs.dust
            pkgs.fd
            pkgs.fish
            pkgs.fzf
            pkgs.gh
            pkgs.gnused
            pkgs.grpcurl
            pkgs.hey
            pkgs.httpie
            pkgs.jc
            pkgs.jq
            pkgs.k9s
            pkgs.ko
            pkgs.kubernetes-helm
            pkgs.lazygit
            pkgs.lsd
            pkgs.mkalias
            pkgs.nixfmt-rfc-style
            pkgs.neovim
            pkgs.obsidian
            pkgs.ripgrep
            pkgs.rm-improved
            pkgs.slack
            pkgs.sops
            pkgs.starship
            pkgs.tldr
            pkgs.vim
            pkgs.vscode
            pkgs.wezterm
            pkgs.yq
            pkgs.zellij
            pkgs.zoxide
          ];

          homebrew = {
            enable = true;
            brews = [
              "awscli"
              "go"
              "gum"
              "hugo"
              "mas"
              "slides"
              "thefuck"
              "watch"
            ];
            casks = [
              "1password"
              "1password-cli"
              "arc"
              "bartender"
              "deskpad"
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
            onActivation.cleanup = "zap";
          };

          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          # nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          fonts.packages = [
            (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })
          ];

          security.pam.enableSudoTouchIdAuth = true;

          system.defaults = {
            dock.autohide = false;
            dock.tilesize = 48;
            dock.show-recents = false;
            dock.orientation = "bottom";
            dock.minimize-to-application = true;
            screencapture.location = "~/Library/Mobile Documents/com~apple~CloudDocs/ScreenShots";
            finder.FXPreferredViewStyle = "clmv";
            loginwindow.GuestEnabled = false;
            NSGlobalDomain.AppleInterfaceStyle = "Dark";
            NSGlobalDomain.KeyRepeat = 2;
            NSGlobalDomain.InitialKeyRepeat = 15;

            dock.persistent-apps = [
              "/Applications/Arc.app"
              "/System/Applications/Messages.app"
              "/Applications/WhatsApp.app"
              "/Applications/Discord.app"
              "/Applications/1Password.app"
              "${pkgs.wezterm}/Applications/WezTerm.app"
              "/System/Applications/Mail.app"
              "/System/Applications/Calendar.app"
              "/System/Applications/Music.app"
              "/System/Applications/News.app"
            ];
          };

          system.activationScripts.applications.text =
            let
              env = pkgs.buildEnv {
                name = "system-applications";
                paths = config.environment.systemPackages;
                pathsToLink = "/Applications";
              };
            in
            pkgs.lib.mkForce ''
              # Set up applications.
              echo "setting up /Applications..." >&2
              rm -rf /Applications/Nix\ Apps
              mkdir -p /Applications/Nix\ Apps
              find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
              while read src; do
                app_name=$(basename "$src")
                echo "copying $src" >&2
                ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
              done
            '';
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Michaels-M1-Max
      darwinConfigurations."Michaels-M1-Max" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              # Apple Silicon Only
              enableRosetta = true;
              # User owning the Homebrew prefix
              user = "michael";

              autoMigrate = true;
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Michaels-M1-Max".pkgs;
    };
}
