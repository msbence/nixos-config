{
  lib,
  config,
  pkgs,
  ...
}:
{
  fonts = lib.mkIf config.systemOptions.enableAdditionalFonts {
    fontDir.enable = true;

    packages = with pkgs; [
      inter
      open-sans
      roboto
      roboto-mono
      source-sans
      source-serif

      nerd-fonts.sauce-code-pro
      nerd-fonts.symbols-only

      noto-fonts-color-emoji
    ];
  };
}
