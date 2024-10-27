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
          users.users.michael = {
            name = "michael";
            home = "/Users/michael";
          };
          users.users.michaelholtzcher = {
            name = "michaelholtzcher";
            home = "/Users/michaelholtzcher";
          };

          nixpkgs.config.allowUnfree = true;

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
            NSGlobalDomain = {
              AppleKeyboardUIMode = 3;
              AppleInterfaceStyle = "Dark";
              AppleShowAllExtensions = true;
              InitialKeyRepeat = 15;
              KeyRepeat = 2;
            };

            dock = {
              autohide = false;
              tilesize = 48;
              orientation = "right";
              minimize-to-application = true;
              show-process-indicators = true;
              show-recents = false;
              persistent-apps = [
                "/Applications/Arc.app"
                "/System/Applications/Messages.app"
                "/Applications/WhatsApp.app"
                "${pkgs.discord}/Applications/Discord.app"
                "${pkgs.slack}/Applications/Slack.app"
                "/Applications/1Password.app"
                "${pkgs.wezterm}/Applications/WezTerm.app"
                "/Applications/Postico.app"
                "/Applications/IntelliJ IDEA.app"
                "/System/Applications/Mail.app"
                "/System/Applications/Calendar.app"
                "/System/Applications/Music.app"
                "/System/Applications/News.app"
              ];
              wvous-bl-corner = 1;
              wvous-br-corner = 1;
              wvous-tl-corner = 1;
              wvous-tr-corner = 1;
            };

            finder = {
              AppleShowAllExtensions = true;
              ShowPathbar = true;
              FXEnableExtensionChangeWarning = false;
              FXPreferredViewStyle = "clmv";
            };

            trackpad = {
              Clicking = true;
            };

            screencapture.location = "~/Library/Mobile Documents/com~apple~CloudDocs/ScreenShots";
            loginwindow.GuestEnabled = false;

            CustomUserPreferences = {
              "com.pointum.hazeover" = {
                Enabled = 1;
                Intensity = "70";
              };
              "com.surteesstudios.Bartender" = {
                UseBartenderBar = 1;
                TriggerSettings = {
                  Battery1 = {
                    description = "";
                    icon = {
                      SFSymbolName = "bolt.fill";
                      isTemplate = 1;
                    };
                    isActive = 1;
                    isSpecial = 0;
                    menuBarItemsToActivate = {
                      "com.apple.controlcenter-Battery" = "Battery";
                    };
                    name = "Show Battery when battery condition met";
                    triggerSpecificDict = {
                      "Battery-When" = "OnBatteryPower";
                      "Battery-percentage" = 50;
                    };
                    type = [ "Battery" ];
                  };
                  TimeMachine1 = {
                    description = "";
                    icon = {
                      SFSymbolName = "bolt.fill";
                      isTemplate = 1;
                    };
                    isActive = 1;
                    isSpecial = 0;
                    menuBarItemsToActivate = {
                      "com.apple.systemuiserver-TimeMachine.TMMenuExtraHost" = "SystemUIServer";
                      "com.apple.systemuiserver-TimeMachineMenuExtra.TMMenuExtraHost" = "Time Machine";
                    };
                    name = "Show Time Machine when time machine is backing up.";
                    triggerSpecificDict = {
                      Script = "tmutil status | awk -F'=' '/Running/ {print $2*1}'";
                    };
                    type = [ "Script" ];
                  };
                  WiFi1 = {
                    description = "";
                    icon = {
                      SFSymbolName = "bolt.fill";
                      isTemplate = 1;
                    };
                    isActive = 1;
                    isSpecial = 0;
                    menuBarItemsToActivate = {
                      "com.apple.controlcenter-WiFi" = "Wi-Fi";
                    };
                    name = "Show Wi-Fi when Wi-Fi condition met";
                    triggerSpecificDict = {
                      ShowOn = "AllDisconnected";
                    };
                    type = [ "WiFi" ];
                  };
                };
              };
              "pl.maketheweb.cleanshotx" = {
                afterScreenshotActions = [
                  0
                  1
                  2
                ];
                afterVideoActions = [
                  0
                  2
                ];
                # exportPath = "${builtins.getEnv "HOME"}/Library/Mobile Documents/com~apple~CloudDocs/ScreenShots";
              };
            };

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
      darwinConfigurations = {
        "Michaels-M1-Max" = nix-darwin.lib.darwinSystem {
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
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.michael = import ./modules/home-manager/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
        "Michaels-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          modules = [
            configuration
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                # Apple Silicon Only
                enableRosetta = true;
                # User owning the Homebrew prefix
                user = "michaelholtzcher";

                autoMigrate = true;
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.michaelholtzcher = import ./modules/home-manager/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };

      # Expose the package set, including overlays, for convenience.
      # darwinPackages = self.darwinConfigurations."Michaels-M1-Max".pkgs;
    };
}
