{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets.user-raptor-password = { };

  users.users.${config.userOptions.username} = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.user-raptor-password.path;
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
        user = "${config.userOptions.username}";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'AUTHORIZED ACCESS ONLY' --asterisks --remember --remember-user-session --time --issue --cmd ${pkgs.hyprland}/bin/Hyprland";
        user = "greeter";
      };
    };
  };
}
