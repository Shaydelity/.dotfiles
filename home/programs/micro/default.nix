{ ... }:
{
home.file.".config/micro/settings.json".text = ''
{
  "tabstospaces": true,
  "tabsize": 2,
  "colorscheme": "simple",
}
'';

home.file.".config/micro/bindings.json".text = ''
{
  "Ctrl-S": "Save",
  "Ctrl-X": "Quit",
  "Ctrl-Z": "Undo",
  "Ctrl-Y": "Redo",
}
'';
}
