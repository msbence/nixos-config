{
  config,
  lib,
  pkgs,
  systemProperties,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  programs.nix-ld.enable = true;
  programs.dconf.enable = true;
  services.envfs.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  services.libinput.enable = true;
  services.hardware.bolt.enable = true;

  #  environment = {
  #  sessionVariables = {
  #    FLAKE = "/home/${user}/nixos-config";
  #    EDITOR = "nano";
  #    NIXOS_OZONE_WL = "1";
  #    SDL_VIDEODRIVER = "wayland";
  #    _JAVA_AWT_WM_NONREPARENTING = "1";
  #    QT_QPA_PLATFORM = "wayland";
  #    XDG_CURRENT_DESKTOP = "Hyprland";
  #    XDG_SESSION_TYPE = "wayland";
  #    XDG_SESSION_DESKTOP = "Hyprland";
  #  };
  #
  #  pathsToLink = [
  #    "/share/xdg-desktop-portal"
  #    "/share/applications"
  #  ];
  #};

  #tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  #session = "${pkgs.hyprland}/bin/Hyprland";
  #services.greetd = {
  #  enable = true;
  #  settings = {
  #    initial_session = {
  #      command = "${session}";
  #      user = "${user}";
  #    };
  #    default_session = {
  #      command = "${tuigreet} --greeting 'AUTHORIZED ACCESS ONLY' --asterisks --remember --remember-user-session --time --cmd ${session}";
  #      user = "greeter";
  #    };
  #  };
  #};
  #services.openvpn.servers = {
  #  PLATOMICS = {
  #    config = ''config /home/${user}/nixos-config/hosts/${hostname}/vpn-configs/PLATOMICS.conf '';
  #    updateResolvConf = true;
  #    autoStart = false;
  #  };
  #};
  #services.gns3-server = {
  #  enable = true;
  #  dynamips.enable = true;
  #  ubridge.enable = true;
  #  vpcs.enable = true;
  #};

  system.stateVersion = "24.11";
}
