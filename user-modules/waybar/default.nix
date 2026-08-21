{
  config,
  lib,
  pkgs,
  systemOptions,
  ...
}:
let
  vpn-status = pkgs.writeShellScriptBin "vpn-status" ''
    active=$(nmcli -t -f NAME,TYPE connection show --active | grep -E 'vpn|wireguard' | cut -d: -f1 | head -n1)
    if [ -n "$active" ]; then
      echo "$active"
    else
      echo "OFF"
    fi
  '';

  vpn-menu = pkgs.writeShellScriptBin "vpn-menu" ''
    active=$(nmcli -t -f NAME,TYPE connection show --active | grep -E 'vpn|wireguard' | cut -d: -f1 | head -n1)

    if [ -n "$active" ]; then
      choice=$(echo "Disconnect VPN" | walker --theme topright-menu --dmenu -n --maxheight 500 --maxwidth 200)
      if [ "$choice" = "Disconnect VPN" ]; then
        nmcli connection down "$active"
      fi
    else
      connections=$(nmcli -t -f NAME,TYPE connection show | grep -E 'vpn|wireguard' | cut -d: -f1)
      choice=$(echo "$connections" | walker --theme topright-menu --dmenu -n --maxheight 500 --maxwidth 200)
      
      if [ -n "$choice" ]; then
        nmcli connection up "$choice"
      fi
    fi
  '';
in
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
          "group/hw-audio"
          "bluetooth"
          "group/networking"
        ]
        ++ lib.optionals (systemOptions.hasTouchscreen) [ "custom/powermenu" ];

        "group/hw-audio" = {
          "orientation" = "horizontal";
          "modules" = [
            "pulseaudio"
            "custom/logitech"
          ];
        };

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
          "format-connected-battery" = "󰂱  {device_alias} ({device_battery_percentage}%)";
          "on-click" = "blueman-manager";
          "tooltip" = false;
        };

        "custom/vpn" = {
          format = "󱙱  VPN: {}";
          exec = "${vpn-status}/bin/vpn-status";
          interval = 5;
          on-click = "${vpn-menu}/bin/vpn-menu";
          tooltip = false;
        };

        "custom/logitech" = {
          format = "󰠇 {}%";
          hide-empty-text = true;
          exec = "headsetcontrol -o json | jq -r '.devices[].battery.level' | sed s/-1//";
          interval = 120;
          tooltip = false;
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

        "custom/powermenu" = {
          format = if systemOptions.deviceIsSteamDeck then "  󰊴  " else "  ⏻  ";
          on-click = "wleave";
          tooltip = false;
        };

        "pulseaudio" = {
          "format" = "{icon}  {volume}%";
          "format-muted" = "  XX";
          "format-icons" = {
            "default" = [
              ""
              ""
              ""
            ];
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
          "custom/user"
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

        "custom/user" = {
          "format" = "  {}";
          "exec" = "whoami";
          "interval" = "once";
          "tooltip" = false;
        };

        "custom/display" = {
          "format" = "  {}";
          "exec" =
            "cat ${config.home.homeDirectory}/.config/current_screen_layout | tr '[:lower:]' '[:upper:]'";
          "interval" = 5;
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

        "backlight" = {
          "format" = "󰃟  {percent}%";
          "scroll-step" = 10;
          "tooltip" = false;
        };

        "battery" = {
          "format" = "{icon}  {capacity}%";
          "tooltip" = false;
          "interval" = 120;
          "format-icons" = {
            "default" = [
              "󰂎"
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󱈏"
            ];
            "charging" = [ "󰂄" ];
          };
        };

        "cpu" = {
          "format" = "  {usage}%";
          "tooltip" = false;
        };

        "cpu#freq" = {
          "format" = "{avg_frequency:0.1f}GHz";
          "tooltip" = false;
        };

        "temperature" = lib.mkIf (systemOptions.sensorTempCpu != null) {
          "hwmon-path" = [ systemOptions.sensorTempCpu ];
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

        "temperature#disk" = lib.mkIf (systemOptions.sensorTempDisk != null) {
          "hwmon-path" = [ systemOptions.sensorTempDisk ];
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
