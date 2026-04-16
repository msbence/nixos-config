{
  inputs,
  lib,
  config,
  userProperties,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit userProperties;
    };

    useGlobalPkgs = true;
    useUserPackages = true;

    users.${userProperties.username} = {
      home = {
        stateVersion = "25.05";

        username = "${userProperties.username}";
        homeDirectory = "/home/${userProperties.username}";

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
      };

      imports =
        lib.lists.map (directoryName: ./${directoryName}) (
          builtins.attrNames (
            lib.attrsets.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)
          )
        )
        ++ [ ];
    };
  };
}
