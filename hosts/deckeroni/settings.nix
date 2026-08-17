{ config, pkgs, ... }:
{
  systemOptions.systemStateVersion = "26.05";
  userOptions.homeManagerStateVersion = "26.05";

  systemOptions.deviceType = "laptop";
  systemOptions.deviceIsVirtual = false;
  systemOptions.hasRgbLeds = false;

  systemOptions.enableFirewall = false;

  systemOptions.bootloaderType = "refind";
  systemOptions.bootloaderTimeout = 2;
  services.openssh.enable = true;

  themeOptions.colorScheme = "brown";

  home-manager.users.${config.userOptions.username}.programs.git.signing.signByDefault = false;

  # steam deck stuff -> to be ported to the options/module system

  #  services.logind.settings.Login.HandlePowerKey = "suspend";

  boot.kernelPackages = pkgs.linuxPackages;
  programs.hyprland.enable = true;
  systemOptions.enableAutologin = false;
  jovian.steam.enable = true;
  jovian.decky-loader.enable = true;
  jovian.decky-loader.user = "raptor";
  preservation.preserveAt."/persisted".directories = [ "/var/lib/decky-loader" ];
  jovian.steamos.useSteamOSConfig = true;
  jovian.devices.steamdeck.enable = true;
  jovian.devices.steamdeck.autoUpdate = true;
  jovian.devices.steamdeck.enableOsFanControl = false; # full of bugs
  jovian.steam.autoStart = true;
  jovian.steam.desktopSession = "hyprland";
  jovian.steam.user = "raptor";
}
