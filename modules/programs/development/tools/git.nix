{
  pkgs,
  globals,
  ...
}:
{
  home-manager.users.${globals.user} = {
    programs.git = {
      enable = true;

      userName = "Shaydelity";
      userEmail = "shaydelity@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        # credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
        # commit.gpgsign = true;
        # user.signingkey = "F93EC485BC2ED258";
      };
    };

    home.packages = [
      pkgs.github-backup
    ];
  };
}
