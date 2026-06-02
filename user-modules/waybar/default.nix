{
  config,
  systemOptions,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      topBar = {
        name = "topBar";
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
          "mpris"
          "pulseaudio"
          "bluetooth"
          "group/networking"
          "custom/user"
        ];

        "group/networking" = {
          "orientation" = "horizontal";
          "modules" = [
            "custom/vpn"
            "network#wireless"
            "network#wired"
          ];
        };

        "hyprland/workspaces" = {
          all-outputs = false;
        };

        "group/datetime" = {
          "orientation" = "horizontal";
          "modules" = [
            "clock#date"
            "clock#time"
            "clock#day"
          ];
        };

        "clock#date" = {
          "format" = "{:%Y-%m-%d}";
          "interval" = 1;
          "tooltip" = false;
        };

        "clock#time" = {
          "format" = "{:%H:%M:%S}";
          "interval" = 1;
          "tooltip" = false;
        };

        "clock#day" = {
          "format" = "{:%A}";
          "interval" = 1;
          "tooltip" = false;
        };

        "mpris" = {
          "tooltip" = false;
          "interval" = 1;
          "max-length" = 45;
          "title-len" = 32; # max-13
          "format" = "{status_icon}  {title} [{position}/{length}]";
          "status-icons" = {
            "playing" = "";
            "paused" = "";
            "stopped" = "";
          };
        };

        "bluetooth" = {
          "format" = "";
          "format-disabled" = "󰂲";
          "format-connected" = "󰂱  {device_alias}";
          "format-connected-battery" = "󰂱  {device_alias} ({device_battery_percentage})";
          "on-click" = "blueman-manager";
          "tooltip" = false;
        };

        "custom/vpn" = {
          "format" = "󱙱  VPN OFF";
          "tooltip" = false;
        };

        "network#wireless" = {
          "interface" = "wl*";
          "format" = "󰤨  {ipaddr}/{cidr}";
          "format-disconnected" = "󰤮";
          "tooltip" = false;
          "format-icons" = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
        };

        "network#wired" = {
          "interface" = "e*";
          "format" = "󰱓  {ipaddr}/{cidr}";
          "format-disconnected" = "󰅛";
          "tooltip" = false;
        };

        "pulseaudio" = {
          "format" = "{icon}  {volume}%";
          "format-muted" = "  XX";
          "format-icons" = {
            "default" = ["" "" ""];
            "headphone" = "";
            "headset" = "";
            "hands-free" = "";
          };
          "scroll-step" = 5.0;
          "max-volume" = 125;
          "on-click" = "pavucontrol";
          "on-click-right" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "tooltip" = false;
        };

        "backlight" = {
          "format" = "󰃠  {percent}%";
          "tooltip" = false;
        };

        "battery" = {
          "format" = "  {capacity}%";
          "tooltip" = false;
        };

        "custom/user" = {
          "format" = "  {}";
          "exec" = "whoami";
          "interval" = "once";
          "tooltip" = false;
        };
      };

      bottomBar = {
        name = "bottomBar";
        layer = "top";
        position = "bottom";
        height = 34;
        modules-left = [
          "custom/hostname"
          "battery"
          "group/hw-cpu"
          "group/hw-memory"
          "group/hw-disk"
        ];
        modules-right = [
          "tray"
          "group/layoutinfo"
        ];

        "group/layoutinfo" = {
          "orientation" = "horizontal";
          "modules" = [
            "backlight"
            "custom/display"
            "hyprland/language"
          ];
        };

        "group/hw-cpu" = {
          "orientation" = "horizontal";
          "modules" = [
            "cpu"
            "cpu#freq"
            "temperature"
          ];
        };

        "group/hw-memory" = {
          "orientation" = "horizontal";
          "modules" = [
            "memory"
            "memory#swap"
          ];
        };

        "group/hw-disk" = {
          "orientation" = "horizontal";
          "modules" = [
            "disk"
            "temperature#disk"
          ];
        };

        "custom/display" = {
          "format" = "  {}";
          "exec" =
            "cat ${config.home.homeDirectory}/.config/current_screen_layout | tr '[:lower:]' '[:upper:]'";
          "interval" = 5;
          "menu" = "on-click"; # TODO: this needs rework! not all hosts need this, but multiple may have different layouts
          "menu-file" = ./menus/display.xml;
          "menu-actions" = {
            "single" =
              "sed -i 's/desktop-all/desktop-single/g' ${config.home.homeDirectory}/.config/hyprdynamicmonitors/config.toml";
            "all" =
              "sed -i 's/desktop-single/desktop-all/g' ${config.home.homeDirectory}/.config/hyprdynamicmonitors/config.toml";
          };
          "tooltip" = false;
        };

        "hyprland/language" = {
          "format-en" = "  EN";
          "format-hu" = "  HU";
          "tooltip" = false;
        };

        "custom/hostname" = {
          "exec" = "hostname";
          "interval" = "once";
          "format" = "  {}";
          "tooltip" = false;
        };

        "cpu" = {
          "format" = "  {usage}%";
          "tooltip" = false;
        };

        "cpu#freq" = {
          "format" = "{avg_frequency:0.1f}GHz";
          "tooltip" = false;
        };

        "temperature" = {
          "hwmon-path" = [ "/sys/devices/platform/asus-ec-sensors/hwmon/hwmon7/temp1_input" ];
          "format" = "{temperatureC}°C";
          "tooltip" = false;
        };

        "memory" = {
          "format" = "  {used:0.1f}/{total:0.1f}GB";
          "tooltip" = false;
        };

        "memory#swap" = {
          "format" = "  {swapUsed:0.1f}/{swapTotal:0.1f}GB";
          "tooltip" = false;
        };

        "disk" = {
          "path" = if (systemOptions.impermanenceType == "none") then "/" else "/persisted";
          "format" = "  {specific_free:0.0f}GB free";
          "unit" = "GB";
          "tooltip" = false;
        };

        "temperature#disk" = {
          "hwmon-path" = [
            "/sys/devices/pci0000:00/0000:00:01.2/0000:04:00.0/nvme/nvme1/hwmon3/temp1_input"
          ];
          "format" = "{temperatureC}°C";
          "tooltip" = false;
        };
      };
    };

    style = builtins.readFile ./style.css; # not using a path literal here, as stylix wants to do stuff
  };

  stylix.targets.waybar.fonts.override.sizes.desktop = 11;
  stylix.targets.waybar.addCss = false;
}
