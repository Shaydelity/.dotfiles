{ ... }:
{
  xdg.configFile."micro/settings.json".text = ''
    {
      "tabstospaces": true,
      "tabsize": 2,
      "colorscheme": "simple",
    }
  '';

  xdg.configFile."micro/bindings.json".text = ''
    {
      "Ctrl-S": "Save",
      "Ctrl-X": "Quit",
      "Ctrl-Z": "Undo",
      "Ctrl-Y": "Redo",
    }
  '';
}
