{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".ssh/config".source = ./dotfiles/ssh-config;
    ".config/zellij/config.kdl".source = ./dotfiles/zellij.kdl;
    ".asdfrc".source = ./dotfiles/asdfrc;
    ".config/kafkactl/config.yml".source = ./dotfiles/kafkactl.yaml;
    ".config/1Password/ssh/agent.toml".source = ./dotfiles/1password-agent.toml;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./git.nix
    ./starship.nix
  ];

  programs = {
    atuin = {
      enable = true;
      settings = {
        sync_address = "https://atuin.holtzscher.com";
      };
    };

    bat = {
      enable = true;
      config = {
        theme = "catppuccin-mocha";
      };
      themes = {
        catppuccin-mocha = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
            sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
    };

    bottom = {
      enable = true;
      settings = {
        colors = {
          table_header_color = "#f5e0dc";
          all_cpu_color = "#f5e0dc";
          avg_cpu_color = "#eba0ac";
          cpu_core_colors = [
            "#f38ba8"
            "#fab387"
            "#f9e2af"
            "#a6e3a1"
            "#74c7ec"
            "#cba6f7"
          ];
          ram_color = "#a6e3a1";
          swap_color = "#fab387";
          rx_color = "#a6e3a1";
          tx_color = "#f38ba8";
          widget_title_color = "#f2cdcd";
          border_color = "#585b70";
          highlighted_border_color = "#f5c2e7";
          text_color = "#cdd6f4";
          graph_color = "#a6adc8";
          cursor_color = "#f5c2e7";
          selected_text_color = "#11111b";
          selected_bg_color = "#cba6f7";
          high_battery_color = "#a6e3a1";
          medium_battery_color = "#f9e2af";
          low_battery_color = "#f38ba8";
          gpu_core_colors = [
            "#74c7ec"
            "#cba6f7"
            "#f38ba8"
            "#fab387"
            "#f9e2af"
            "#a6e3a1"
          ];
          arc_color = "#89dceb";
        };
      };
    };

    fd = {
      enable = true;
    };

    fzf = {
      enable = true;
    };

    k9s = {
      enable = true;
      settings = {
        k9s = {
          ui = {
            skin = "catppuccin-mocha";
          };
        };
      };
      skins = {
        catppuccin-mocha = ./themes/k9s-catppuccin-mocha.yaml;
      };
    };

    lazygit = {
      enable = true;
      settings = {
        gui.theme = {
          activeBorderColor = [
            "#f5c2e7"
            "bold"
          ];
          inactiveBorderColor = [ "#a6adc8" ];
          optionsTextColor = [ "#89b4fa" ];
          selectedLineBgColor = [ "#313244" ];
          selectedRangeBgColor = [ "#313244" ];
          cherryPickedCommitBgColor = [ "#45475a" ];
          cherryPickedCommitFgColor = [ "#f5c2e7" ];
          unstagedChangesColor = [ "#f38ba8" ];
          defaultFgColor = [ "#cdd6f4" ];
          searchingActiveBorderColor = [ "#f9e2af" ];
        };
      };
    };

    fish = {
      enable = true;
      shellAbbrs = {
        sso = "aws_change_profile";
        build = "gradle build --parallel";
        nu = "darwin-rebuild switch --flake ~/.config/nix-darwin";

      };
      interactiveShellInit = ''
        fish_add_path "$ASDF_DIR/bin"
        fish_add_path "$HOME/.asdf/shims"

        if status --is-interactive && type -q asdf
            source (brew --prefix asdf)/libexec/asdf.fish
        end

        for kubeconfigFile in (fd -e yml -e yaml . "$HOME/.kube")
            set -gx KUBECONFIG "$kubeconfigFile:$KUBECONFIG"
        end
      '';
      plugins = [
        {
          name = "catppuccin";
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "fish";
            rev = "cc8e4d8fffbdaab07b3979131030b234596f18da";
            sha256 = "sha256-udiU2TOh0lYL7K7ylbt+BGlSDgCjMpy75vQ98C1kFcc=";
          };
        }
      ];
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        -- Pull in the wezterm API
        local wezterm = require("wezterm")

        -- This will hold the configuration.
        local config = wezterm.config_builder()

        -- Appearance
        config.color_scheme = "Catppuccin Mocha"
        config.hide_tab_bar_if_only_one_tab = true
        config.font = wezterm.font("Iosevka Nerd Font")
        config.font_size = 13.0

        config.initial_cols = 200
        config.initial_rows = 35

        -- https://github.com/wez/wezterm/issues/5990
        config.front_end = "WebGpu"

        -- and finally, return the configuration to wezterm
        return config
      '';
    };

    zsh = {
      enable = true;
      shellAliases = {
        vim = "nvim";
        c = "clear";
        lg = "lazygit";
        ls = "lsd";
        ll = "lsd -al";
        tree = "lsd --tree -a --ignore-glob .git";
        treed = "lsd --tree -a -d --ignore-glob .git --ignore-glob gen";
        pbj = "pbpaste | jq";
        cacheclear = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";
        ip = "dig +short myip.opendns.com @resolver1.opendns.com";
        localip = "ipconfig getifaddr en0";
        show = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
        hide = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";
        weather = "curl wttr.in";
        clean = "git clean -Xdf";
      };
      initExtra = ''
        if [ -f /Users/michaelholtzcher/code/onboarding/engineering.sh ]; then
            source /Users/michaelholtzcher/code/onboarding/engineering.sh
        fi
      '';
      sessionVariables = {
        PATH = "$HOME/go/bin:$PATH";
      };
      antidote = {
        enable = true;
        plugins = [
          "zsh-users/zsh-syntax-highlighting"
          "zsh-users/zsh-completions"
          "zsh-users/zsh-autosuggestions"
          "Aloxaf/fzf-tab"
          "getantidote/use-omz"
          "ohmyzsh/ohmyzsh path:lib"
          "ohmyzsh/ohmyzsh path:plugins/asdf"
          "ohmyzsh/ohmyzsh path:plugins/aws"
          "ohmyzsh/ohmyzsh path:plugins/command-not-found"
          "ohmyzsh/ohmyzsh path:plugins/git"
          "ohmyzsh/ohmyzsh path:plugins/gradle"
          "ohmyzsh/ohmyzsh path:plugins/sudo"
          "ohmyzsh/ohmyzsh path:plugins/terraform"
        ];
      };
    };

    zoxide = {
      enable = true;
    };
  };
}
