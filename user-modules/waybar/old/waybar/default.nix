{ ... }:
{
  programs.waybar = {
    enable = false;
    systemd.enable = true;

    settings = {
      topBar = {
        layer = "top";
        position = "top";
        height = 30;
        #output = [ "eDP-1" ];
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ ];
        modules-right = [
          "custom/vpn"
          "network"
          "bluetooth"
          "pulseaudio"
          "backlight"
          "battery"
          "clock"
          "custom/name"
        ];

        "hyprland/workspaces" = {
          all-outputs = false;
        };

        "custom/vpn" = {
          exec = ./scripts/get_vpn.sh;
          on-click = ./scripts/set_vpn.sh;
          interval = 5;
          tooltip = false;
        };

        "network" = {
          format = "{ifname}";
          format-wifi = "NETWORK {ipaddr}/{cidr} [WLAN {essid} {signalStrength}%]";
          format-ethernet = "NETWORK {ipaddr}/{cidr} [ETH]";
          format-disconnected = "";
          interval = 10;
          tooltip = false;
        };

        "bluetooth" = {
          format = "BLUETOOTH ON";
          format-connected = "BLUETOOTH [{device_alias}]";
          format-connected-battery = "BLUETOOTH [{device_alias} {device_battery_percentage}%]";
        };

        "pulseaudio" = {
          format = "VOLUME {volume}%";
          format-bluetooth = "VOLUME {volume}% [BT]";
          format-muted = "VOLUME 0% [MUTED]";
          scroll-step = 5;
          on-click = "alacritty -e pulsemixer";
          tooltip = false;
        };

        "backlight" = {
          device = "intel_backlight";
          format = "BACKLIGHT {percent}%";
          on-scroll-up = "brightnessctl set 10%+";
          on-scroll-down = "brightnessctl set 10%-";
          tooltip = false;
        };

        "battery" = {
          states = {
            normal = 98;
            full = 100;
          };
          format = "BATTERY {capacity}% {time}";
          format-charging = "BATTERY {capacity}% [CHG {time}]";
          format-full = "BATTERY {capacity}% [FULL]";
          full-at = 99;
          interval = 5;
          tooltip = false;
        };

        "clock" = {
          format = "DATETIME {:%Y-%m-%d  %H:%M:%OS}";
          interval = 1;
          tooltip = false;
        };

        "custom/name" = {
          format = "BENCE MADARASZ";
          tooltip = false;
        };
      };

      bottomBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        #output = [ "eDP-1" ];
        modules-left = [
          "memory"
          "custom/swap"
          "cpu"
          "temperature"
          "custom/docker"
          "custom/screenlayout"
          "hyprland/language"
        ];
        modules-center = [ ];
        modules-right = [ "tray" ];

        "hyprland/language" = {
          "format" = "{short}";
        };
        "custom/screenlayout" = {
          "exec" = "cat $HOME/.current_screenlayout";
          "format" = "{} SCREENLAYOUT";
          "interval" = 5;
          "tooltip" = false;
        };
        "custom/docker" = {
          "exec" = ./scripts/get_docker.sh;
          "interval" = 5;
          "tooltip" = false;
        };
        "temperature" = {
          "format" = "CORE TEMPERATURE {temperatureC}°C";
          "critical-threshold" = 80;
          "thermal-zone" = 2;
          "tooltip" = false;
        };
        "cpu" = {
          "interval" = 5;
          "format" = "CPU {usage}% [{avg_frequency:0.1f}GHz]";
          "tooltip" = false;
        };
        "custom/swap" = {
          "exec" = ./scripts/get_swap.sh;
          "interval" = 5;
          "tooltip" = false;
        };
        "memory" = {
          "interval" = 5;
          "format" = "MEMORY {percentage}% [{used:0.1f}G/{total:0.1f}G]";
          "tooltip" = false;
        };
        "tray" = {
          "icon-size" = 21;
          "spacing" = 10;
          "tooltip" = false;
        };
      };
    };

    style = builtins.readFile ./style.css;
  };
}
