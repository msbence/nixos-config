{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs = {
    nix-ld.enable = true;
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
