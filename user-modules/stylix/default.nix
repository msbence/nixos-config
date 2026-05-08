{
  pkgs,
  userOptions,
  ...
}:
{
  imports = [
    ./themes/${userOptions.themeColor}.nix
  ];

  stylix = {
    enable = true;
    overlays.enable = false;

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
