{
  config,
  ...
}:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  rofi-theme = {
    inputbar = {
      padding = mkLiteral "10 5";
      spacing = mkLiteral "10px";
    };

    element = {
      padding = mkLiteral "10 5";
      spacing = mkLiteral "8px";
    };

    window = {
      padding = mkLiteral "5px";
      border = mkLiteral "2px";
    };
  };
in
{
  programs.rofi = {
    enable = true;

    modes = [
      "drun"
    ];

    theme = rofi-theme;
  };
}
