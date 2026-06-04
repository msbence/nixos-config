{
  description = "NixOS flake containing the main configuration";

  inputs = {
    ###> STABLE
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ###<

    ###> UNSTABLE
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    stylix-unstable = {
      url = "github:nix-community/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    ###<

    ###> OTHERS
    preservation.url = "github:nix-community/preservation";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    refind-nix.url = "github:msbence/refind-nix";
    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";
    future-hyprcursor.url = "github:mvayk/nix-future-hyprcursor";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ###<
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    {
      nixosConfigurations = builtins.listToAttrs (
        # 4: "flatten the list of hosts to one single attributeSet"
        map
          (hostName: {
            # 3: build an attributeSet with the hostname as key, and the host configuration as value
            name = hostName;
            value = (import ./hosts/${hostName} { inherit inputs; });
          })
          (
            (builtins.filter (name: (builtins.readDir ./hosts).${name} == "directory") (
              # 2: since we have no lib.attrsets.filterAttrs here, filter for dir one-by-one
              builtins.attrNames (builtins.readDir ./hosts) # 1: reading dir and file names under "hosts"
            ))
          )
      );

      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
