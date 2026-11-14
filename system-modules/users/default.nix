{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets.user-raptor-password.neededForUsers = true;

  users.users.${config.userOptions.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    hashedPasswordFile = config.sops.secrets.user-raptor-password.path;
    extraGroups = [
      "wheel"
      "dialout"
      "plugdev"
      "netdev"
      "cdrom"
      "floppy"
      "audio"
      "video"
      "input"
    ];
  };

  services.greetd = lib.mkMerge [
    (lib.mkIf (config.systemOptions.enableAutologin && config.systemOptions.windowManager == "hyprland")
      {
        enable = true;
        settings = {
          initial_session = {
            command = "${pkgs.bash}/bin/bash -l -c start-hyprland";
            user = "${config.userOptions.username}";
          };
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'AUTHORIZED ACCESS ONLY' --asterisks --remember --remember-user-session --time --issue --cmd '${pkgs.bash}/bin/bash -l -c start-hyprland'";
            user = "greeter";
          };
        };
      }
    )

    (lib.mkIf
      (config.systemOptions.enableAutologin && config.systemOptions.windowManager == "gamescope")
      {
        enable = true;
        settings = {
          default_session = {
            command = "${lib.getExe pkgs.gamescope} -e -f --xwayland-count 2 --hdr-enabled --hdr-itm-enabled -- ${lib.getExe pkgs.steam} -gamepadui -steamdeck -steamos3 > /dev/null 2>&1";
            user = "${config.userOptions.username}";
          };
        };
      }
    )
  ];
}
