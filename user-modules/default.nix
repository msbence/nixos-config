{
  inputs,
  lib,
  userProperties,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit userProperties;
    };

    useGlobalPkgs = true;
    useUserPackages = true;

    users.${userProperties.username} = {
      home = {
        stateVersion = "24.11";

        username = "${userProperties.username}";
        homeDirectory = "/home/${userProperties.username}";
      };

      imports = lib.lists.map (directoryName: ./${directoryName}) (
        builtins.attrNames (
          lib.attrsets.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)
        )
      );
    };
  };
}
