{
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    overlays.enable = false;

    # https://tinted-theming.github.io/tinted-gallery/#base16-railscasts
    base16Scheme = "${pkgs.base16-schemes}/share/themes/railscasts.yaml";
    override = {
      base01 = "282f40"; # gray-blue
      base02 = "313b50"; # gray-blue
      base03 = "3f4c67"; # gray-blue
      base08 = "9d6c7c"; # pale pink
      base0D = "4e7da4"; # darker blue
    };

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    fonts.sizes = {
      desktop = 10;
      popups = 10;
      applications = 12;
      terminal = 12;
    };
  };
}
