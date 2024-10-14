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
    };

    starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[[♥](green) ❯](maroon)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };
        directory = {
          truncation_length = 4;
          style = "bold lavender";
          read_only = " ro";
          truncate_to_repo = false;
        };
        git_commit = {
          tag_symbol = " tag ";
        };
        git_status = {
          ahead = ">";
          behind = "<";
          diverged = "<>";
          renamed = "r";
          deleted = "x";
        };
        aws = {
          symbol = "aws ";
        };
        azure = {
          symbol = "az ";
        };
        bun = {
          symbol = "bun ";
        };
        c = {
          symbol = "C ";
        };
        cobol = {
          symbol = "cobol ";
        };
        conda = {
          symbol = "conda ";
        };
        crystal = {
          symbol = "cr ";
        };
        cmake = {
          symbol = "cmake ";
        };
        daml = {
          symbol = "daml ";
        };
        dart = {
          symbol = "dart ";
        };
        deno = {
          symbol = "deno ";
        };
        dotnet = {
          symbol = ".NET ";
        };
        docker_context = {
          symbol = "docker ";
          disabled = true;
        };
        elixir = {
          symbol = "exs ";
        };
        elm = {
          symbol = "elm ";
        };
        fennel = {
          symbol = "fnl ";
        };
        fossil_branch = {
          symbol = "fossil ";
        };
        gcloud = {
          symbol = "gcp ";
        };
        git_branch = {
          symbol = "git ";
        };
        gleam = {
          symbol = "gleam ";
        };
        golang = {
          symbol = "go ";
        };
        gradle = {
          symbol = "gradle ";
        };
        guix_shell = {
          symbol = "guix ";
        };
        hg_branch = {
          symbol = "hg ";
        };
        java = {
          symbol = "java ";
        };
        julia = {
          symbol = "jl ";
        };
        kotlin = {
          symbol = "kt ";
        };
        lua = {
          symbol = "lua ";
        };
        nodejs = {
          symbol = "nodejs ";
        };
        memory_usage = {
          symbol = "memory ";
        };
        meson = {
          symbol = "meson ";
        };
        nats = {
          symbol = "nats ";
        };
        nim = {
          symbol = "nim ";
        };
        nix_shell = {
          symbol = "nix ";
        };
        ocaml = {
          symbol = "ml ";
        };
        opa = {
          symbol = "opa ";
        };
        os.symbols = {
          AIX = "aix ";
          Alpaquita = "alq ";
          AlmaLinux = "alma ";
          Alpine = "alp ";
          Amazon = "amz ";
          Android = "andr ";
          Arch = "rch ";
          Artix = "atx ";
          CentOS = "cent ";
          Debian = "deb ";
          DragonFly = "dfbsd ";
          Emscripten = "emsc ";
          EndeavourOS = "ndev ";
          Fedora = "fed ";
          FreeBSD = "fbsd ";
          Garuda = "garu ";
          Gentoo = "gent ";
          HardenedBSD = "hbsd ";
          Illumos = "lum ";
          Kali = "kali ";
          Linux = "lnx ";
          Mabox = "mbox ";
          Macos = "mac ";
          Manjaro = "mjo ";
          Mariner = "mrn ";
          MidnightBSD = "mid ";
          Mint = "mint ";
          NetBSD = "nbsd ";
          NixOS = "nix ";
          OpenBSD = "obsd ";
          OpenCloudOS = "ocos ";
          openEuler = "oeul ";
          openSUSE = "osuse ";
          OracleLinux = "orac ";
          Pop = "pop ";
          Raspbian = "rasp ";
          Redhat = "rhl ";
          RedHatEnterprise = "rhel ";
          RockyLinux = "rky ";
          Redox = "redox ";
          Solus = "sol ";
          SUSE = "suse ";
          Ubuntu = "ubnt ";
          Ultramarine = "ultm ";
          Unknown = "unk ";
          Void = "void ";
          Windows = "win ";
        };
        package = {
          symbol = "pkg ";
        };
        perl = {
          symbol = "pl ";
        };
        php = {
          symbol = "php ";
        };
        pijul_channel = {
          symbol = "pijul ";
        };
        pulumi = {
          symbol = "pulumi ";
        };
        purescript = {
          symbol = "purs ";
        };
        python = {
          symbol = "py ";
        };
        quarto = {
          symbol = "quarto ";
        };
        raku = {
          symbol = "raku ";
        };
        ruby = {
          symbol = "rb ";
        };
        rust = {
          symbol = "rs ";
        };
        scala = {
          symbol = "scala ";
        };
        spack = {
          symbol = "spack ";
        };
        solidity = {
          symbol = "solidity ";
        };
        status = {
          symbol = "x={(bold red) ";
        };
        sudo = {
          symbol = "sudo ";
        };
        swift = {
          symbol = "swift ";
        };
        typst = {
          symbol = "typst ";
        };
        terraform = {
          symbol = "terraform ";
        };
        zig = {
          symbol = "zig ";
        };
        palette = "catppuccin_mocha";
        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };
    };
  };
}
