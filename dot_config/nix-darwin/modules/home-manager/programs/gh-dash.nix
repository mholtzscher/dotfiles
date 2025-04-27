{ ... }:
{
  programs = {
    gh-dash = {
      enable = true;
      settings = {
        prSections = [
          {
            title = "My Pull Requests";
            filters = "is:open author:@me";
          }
          {
            title = "Legends Review Requested";
            filters = "is:open org:paytient team-review-requested:paytient/legends-of-the-ledger";
          }
          {
            title = "Review Requested";
            filters = "is:open review-requested:@me";
          }
          {
            filters = "is:open repo:paytient/m3p";
            title = "M3P Open";
          }
          {
            filters = "repo:paytient/m3p";
            title = "M3P All";
            limit = 20;
          }
        ];

        pager = {
          diff = "delta";
        };

        defaults = {
          preview = {
            open = true;
            width = 150;
          };
        };
      };
    };
  };
}
