{ ... }:
{
  programs = {
    ssh = {
      enable = true;
      includes = [
        "~/.ssh/1Password/config"
      ];
      # matchBlocks = {
      #   mina-nas = {
      #     identityFile = "~/.ssh/mina-nas-id_ed25519.pub";
      #     identitiesOnly = true;
      #     hostname = "10.69.69.156";
      #     user = "root";
      #   };
      #
      #   max-nas = {
      #     identityFile = "~/.ssh/max-nas-id_ed25519.pub";
      #     identitiesOnly = true;
      #     hostname = "10.69.69.186";
      #     user = "root";
      #   };
      #
      #   wanda = {
      #     identityFile = "~/.ssh/wanda-id_ed25519.pub";
      #     identitiesOnly = true;
      #     hostname = "10.69.69.60";
      #     user = "michael";
      #   };
      # };

      extraConfig = ''
        Host *
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
    };
  };
}
