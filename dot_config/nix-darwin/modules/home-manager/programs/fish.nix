{ ... }:
{
  programs = {
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
          body = builtins.readFile ../files/fish/functions/fmt.fish;
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

        watch = {
          body = ''
            if test (count $argv) -lt 2
                    echo "Usage: fish_watch <interval> <command>"
                    return 1
                end

                set interval $argv[1]
                set command (string join " " $argv[2..-1])

                while true
                    clear
                    eval $command
                    sleep $interval
                end
          '';
          description = "watch command";
        };

        weather = {
          body = "curl wttr.in $argv";
          description = "get weather";
        };
      };
    };
  };
}
