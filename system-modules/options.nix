{ lib, systemProperties, ... }:
{
  options.systemOptions = with lib; {
    ###> AUDIO
    enableAudio = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable audio services";
    };
    ###<
    ###> BLUETOOTH
    enableBluetooth = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable audio services";
    };
    ###<
    ###> BOOT
    enablePlymouth = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Display Plymouth instead of console logging";
    };
    plymouthTheme = mkOption {
      type = types.str;
      default = "blockchain";
      description = "Name of the adi1090x Plymouth theme to use";
    };
    plymouthScale = mkOption {
      type = types.int;
      default = 1;
      description = "Scaling factor for Plymouth";
    };
    enableNetbootXyz = mkOption {
      type = types.bool;
      default = true;
      description = "Add netboot.xyz to the systemd-boot menu";
    };
    ###<
    ###> DISPLAY
    windowManager = mkOption {
      type = types.enum [
        "none"
        "hyprland"
      ];
      default = if systemProperties.type == "server" then "none" else "hyprland";
      description = "Sets the window manager to use";
    };
    ###<
    ###> FONTS
    enableAdditionalFonts = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Install additional fonts";
    };
    ###<
    ###> HARDWARE
    enableFirmwareUpdates = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable fwupd";
    };
    enableThunderbolt = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Thunderbolt management";
    };
    enableLibInput = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable libinput and touchpad support";
    };
    ###<
    ###> LOCALE
    timeZone = mkOption {
      type = types.str;
      default = if systemProperties.type == "server" then "Etc/UTC" else "Europe/Vienna";
      description = "Set the timezone";
    };
    keyboardLayout = mkOption {
      type = types.str;
      default = "uk";
      description = "Set the used keyboard layout";
    };
    additionalLocaleSettings = mkOption {
      type = types.attrs;
      default =
        if systemProperties.type == "server" then
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
      default = if systemProperties.type == "server" then false else true;
      description = "Enable NetworkManager";
    };
    enableWireguard = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable Wireguard VPN";
    };
    enableWireshark = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable Wireshark packet capturing";
    };
    enableGns3 = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable GNS3 network simulator";
    };
    enableSsh = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then true else false;
      description = "Enable SSH server";
    };
    permitSshRootLogin = mkOption {
      type = types.enum [
        "yes"
        "no"
      ];
      default = "no";
      description = "Enable root login using SSH";
    };
    ###<
    ###> POWER
    enablePowerManagement = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable TLP for power management";
    };
    powerManagementProfile = mkOption {
      type = types.attrs;
      default = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";

        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 100;
      };
      description = "Set TLP Power Profile settings";
    };
    ###<
    ###> PRINTING
    enablePrinting = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable CUPS for printing";
    };
    ###<
    ###> SECURITY
    enableAutologin = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable automatic login";
    };
    enableFingerprint = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fingerprint services";
    };
    enableTpm = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable TPM2 services";
    };
    enableGpg = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable GPG services";
    };
    enableFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Enable firewall";
    };
    ###<
    ###> USERS

    ###<
    ###> VIRTUALISATION
    enableDocker = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable the Docker daemon";
    };

    enableQemu = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable libvirt and QEMU";
    };

    enableCockpit = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable Cockpit and it's webUI";
    };
    ###<
  };
}
