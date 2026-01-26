{ globals, pkgs, ... }:

{
  # VERY IMPORTANT:
  # Once rebuilt with tailscale enabled, use the following command:
  # sudo tailscale up --operator=$USER
  services.tailscale.enable = true;

  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        trayscale # Tailscale Manager Application
      ]
    );
  };
}
