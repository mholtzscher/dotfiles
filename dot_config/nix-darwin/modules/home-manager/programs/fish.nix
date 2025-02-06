{ ... }:
{
  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        ch = "chezmoi";
        chad = "chezmoi add";
        chradd = "chezmoi re-add";
        chap = "chezmoi apply";
        chd = "chezmoi diff";
        chda = "chezmoi data";
        chu = "chezmoi update";
        chs = "chezmoi status";
        sso = "aws_change_profile";
      };

      interactiveShellInit = ''
        brew shellenv 2>/dev/null | source || true
        fish_add_path "$ASDF_DIR/bin"
        fish_add_path "$HOME/.asdf/shims"

        if status --is-interactive && type -q asdf
            source (brew --prefix asdf)/share/fish/vendor_completions.d/asdf.fish
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
        __aws_sso_login = {
          body = ''
            if aws sts get-caller-identity >/dev/null 2>&1
                echo "Found valid AWS session"
            else
                echo "Logging into AWS"
                aws sso login
            end
          '';
          description = "Login to AWS SSO";
        };

        __ssh_tunnel = {
          body = ''
            set -l KEY_FILE_PATH $argv[1]
            set -l LOCAL_PORT $argv[2]
            set -l ENDPOINT $argv[3]
            set -l USER_HOSTNAME $argv[4]

            ssh -i $KEY_FILE_PATH -v -N -L $LOCAL_PORT:$ENDPOINT $USER_HOSTNAME
          '';
          description = "Create an SSH tunnel";
        };

        aws_change_profile = {
          body = builtins.readFile ../files/fish/functions/aws_change_profile.fish;
          description = "Change the AWS profile and login to SSO";
        };

        aws_ecr_login = {
          body = "aws ecr get-login-password | docker login --username AWS --password-stdin 188442536245.dkr.ecr.us-west-2.amazonaws.com";
          description = "Login to AWS ECR";
        };

        aws_export_envs = {
          body = "export (aws configure export-credentials --profile $AWS_PROFILE --format env-no-export )";
          description = "Export AWS credentials as environment variables";
        };

        aws_local = {
          body = "env AWS_PROFILE=localstack aws --endpoint-url=http://localhost.localstack.cloud:4566 $argv";
          description = "Run AWS CLI commands against LocalStack";
        };

        aws_logout = {
          body = ''
            if aws configure get sso_start_url --profile $AWS_PROFILE >/dev/null 2>&1
                aws sso logout
            end
            set -e AWS_PROFILE
          '';
          description = "logout from AWS SSO";
        };

        build = {
          body = "gradle build --parallel";
          description = "build project";
        };

        cacheclear = {
          body = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder $argv";
          description = " clear dns cache";
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

        gradle = {
          body = ''
            if test -e ./gradlew
                ./gradlew $argv
            else
                echo "No gradlew found"
            end
          '';
          description = "swaps ./gradlew for gradle";
          wraps = "./gradlew";

        };

        ifactive = {
          body = ''
            for interface in (networksetup -listallhardwareports | awk '/^Device:/ {print $2}')
                set ip (ipconfig getifaddr $interface)
                if test -n "$ip"
                    echo "$interface: $ip"
                end
            end
          '';
          description = "List network interfaces and IP addresses for all active network interfaces";
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

        nup = {
          body = "darwin-rebuild switch --flake ~/.config/nix-darwin";
          description = "Rebuild nix-darwin";
        };

        nfu = {
          body = "nix flake update";
          description = "Nix update flakes";
        };

        ngc = {
          body = "nix-collect-garbage -d";
          description = "Nix collect garbage";
        };

        pbj = {
          body = "pbpaste | jq $argv";
          description = "pretty print json from clipboard";
        };

        show = {
          body = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
          description = "show hidden files in finder";
        };

        sops_staging = {
          body = ''
            set -l AWS_PROFILE m3p_staging
            set -l SOPS_KMS_ARN "arn:aws:kms:us-west-2:211125772151:key/mrk-d167c0b6c99945fabfc4b629d52450ad"
            sops $argv
          '';
          description = "Run sops with the staging profile";
        };

        sops_uat = {
          body = ''
            set -l AWS_PROFILE m3p_uat
            set -l SOPS_KMS_ARN "arn:aws:kms:us-west-2:590183679435:key/mrk-3c092342ff9a488399c0ffee8e89eb53"
            sops $argv
          '';
          description = "Run sops with the uat profile";
        };

        sops_production = {
          body = ''
            set -l AWS_PROFILE m3p_production
            set -l SOPS_KMS_ARN "arn:aws:kms:us-west-2:533267267027:key/mrk-17f6bf15417942fd9237ed50d33363ca"
            sops $argv
          '';
          description = "Run sops with the production profile";
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

        tst = {
          body = builtins.readFile ../files/fish/functions/tst.fish;
          description = "Run tests based on the project type";
        };

        watch = {
          body = builtins.readFile ../files/fish/functions/watch.fish;
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
