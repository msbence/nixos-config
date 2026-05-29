{
  lib,
  config,
  pkgs,
  ...
}:
{
  fonts = lib.mkIf config.systemOptions.enableAdditionalFonts {
    fontDir.enable = true;

    packages =
      with pkgs;
      [
        dejavu_fonts
        fira-code-symbols
        hack-font
        noto-fonts
        inter
        noto-fonts-color-emoji
        open-sans
        roboto
        roboto-mono
        source-sans
        source-serif
        font-awesome
        source-code-pro
        powerline-fonts
        powerline-symbols
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };
}
