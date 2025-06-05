{ ... }:
{
  programs = {
    ghostty = {
      enable = true;
      package = null;
      settings = {
        # font-family = "GoMono Nerd Font";
        # font-family = "BlexMono Nerd Font Mono";
        # font-family = "Terminess Nerd Font";
        # font-family = "Iosevka Nerd Font Mono";
        font-family = "Iosevka Nerd Font";
        # font-family = "JetBrains Mono";
        #font-family-bold = "Iosevka NFM Bold"
        #font-family-italic = "Iosevka NFM Italic"
        #font-family-bold-italic = "Iosevka NFM Bold Italic"
        font-size = "13";

        theme = "tokyonight_night";

        background-blur-radius = 20;
        mouse-hide-while-typing = true;
        window-decoration = true;
        keybind = "global:cmd+alt+/=toggle_quick_terminal";
        macos-option-as-alt = true;

        window-height = 60;
        window-width = 200;
        quick-terminal-position = "center";
        quick-terminal-screen = "macos-menu-bar";
      };
    };
  };
}
