{
  lib,
  pkgs,
  globals,
  ...
}:
{
  home-manager.users.${globals.user} = {
    programs.fish = {
      enable = true;
      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        {
          name = "tide";
          src = pkgs.fishPlugins.tide.src;
        }
        {
          name = "puffer";
          src = pkgs.fishPlugins.puffer.src;
        }
        {
          name = "fish-you-should-use";
          src = pkgs.fishPlugins.fish-you-should-use.src;
        }
      ];
    };

    home.packages = [
      pkgs.grc # Colorizer
    ];

    # home.activation.configure-tide = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #   ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Solid --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=No" || true
    # '';

    xdg.configFile."fish" = {
      source = ./config;
      recursive = true;
    };
  };
}
