{ ... }:
{
  programs = {
    lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = "3"; # String value
          theme = {
            # List containing two strings
            activeBorderColor = [
              "#ff9e64"
              "bold"
            ];

            # List containing one string
            inactiveBorderColor = [ "#27a1b9" ];

            # List containing two strings
            searchingActiveBorderColor = [
              "#ff9e64"
              "bold"
            ];

            # List containing one string
            optionsTextColor = [ "#7aa2f7" ];

            # List containing one string
            selectedLineBgColor = [ "#283457" ];

            # List containing one string
            cherryPickedCommitFgColor = [ "#7aa2f7" ];

            # List containing one string
            cherryPickedCommitBgColor = [ "#bb9af7" ];

            # List containing one string
            markedBaseCommitFgColor = [ "#7aa2f7" ];

            # List containing one string
            markedBaseCommitBgColor = [ "#e0af68" ];

            # List containing one string
            unstagedChangesColor = [ "#db4b4b" ];

            # String value (Note: Original YAML had this as a string, not a list)
            defaultFgColor = [ "#c0caf5" ];
          };
        };
      };
    };
  };
}
