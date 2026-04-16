{
  config,
  lib,
  pkgs,
  userProperties,
  ...
}:
{
  users.users.${userProperties.username} = {
    isNormalUser = true;
    hashedPassword = "$6$1QJS.s3YyMOb8P9T$4/udjDW7RTOQD/SrxPIDihKD1T.2R6kOHOUSFZxhgg376.apJaGkWECkRU5WIhm6B2XC/M8sshRDwvLDckkuz0";
    extraGroups = [
      "wheel"
      "dialout"
      "plugdev"
      "netdev"
      "cdrom"
      "floppy"
      "adbusers"
      "audio"
      "video"
    ];
    packages = with pkgs; [
      htop
      nixfmt-rfc-style
    ];
  };

  services.greetd = lib.mkIf config.systemOptions.enableAutologin {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "${userProperties.username}";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'AUTHORIZED ACCESS ONLY' --asterisks --remember --remember-user-session --time --issue --cmd ${pkgs.hyprland}/bin/Hyprland";
        user = "greeter";
      };
    };
  };
}
