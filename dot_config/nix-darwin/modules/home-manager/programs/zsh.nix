{ ... }:
{
  programs = {
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
  };
}
