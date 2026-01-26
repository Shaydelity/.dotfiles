{ globals, pkgs, ... }:
{
  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        qview
      ]
    );

    xdg.configFile."qView/qView.conf".text = ''
      [General]
      configversion=7.1
      firstlaunch=true
      optionstab=0

      [options]
      afterdelete=2
      allowmimecontentdetection=true
      askdelete=true
      bgcolor=#000000
      bgcolorenabled=true
      colorspaceconversion=1
      cropmode=0
      cursorzoom=true
      filteringenabled=false
      fractionalzoom=true
      fullscreendetails=false
      language=system
      loopfoldersenabled=true
      maxwindowresizedpercentage=70
      menubarenabled=false
      minwindowresizedpercentage=20
      pastactualsizeenabled=true
      preloadingmode=1
      quitonlastwindow=false
      saverecents=true
      scalefactor=25
      scalingenabled=true
      scalingtwoenabled=true
      scrollzoom=1
      skiphidden=false
      slideshowreversed=0
      slideshowtimer=5
      sortdescending=0
      sortmode=0
      titlebaralwaysdark=true
      titlebarmode=1
      updatenotifications=false
      windowresizemode=1
    '';
  };
}
