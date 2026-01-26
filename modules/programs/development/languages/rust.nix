{
  pkgs,
  globals,
  ...
}:

{
  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        rustc
        cargo
        clang
        rustfmt

        # For rust-analyzer
        rust-analyzer
      ]
    );
  };
}
