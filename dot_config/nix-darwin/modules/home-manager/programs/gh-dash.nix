{ ... }:
{
  programs = {
    gh-dash = {
      enable = true;
      settings = {
        prSections = [
          {
            title = "Legends";
            filters = "org:paytient team:paytient/legends-of-the-ledger updated>={{ nowModify '-1w' }}";
          }
          {
            title = "Legends 2";
            filters = "org:paytient team-review-requested:legends-of-the-ledger updated>={{ nowModify '-1w' }}";
          }
          {
            title = "Paytient Mine";
            filters = "is:open org:paytient author:@me";
          }
          {
            title = "M3P Open";
            filters = "is:open repo:paytient/m3p";
          }
          {
            title = "M3P Recent";
            filters = "repo:paytient/m3p updated>={{ nowModify '-1w' }}";
          }
          {
            title = "Personal";
            filters = "is:open -org:paytient author:@me";
          }
        ];
      };
    };
  };
}
