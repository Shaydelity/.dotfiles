{
  pkgs,
  globals,
  ...
}:

{
  home-manager.users.${globals.user} = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        # Theme
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons

        # Web dev
        dbaeumer.vscode-eslint

        # Languages
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        mathiasfrohlich.kotlin
        svelte.svelte-vscode
        ms-python.python

        # Nix support
        jnoortheen.nix-ide
        arrterian.nix-env-selector
        mkhl.direnv

        # Tools
        yy0931.vscode-sqlite3-editor
        tauri-apps.tauri-vscode
        ms-vscode.live-server
        ms-vsliveshare.vsliveshare
      ];
    };
  };
}
