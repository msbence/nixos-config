{
  lib,
  config,
  hostname,
  systemArchitecture,
  ...
}:
{
  options.systemOptions = with lib; {
    ###> GENERAL
    architecture = mkOption {
      type = types.enum [
        "x86_64-linux"
        "aarch64-linux"
      ];
      default = systemArchitecture;
    };
    hostname = mkOption {
      type = types.str;
      readOnly = true;
      default = hostname;
    };
    deviceType = mkOption {
      type = types.enum [
        "desktop"
        "laptop"
        "server"
      ];
      description = "Machine role, controls most defaults";
    };
    deviceIsVirtual = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then true else false;
    };
    systemStateVersion = mkOption {
      type = types.str;
    };
    ###<
    ###> AUDIO
    enableAudio = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable audio services";
    };
    ###<
    ###> BLUETOOTH
    enableBluetooth = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable bluetooth services";
    };
    ###<
    ###> BOOT
    enablePlymouth = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Display Plymouth instead of console logging";
    };
    plymouthTheme = mkOption {
      type = types.str;
      default = "blockchain";
      description = "Name of the adi1090x Plymouth theme to use";
    };
    plymouthScale = mkOption {
      type = types.str;
      default = "1";
      description = "Scaling factor for Plymouth";
    };
    ###<
    ###> DISPLAY
    windowManager = mkOption {
      type = types.enum [
        "none"
        "hyprland"
      ];
      default = if config.systemOptions.deviceType == "server" then "none" else "hyprland";
      description = "Sets the window manager to use";
    };
    ###<
    ###> FONTS
    enableAdditionalFonts = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Install additional fonts";
    };
    ###<
    ###> HARDWARE
    enableFirmwareUpdates = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable fwupd";
    };
    enableThunderbolt = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Thunderbolt management";
    };
    enableLibInput = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable libinput and touchpad support";
    };
    ###<
    ###> IMPERMANENCE
    impermanenceType = mkOption {
      type = types.enum [
        "none"
        "btrfs"
        "tmpfs"
      ];
      default = "tmpfs";
      description = "Enables and sets impermanence method used";
    };
    ###<
    ###> LOCALE
    keyboardLayout = mkOption {
      type = types.str;
      default = "uk";
      description = "Sets the used keyboard layout";
    };
    additionalLocaleSettings = mkOption {
      type = types.attrs;
      default =
        if config.systemOptions.deviceType == "server" then
          { }
        else
          {
            LC_ADDRESS = "de_AT.UTF-8";
            LC_MEASUREMENT = "de_AT.UTF-8";
            LC_MONETARY = "de_AT.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "hu_HU.UTF-8";
            LC_TELEPHONE = "de_AT.UTF-8";
            LC_TIME = "hu_HU.UTF-8";
          };
      description = "Set additional locale format";
    };
    ###<
    ###> NETWORKING
    enableNetworkManager = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable NetworkManager";
    };
    enableWireshark = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable Wireshark packet capturing";
    };
    enableGns3 = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable GNS3 network simulator";
    };
    ###<
    ###> NIX
    allowUnfreePackages = mkOption {
      type = types.bool;
      default = true;
      description = "Enables un-free packages from nixpkgs";
    };
    ###<
    ###> PRINTING
    enablePrinting = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable CUPS for printing";
    };
    ###<
    ###> SECURITY
    enableAutologin = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable automatic login (one password will be presented anyhow due to FDE)";
    };
    enableGpg = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable GPG services";
    };
    enableFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Enable firewall";
    };
    sopsKeyPath = mkOption {
      type = types.str;
      default =
        if config.systemOptions.impermanenceType == "none" then
          "/var/lib/sops-nix/key.txt"
        else
          "/persisted/var/lib/sops-nix/key.txt";
      description = "Sets the path where the age key is stored for sops-nix";
    };
    ###<
    ###> VIRTUALISATION
    enableDocker = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable the Docker daemon";
    };

    enableQemu = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable libvirt and QEMU";
    };

    enableCockpit = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable Cockpit and it's webUI";
    };
    ###<
  };
}
