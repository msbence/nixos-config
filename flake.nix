{
  description = "NixOS flake containing the main configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations = builtins.listToAttrs ( # 4: "flatten the list of hosts to one single attributeSet"
        map
          (hostName: { # 3: build an attributeSet with the hostname as key, and the host configuration as value
            name = hostName;
            value = (import ./hosts/${hostName} { inherit inputs nixpkgs; });
          })
          (
            (builtins.filter (name: (builtins.readDir ./hosts).${name} == "directory") ( # 2: since we have no lib.attrsets.filterAttrs here, filter for dir one-by-one
              builtins.attrNames (builtins.readDir ./hosts) # 1: reading dir and file names under "hosts"
            ))
          )
      );
    };
}
