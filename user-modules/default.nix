{
  inputs,
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

      imports = [
        ./git
      ];
    };
  };
}
