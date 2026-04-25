{
  inputs,
  lib,
  config,
  pkgs,
  active-home-manager,
  ...
}:
{
  imports = [
    active-home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };

    useGlobalPkgs = true;
    useUserPackages = true;

    users.${config.userOptions.username} = {
      home = {
        stateVersion = config.userOptions.homeManagerStateVersion;

        username = "${config.userOptions.username}";
        homeDirectory = "/home/${config.userOptions.username}";

        sessionVariables = {
          EDITOR = "nano";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "Hyprland";
          XDG_CURRENT_DESKTOP = "Hyprland";
          NIXOS_OZONE_WL = "1";
          QT_QPA_PLATFORM = "wayland";
          SDL_VIDEODRIVER = "wayland";
          _JAVA_AWT_WM_NONREPARENTING = "1";
        };

        packages = with pkgs; [
          htop
          nixfmt-rfc-style
        ];
      };

      imports = [
        ./options.nix
      ]
      ++ lib.lists.map (directoryName: ./${directoryName}) (
        builtins.attrNames (
          lib.attrsets.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)
        )
      );
    };
  };
}
