{ pkgs, ... }:

{
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    atuin
    bat
    bottom
    buf
    chezmoi
    discord
    dive
    dust
    fd
    fish
    fzf
    gh
    gnused
    grpcurl
    hey
    httpie
    jc
    jq
    k9s
    ko
    kubernetes-helm
    lazygit
    lsd
    mkalias
    nixfmt-rfc-style
    neovim
    obsidian
    ripgrep
    rm-improved
    slack
    sops
    starship
    tldr
    vim
    vscode
    wezterm
    yq
    zellij
    zoxide
  ];

  home.file = {
    ".ssh/config".source = ./files/ssh-config;
    ".config/zellij/config.kdl".source = ./files/zellij.kdl;
    ".asdfrc".source = ./files/asdfrc;
    ".config/kafkactl/config.yml".source = ./files/kafkactl.yaml;
    ".config/1Password/ssh/agent.toml".source = ./files/1password-agent.toml;
    ".config/fish/themes/catppuccin-mocha.theme".source =
      pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "fish";
        rev = "cc8e4d8fffbdaab07b3979131030b234596f18da";
        sha256 = "sha256-udiU2TOh0lYL7K7ylbt+BGlSDgCjMpy75vQ98C1kFcc=";
      }
      + "/themes/Catppuccin Mocha.theme";
  };

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
      };
      interactiveShellInit = ''
        brew shellenv 2>/dev/null | source || true
        fish_add_path "$ASDF_DIR/bin"
        fish_add_path "$HOME/.asdf/shims"

        if status --is-interactive && type -q asdf
            source (brew --prefix asdf)/libexec/asdf.fish
        end

        for kubeconfigFile in (fd -e yml -e yaml . "$HOME/.kube")
            set -gx KUBECONFIG "$kubeconfigFile:$KUBECONFIG"
        end

        set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --color=selected-bg:#45475a \
        --multi"
      '';

      functions = {
        build = {
          body = "gradle build --parallel";
          description = "build project";
        };

        clean = {
          body = "git clean -Xdf $argv";
          description = "clean untracked files";
        };

        fmt = {
          body = builtins.readFile ./files/fish/functions/fmt.fish;
          description = "Run the formatter for the current project";
        };

        gitignore = {
          body = "curl -sL https://www.gitignore.io/api/$argv";
          description = "get gitgnore for language";
        };

        ip = {
          body = "dig +short myip.opendns.com @resolver1.opendns.com $argv";
          wraps = "dig +short myip.opendns.com @resolver1.opendns.com";
          description = "get public ip address";
        };

        ips = {
          body = ''
            ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, ""); print }' $argv
          '';
          description = "Show all ip addresses for machine";
        };

        lg = {
          body = "lazygit $argv";
          description = "lazygit";
          wraps = "lazygit";
        };

        ll = {
          body = "lsd -al $argv";
          description = "lsd -al";
          wraps = "lsd";
        };

        localip = {
          body = "ipconfig getifaddr en0 $argv";
          description = "get local ip address";
        };

        ls = {
          body = "lsd $argv";
          description = "lsd";
          wraps = "lsd";
        };

        nu = {
          body = "darwin-rebuild switch --flake ~/.config/nix-darwin";
          description = "Rebuild nix-darwin";
        };

        pbj = {
          body = "pbpaste | jq $argv";
          description = "pretty print json from clipboard";
        };

        show = {
          body = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
          description = "show hidden files in finder";
        };

        tf = {
          body = "terraform $argv";
          description = "terraform";
          wraps = "terraform";
        };

        tree = {
          body = "lsd --tree -a --ignore-glob .git $argv";
          description = "pretty tree view of all files";
          wraps = "lsd";
        };

        treed = {
          body = "lsd --tree -a -d --ignore-glob .git --ignore-glob gen $argv";
          description = "pretty tree view of only directories";
          wraps = "lsd";
        };

        weather = {
          body = "curl wttr.in $argv";
          description = "get weather";
        };
      };
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
        FZF_DEFAULT_OPTS = " \
            --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
            --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
            --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
            --color=selected-bg:#45475a \
            --multi";
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
