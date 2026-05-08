{
  pkgs,
  ...
}:
{
  stylix = {
    # https://tinted-theming.github.io/tinted-gallery/#base16-bespin
    base16Scheme = "${pkgs.base16-schemes}/share/themes/bespin.yaml";
    override = {
      base01 = "282321"; # darker brown
      base05 = "bdbbb7"; # lighter gray
      base06 = "dedbd4"; # lighter gray
      base08 = "9d6c7c"; # pale pink
      base0D = "c39f6b"; # creme
    };
  };
}
