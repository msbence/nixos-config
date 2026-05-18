{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
lib.mkIf (config.themeOptions.colorScheme == "blue") {
  themeOptions = {
    base16ColorScheme = "${pkgs.base16-schemes}/share/themes/railscasts.yaml";
    stylixColorOverrides = {
      base01 = "282f40"; # gray-blue
      base02 = "313b50"; # gray-blue
      base03 = "3f4c67"; # gray-blue
      base08 = "9d6c7c"; # pale pink
      base0D = "4e7da4"; # darker blue
    };

    cursorTheme = { 
      package = inputs.future-hyprcursor.packages.${config.systemOptions.architecture}.default;
      name = "future-cyan-hyprcursor";
    };
  };
}
