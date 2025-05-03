{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      dejavu_fonts
      fira-code-symbols
      hack-font
      nerdfonts
      noto-fonts
      noto-fonts-emoji
      open-sans
      roboto
      roboto-mono
      source-sans
      source-serif
      font-awesome
      powerline-fonts
      powerline-symbols
    ];
  };
}
