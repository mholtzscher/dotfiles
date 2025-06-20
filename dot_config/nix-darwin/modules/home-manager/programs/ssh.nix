{ ... }:
{
  programs = {
    ssh = {
      enable = true;
      includes = [
        "~/.ssh/1Password/config"
      ];
      matchBlocks = {
        mina-nas = {
          hostname = "10.69.69.156";
          user = "root";
        };

        max-nas = {
          hostname = "10.69.69.186";
          user = "root";
        };

        wanda = {
          hostname = "10.69.69.60";
          user = "michael";
        };
      };

      extraConfig = ''
        Host *
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
    };
  };
}
