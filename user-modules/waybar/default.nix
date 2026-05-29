{
  systemOptions,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      topBar = {
        layer = "top";
        position = "top";
        height = 34;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "group/datetime"
        ];
        modules-right = [
          "bluetooth"
          "custom/vpn"
          "network#wireless"
          "network#wired"
          "pulseaudio"
          "backlight"
          "battery"
          "custom/user"
        ];

        "hyprland/workspaces" = {
          all-outputs = false;
        };

        "group/datetime" = {
          "orientation" = "horizontal";
          "modules" = ["clock#date" "clock#time" "clock#day"];
        };

        "clock#date" = {
          "format" = "{:%Y-%m-%d}";
          "interval" = 1;
        };

        "clock#time" = {
          "format" = "{:%H:%M:%S}";
          "interval" = 1;
        };

        "clock#day" = {
          "format" = "{:%A}";
          "interval" = 1;
        };

        "bluetooth" = {
          "format" = "BT: {status}";
        };

        "custom/vpn" = {
          "format" = "VPN: off";
        };

        "network#wireless" = {
          "interface" = "wl*";
          "format" = "WLAN: {ifname}";
        };

        "network#wired" = {
          "interface" = "e*";
          "format" = "LAN: {ifname}";
        };

        "pulseaudio" = {
          "format" = "VOL: {volume}%";
        };

        "backlight" = {
          "format" = "BL: {percent}%";
        };

        "battery" = {
          "format" = "BAT: {capacity}%";
        };

        "custom/user" = {
          "exec" = "whoami";
          "interval" = "once";
        };
      };

      bottomBar = {
        layer = "top";
        position = "bottom";
        height = 34;
        modules-left = [
          "custom/hostname"
          "cpu"
          "temperature"
          "memory"
          "memory#swap"
          "disk"
          "temperature#disk"
        ];
        modules-right = [
          "tray"
          "custom/display"
          "hyprland/language"
        ];

        "custom/display" = {
          "format" = "DISPLAY_PROFILE";
        };

        "hyprland/language" = {
          "format-en" = "KEYLAYOUT: EN";
          "format-hu" = "KEYLAYOUT: HU";
        };

        "custom/hostname" = {
          "exec" = "hostname";
          "interval" = "once";
        };

        "cpu" = {
          "format" = "CPU: {usage}%";
        };

        "temperature" = {
          "hwmon-path" = [ "/sys/devices/platform/asus-ec-sensors/hwmon/hwmon5/temp1_input" ];
          "format" = "CPUTEMP: {temperatureC}°C";
        };

        "memory" = {
          "format" = "MEM: {total:0.0f}GB ({percentage}%)";
        };

        "memory#swap" = {
          "format" = "SWAP: {swapTotal:0.0f}GB ({swapPercentage}%)";
        };

        "disk" = {
          "path" = if (systemOptions.impermanenceType == "none") then "/" else "/persisted";
          "format" = "DISK: {specific_free:0.0f}/{specific_total:0.0f}GB";
          "unit" = "GB";
        };

        "temperature#disk" = {
          "hwmon-path" = [
            "/sys/devices/pci0000:00/0000:00:01.2/0000:04:00.0/nvme/nvme0/hwmon3/temp1_input"
          ];
          "format" = "DISKTEMP: {temperatureC}°C";
        };
      };
    };

    style = builtins.readFile ./style.css; # not using a path literal here, as stylix wants to do stuff
  };

  stylix.targets.waybar.fonts.override.sizes.desktop = 11;
  stylix.targets.waybar.addCss = false;
}
