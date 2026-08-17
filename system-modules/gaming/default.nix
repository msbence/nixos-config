{
  lib,
  config,
  pkgs,
  options,
  useUnstableChannels,
  ...
}:

lib.mkMerge [
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

      gamescope = {
        enable = true;
        capSysNice = false;
      };

      gamemode.enable = true;
    };

    preservation.preserveAt."/persisted".directories =
      lib.optionals (config.systemOptions.deviceIsSteamDeck)
        [ "/var/lib/decky-loader" ];

    services.sunshine = lib.mkIf config.systemOptions.enableSunshine {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    environment.systemPackages = lib.mkIf config.systemOptions.enableSteam [
      pkgs.steam-run
      pkgs.gamescope-wsi
      pkgs.mangohud
    ];

    services.udev.extraRules = lib.mkIf config.systemOptions.enableSteam ''
      SUBSYSTEM=="input", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="301c", MODE="0660", GROUP="input"
    '';

    environment.sessionVariables = lib.mkIf config.systemOptions.enableSteam {
      STEAM_FORCE_DESKTOPUI_SCALING = config.systemOptions.steamScale;
    };
  }

  (lib.optionalAttrs (useUnstableChannels && options ? jovian) {
    # if on unstable and jovian available, import, and check if needs activation as well
    # ugly but works :)
    jovian = lib.mkIf (config.systemOptions.deviceIsSteamDeck) {
      steam.enable = true;
      steam.autoStart = true;
      steam.user = config.userOptions.username;
      steam.desktopSession = config.systemOptions.windowManager;
      decky-loader.enable = true;
      decky-loader.user = config.userOptions.username;
      steamos.useSteamOSConfig = true;
      devices.steamdeck.enable = true;
      devices.steamdeck.autoUpdate = true;
      devices.steamdeck.enableOsFanControl = false; # full of bugs
    };
  })
]
