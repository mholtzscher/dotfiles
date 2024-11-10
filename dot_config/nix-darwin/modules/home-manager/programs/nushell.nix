{ ... }:
{
  programs = {
    nushell = {
      enable = true;
      extraConfig = builtins.readFile ../files/nushell/functions/fmt.nu;
      # environmentVariables = {
      #   EDITOR = "nvim";
      # };
      shellAliases = {
        ll = "ls -al";
        vim = "nvim";
        c = "clear";
        lg = "lazygit";
        # tree = "lsd --tree -a --ignore-glob .git";
        # treed = "lsd --tree -a -d --ignore-glob .git --ignore-glob gen";
        pbj = "pbpaste | jq";
        # cacheclear = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";
        # ip = "dig +short myip.opendns.com @resolver1.opendns.com";
        # localip = "ipconfig getifaddr en0";
        # show = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
        # hide = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";
        # weather = "curl wttr.in";
        clean = "git clean -Xdf";
      };
    };
  };
}
