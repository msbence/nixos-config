{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs = lib.mkIf config.systemOptions.enableSteam {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      protontricks.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        hidapi
      ];
    };

    gamemode.enable = true;
  };

  environment.systemPackages = lib.mkIf config.systemOptions.enableSteam [
    pkgs.steam-run
  ];

  services.udev.extraRules = lib.mkIf config.systemOptions.enableSteam ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="301c", MODE="0660", GROUP="input"
  '';

  environment.sessionVariables = lib.mkIf config.systemOptions.enableSteam {
    STEAM_FORCE_DESKTOPUI_SCALING = config.systemOptions.steamScale;
  };
}
