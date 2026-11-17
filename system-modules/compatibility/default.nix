{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libinput
        libxkbcommon
        libxcb
        libx11
        mesa
        wayland
      ];
    };
  };

  services = {
    envfs.enable = true;
  };

  environment.systemPackages = lib.mkIf config.systemOptions.enableWine [
    pkgs.wine
    pkgs.wine64
    pkgs.wine-wayland
    pkgs.winetricks
  ];
}
