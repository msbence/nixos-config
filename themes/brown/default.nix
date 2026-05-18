{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
lib.mkIf (config.themeOptions.colorScheme == "brown") {
  themeOptions = {
    base16ColorScheme = "${pkgs.base16-schemes}/share/themes/bespin.yaml";
    stylixColorOverrides = {
      base01 = "282321"; # darker brown
      base05 = "bdbbb7"; # lighter gray
      base06 = "dedbd4"; # lighter gray
      base08 = "9d6c7c"; # pale pink
      base0D = "c39f6b"; # creme
    };

    cursorTheme = { 
      package = inputs.future-hyprcursor.packages.${config.systemOptions.architecture}.default;
      name = "future-original-hyprcursor";
    };
  };
}
