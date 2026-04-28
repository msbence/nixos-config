{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      pkgs.hyprlandPlugins.hy3
      pkgs.hyprlandPlugins.hyprbars
    ];

    extraConfig = ''
      source = ~/.config/hypr/monitors.conf
      
      plugin {
        hyprbars {
          bar_height = 24
          bar_color = rgb(1f3a5b)
          col.text = rgb(c0d9f9)
          bar_text_align = left
          bar_text_font = DejaVu Sans
          bar_text_size = 10
          bar_part_of_window = true
          bar_precedence_over_border = true
        }
      }
    '';

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "nemo";
      "$menu" = "anyrun";

      exec-once = [ ];

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, D, exec, $menu"
        "$mod, L, exec, hyprlock"
        "$mod, C, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mod&Shift_L, C, exec, hyprpicker -a -n"
        "$mod&Shift_L, E, exit,"
        "$mod&Shift_L, Q, killactive,"
        "$mod&Shift, Space, togglefloating,"
        "$mod, F, fullscreen, 1"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, V, hy3:makegroup, v"
        "$mod, H, hy3:makegroup, h"
        "$mod, X, exec, bash ~/nixos-config/home-packages/hyprland/scripts/menu_shutdown.sh"

        "$mod, left, hy3:movefocus, l"
        "$mod, right, hy3:movefocus, r"
        "$mod, up, hy3:movefocus, u"
        "$mod, down, hy3:movefocus, d"
        "$mod&Shift, left, hy3:movewindow, l"
        "$mod&Shift, right, hy3:movewindow, r"
        "$mod&Shift, up, hy3:movewindow, u"
        "$mod&Shift, down, hy3:movewindow, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod&Shift, 1, movetoworkspace, 1"
        "$mod&Shift, 2, movetoworkspace, 2"
        "$mod&Shift, 3, movetoworkspace, 3"
        "$mod&Shift, 4, movetoworkspace, 4"
        "$mod&Shift, 5, movetoworkspace, 5"
        "$mod&Shift, 6, movetoworkspace, 6"
        "$mod&Shift, 7, movetoworkspace, 7"
        "$mod&Shift, 8, movetoworkspace, 8"
        "$mod&Shift, 9, movetoworkspace, 9"
        "$mod&Shift, 0, movetoworkspace, 10"

        "$mod, S, togglespecialworkspace, magic"
        "$mod&Shift, S, movetoworkspace, special:magic"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mod, mouse:272, hy3:movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
      ];

      env = [
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
        "HYPRCURSOR_SIZE,24"
      ];

      input = {
        kb_layout = "gb,hu";
        kb_options = "grp:alt_shift_toggle";

        touchpad = {
          natural_scroll = false;
        };
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col\.active_border" = "rgb(c0d9f9)";
        "col\.inactive_border" = "rgb(1f3a5b)";
        resize_on_border = true;
        layout = "hy3";
      };

      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 0.8;

        #drop_shadow = true;
        #shadow_range = 4;
        #shadow_render_power = 3;
        #"col\.shadow" = "rgba(1f3a5bee)";

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 3, myBezier"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 5, default"
          "borderangle, 1, 4, default"
          "fade, 1, 3, default"
          "workspaces, 1, 3, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      gestures = {
        gesture = "3, horizontal, workspace";
      };

      misc = {
        "disable_hyprland_logo" = true;
      };
    };
  };
}
