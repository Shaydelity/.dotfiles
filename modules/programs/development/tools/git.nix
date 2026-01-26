{ pkgs, globals, ... }:
{
  home-manager.users.${globals.user} = {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Zohiu";
          email = "mail@zohiu.de";
        };

        credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
        commit.gpgsign = true;
        user.signingkey = "F93EC485BC2ED258";
        init.defaultBranch = "main";
      };
    };

    home.packages = [
      pkgs.github-backup
    ];
  };
}
